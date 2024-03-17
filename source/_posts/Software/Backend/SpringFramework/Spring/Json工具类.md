---
title: Spring 整合 JSON 工具类
categories:
- Software
- BackEnd
- SpringFramework
- Spring
---
# Spring 整合 JSON 工具类

## Jackson

- Spring MVC 默认使用Jackson

### pom.xml

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.9.8</version>
</dependency>
```

### ObjectMapper

**将实体类对象转换为Json字符串**

```java
@Controller
public class UserController {

    @RequestMapping("/json1")
    @ResponseBody
    public String json1() throws JsonProcessingException {
        // 创建一个jackson的对象映射器，用来解析数据。
        ObjectMapper mapper = new ObjectMapper();
        // 创建一个对象。
        User user = new User("test1", 3, "男");
        // 将我们的对象解析成为json格式。
        String str = mapper.writeValueAsString(user);
        // 由于@ResponseBody注解，这里会将str转成json格式返回，十分方便。
        return str;
    }

}
```

**将Json字符串转换为实体类对象**

```java
@Test
public void JacksonTest() {
    String json = "{\"userId\":\"123\",\"userName\":\"小明\",\"userPwd\":\"844099200000\"}";

    ObjectMapper mapper = new ObjectMapper();
    User user = null;
    try {
        user = mapper.readValue(json, User.class);
    } catch (JsonProcessingException e) {
        e.printStackTrace();
    }
    System.out.println(user);
}
```

**将集合转换为Json字符串**

```java
@RequestMapping("/json2")
public String json2() throws JsonProcessingException {

    // 创建一个jackson的对象映射器，用来解析数据。
    ObjectMapper mapper = new ObjectMapper();
    // 创建一个对象。
    User user1 = new User("test1", 3, "男");
    User user2 = new User("test2", 3, "男");
    User user3 = new User("test3", 3, "男");
    User user4 = new User("test4", 3, "男");
    List<User> list = new ArrayList<User>();
    list.add(user1);
    list.add(user2);
    list.add(user3);
    list.add(user4);

    // 将我们的对象解析成为json格式。
    String str = mapper.writeValueAsString(list);
    return str;
}
```

**将时间对象转换为Json字符串**

```java
@RequestMapping("/json3")
public String json3() throws JsonProcessingException {

    ObjectMapper mapper = new ObjectMapper();

    // 创建时间一个对象，java.util.Date
    Date date = new Date();
    // 将我们的对象解析成为json格式。
    String str = mapper.writeValueAsString(date);
    return str;
}
```

- **注意**：默认日期格式会变成一个数字，Jackson 默认是会把时间转成timestamps形式是1970年1月1日到当前日期的毫秒数。
- 自定义时间格式。

```java
@RequestMapping("/json4")
public String json4() throws JsonProcessingException {

    ObjectMapper mapper = new ObjectMapper();

    // 不使用时间戳的方式。
    mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    // 自定义日期格式对象。
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    // 指定日期格式。
    mapper.setDateFormat(sdf);

    Date date = new Date();
    String str = mapper.writeValueAsString(date);

    return str;
}
```

### 序列化与反序列化配置

#### @JsonFormat

- 使该属性按指定格式序列化与反序列化时间属性。
- **注意**：当前端传来json串，后台需要用@ReuqestBody接收， @JsonFormat才能实现反序列化。

```java
@PostMapping(value = "/date2")
public String date2(@RequestBody UserDto2 userDto2) {
    log.info(userDto2.toString());
    return "success";
}

@Data
public class UserDto2 {

    private String userId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime birthdayTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime graduationTime;
}
```

- **pattern**：与`SimpleDateFormat`的用法一致。
- **timezone**：时区。
- 如果日期字段为Date可以使用如下全局配置代替，优先级较字段注释更低。

```yml
spring:
	jackson:
		data-format: yyyy-MM-dd HH:mm:ss
		time-zone: GMT+8
```

#### @JsonIgnore

- 用于属性或者方法上，可使序列化过程忽略该属性。

```java
@JsonIgnore
private String orgName;
```

#### @JsonProperty

-  用于属性或set/get方法上，该属性序列化后可重命名。

```java
@JsonProperty("username")
private String name;
```

#### @JsonInclude

- 在某些策略下，加了该注解的字段不去序列化该字段。

```java
@JsonInclude(JsonInclude.Include.NON_NULL)
private String username;
```

- ALWAYS：默认策略，任何情况都执行序列化。
- NON_NULL:null不会序列化。
- NON_ABSENT:null不会序列化，但如果类型是AtomicReference，依然会被序列化。
- NON_EMPTY:null，集合数组等没有内容，空字符串等，都不会被序列化。
- NON_DEFAULT：如果字段是默认值，就不会被序列化。

#### @JsonSerialize

- 定制序列化器。

```java
@JsonSerialize(using = UserSerializer.class)
@JsonIgnoreProperties({"id", "name"}) // 序列化时忽略指定的属性，与 @JsonIgnore冲突时，以此处为准。
public class User {

    @JsonIgnore// 默认是true，与@JsonIgnore(true)同义，序列化时忽略该属性。
    private Integer id;

    @JsonIgnore(value = false)// 序列化时不忽略该属性。
    private String name;

    private Double grade;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")// 日期序列化时转化为该格式。
    private Date birthday;

    public User(Integer id, String name, Double grade, Date birthday) {
        this.id = id;
        this.name = name;
        this.grade = grade;
        this.birthday = birthday;
    }

    //get...set...
}


public class UserSerializer extends JsonSerializer<User> {
    DecimalFormat decimalFormat = new DecimalFormat("0.00");// 保留两位小数。

    @Override
    public void serialize(User value, JsonGenerator gen, SerializerProvider serializers) throws IOException, JsonProcessingException {
        gen.writeStartObject();
        gen.writeNumberField("id", value.getId());
        gen.writeStringField("name", value.getName());
        gen.writeNumberField("grade", Double.parseDouble(decimalFormat.format(value.getGrade())));
        gen.writeEndObject();

        /*      // 报错 Exception in thread "main" com.fasterxml.jackson.core.JsonGenerationException: Can not write a field name, expecting a value
        //gen.writeStartObject();
        gen.writeNumberField("grade", Double.parseDouble(decimalFormat.format(value.getGrade())));
        //gen.writeEndObject();
        //gen.writeStartObject();gen.writeEndObject();必须要写。
        */
    }
}
```

#### @JsonDeserialize

- 定制反序列化器：

```java
@PostMapping(value = "/date3")public String date3(@RequestBody UserDto3 userDto3) {
    log.info(userDto3.toString());
    return "success";
}

@Data
public class UserDto3 {

    private String userId;

    @JsonDeserialize(using = CustomLocalDateTimeDeserializer.class)
    private LocalDateTime birthdayTime;

    @JsonDeserialize(using = CustomLocalDateTimeDeserializer.class)
    private LocalDateTime graduationTime;

}

public class CustomLocalDateTimeDeserializer extends LocalDateTimeDeserializer {
    public CustomLocalDateTimeDeserializer() {
        super(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
```
#### Jackson2ObjectMapperBuilderCustomizer

- 直接修改MappingJackson2HttpMessageConverter中的ObjectMapper默认的序列化器和反序列化器，这样就能全局生效，不需要再使用其他注解或者定制序列化方案（当然，有些时候需要特殊处理定制)，或者说，在需要特殊处理的场景才使用其他注解或者定制序列化方案，使用钩子接口Jackson2ObjectMapperBuilderCustomizer可以实现ObjectMapper的属性定制：

```javascript
@Bean
public Jackson2ObjectMapperBuilderCustomizer jackson2ObjectMapperBuilderCustomizer(){
    return customizer->{
        customizer.serializerByType(LocalDateTime.class,new LocalDateTimeSerializer(
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
    customizer.deserializerByType(LocalDateTime.class,new LocalDateTimeDeserializer(
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
};
}
```

- 这样就能定制化MappingJackson2HttpMessageConverter中持有的ObjectMapper，上面的LocalDateTime序列化和反序列化器对全局生效。

## FastJson

- FastJson.jar是阿里开发的一款专门用于Java开发的包，可以方便的实现json对象与JavaBean对象的转换，实现JavaBean对象与json字符串的转换，实现json对象与json字符串的转换。

### pom.xml

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.60</version>
</dependency>
```

### JSONObject对象

- JSONObject实现了Map接口，猜想 JSONObject底层操作是由Map实现的。
- JSONObject对应json对象，通过各种形式的`get()`方法可以获取json对象中的数据，也可利用诸如`size()`,`isEmpty()`等方法获取"键：值"对的个数和判断是否为空，其本质是通过实现Map接口并调用接口中的方法完成的。

### JSONArray对象

- 代表 json 对象数组。
- 内部是有List接口中的方法来完成操作的。

### JSON工具类

- 实现JSON对象，JSON字符串和Bean对象的转化。

```java
public class FastJsonDemo {
    public static void main(String[] args) {
        // 创建一个对象。
        User user1 = new User("test1", 3, "男");
        User user2 = new User("test2", 3, "男");
        User user3 = new User("test3", 3, "男");
        User user4 = new User("test4", 3, "男");
        List<User> list = new ArrayList<User>();
        list.add(user1);
        list.add(user2);
        list.add(user3);
        list.add(user4);

        System.out.println("*******Java对象转 JSON字符串*******");
        String str1 = JSON.toJSONString(list);
        System.out.println("JSON.toJSONString(list)==>"+str1);
        String str2 = JSON.toJSONString(user1);
        System.out.println("JSON.toJSONString(user1)==>"+str2);

        System.out.println("\n****** JSON字符串转 Java对象*******");
        User jp_user1=JSON.parseObject(str2,User.class);
        System.out.println("JSON.parseObject(str2,User.class)==>"+jp_user1);

        System.out.println("\n****** Java对象转 JSON对象 ******");
        JSONObject jsonObject1 = (JSONObject) JSON.toJSON(user2);
        System.out.println("(JSONObject) JSON.toJSON(user2)==>"+jsonObject1.getString("name"));

        System.out.println("\n****** JSON对象转 Java对象 ******");
        User to_java_user = JSON.toJavaObject(jsonObject1, User.class);
        System.out.println("JSON.toJavaObject(jsonObject1, User.class)==>"+to_java_user);
    }
}
```

### 序列化

- 序列化时会默认过滤掉空值的键，如果不想过滤掉空值的键需要多传一个参数。

```java
JSON.toJSONString(object, SerializerFeature.WriteMapNullValue);
```