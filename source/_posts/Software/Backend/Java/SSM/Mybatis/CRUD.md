---
title: Mybatis CRUD操作
categories:
- Software
- Backend
- Java
- SSM
- Mybatis
---
# Mybatis CRUD操作

- **resultType**:SQL语句返回值类型(完整的类名或者别名)
- **parameterType**:传入SQL语句的参数类型
- 接口中的方法名与映射文件中的SQL语句ID 一一对应
- 所有的增删改操作都需要提交事务
- 接口所有的普通参数, 尽量都写上@Param参数
- 有时候根据业务的需求, 可以考虑使用map传递参数
- 为了规范操作, 在SQL的配置文件中, 尽量编写Parameter参数和resultType参数

## select

### 实例

#### 根据id查询用户

1. 在UserMapper中添加对应方法

```java
public interface UserMapper {
   //查询全部用户
   List<User> selectUser();
   //根据id查询用户
   User selectUserById(int id);
}
```

2. 在UserMapper.xml中添加Select语句

```xml
<select id="selectUserById" resultType="com.example.pojo.User">
select * from user where id = #{id}
</select>
```

3. 测试类中测试

```java
@Test
public void tsetSelectUserById() {
   SqlSession session = MybatisUtils.getSession();  //获取SqlSession连接
   UserMapper mapper = session.getMapper(UserMapper.class);
   User user = mapper.selectUserById(1);
   System.out.println(user);
   session.close();
}
```

#### 根据密码和名字查询用户(使用Map)

1. 在接口方法中, 参数直接传递Map

```java
User selectUserByNP2(Map<String,Object> map);
```

2. 编写sql语句的时候, 需要传递参数类型, 参数类型为map

```xml
<select id="selectUserByNP2" parameterType="map"cresultType="com.example.pojo.User">
  select * from user where name = #{username} and pwd = #{pwd}
</select>
```

3. 在使用方法的时候, Map的 key 为 sql中取的值即可, 没有顺序要求

```java
Map<String, Object> map = new HashMap<String, Object>();
map.put("username","小明");
map.put("pwd","123456");
User user = mapper.selectUserByNP2(map);
```

**总结**:如果参数过多, 可以考虑直接使用Map实现, 如果参数比较少, 直接传递参数即可

###  分页

#### limit实现分页

1. 修改Mapper文件

```xml
<select id="selectUser" parameterType="map" resultType="user">
  select * from user limit #{offset},#{pageSize}
</select>
```

2. Mapper接口, 参数为map

```java
//选择全部用户实现分页
List<User> selectUser(Map<String,Integer> map);
```

3. 在测试类中传入参数测试
    - 推断:起始位置 =  (当前页面 - 1 ) * 页面大小

```java
//分页查询 , 两个参数startIndex , pageSize
@Test
public void testSelectUser(int currentPage, int pageSize) {
   SqlSession session = MybatisUtils.getSession();
   UserMapper mapper = session.getMapper(UserMapper.class);

   Map<String,Integer> map = new HashMap<String,Integer>();
   map.put("offset",(currentPage-1)*pageSize);
   map.put("pageSize",pageSize);

   List<User> users = mapper.selectUser(map);

   for (User user: users){
       System.out.println(user);
  }

   session.close();
}
```

#### RowBounds分页

- 除了使用Limit在SQL层面实现分页, 也可以使用RowBounds在Java代码层面实现分页

1. mapper接口

```java
//选择全部用户RowBounds实现分页
List<User> getUserByRowBounds();
```

2. mapper文件

```xml
<select id="getUserByRowBounds" resultType="user">
select * from user
</select>
```

3. 测试类

```java
@Test
public void testUserByRowBounds(int currentPage, int pageSize) {
   SqlSession session = MybatisUtils.getSession();

   RowBounds rowBounds = new RowBounds((currentPage-1)*pageSize,pageSize);

   //通过session的方法进行传递rowBounds, [此种方式现在已经不推荐使用了]
   List<User> users =session.selectList("com.example.mapper.UserMapper.getUserByRowBounds", null, rowBounds);

   for (User user: users){
       System.out.println(user);
  }
   session.close();
}
```

## insert

### 实例

#### 给数据库增加一个用户

1. 在UserMapper接口中添加对应的方法

```java
//添加一个用户
int addUser(User user);
```

2. 在UserMapper.xml中添加insert语句

```xml
<insert id="addUser" parameterType="com.example.pojo.User">
    insert into user (id,name,pwd) values (#{id},#{name},#{pwd})
</insert>
```

3. 测试

```java
@Test
public void testAddUser() {
   SqlSession session = MybatisUtils.getSession();
   UserMapper mapper = session.getMapper(UserMapper.class);
   User user = new User(5,"王五","zxcvbn");
   int i = mapper.addUser(user);
   System.out.println(i);
   session.commit(); //提交事务,不写的话不会提交到数据库
   session.close();
}
```

**注意**:增, 删, 改操作需要提交事务

## update

### 实例

#### 修改用户的信息

1. 编写接口方法

```java
//修改一个用户
int updateUser(User user);
```

2. 编写对应的配置文件SQL

```xml
<update id="updateUser" parameterType="com.example.pojo.User">
  update user set name=#{name},pwd=#{pwd} where id = #{id}
</update>
```

3. 测试

```java
@Test
public void testUpdateUser() {
   SqlSession session = MybatisUtils.getSession();
   UserMapper mapper = session.getMapper(UserMapper.class);
   User user = mapper.selectUserById(1);
   user.setPwd("asdfgh");
   int i = mapper.updateUser(user);
   System.out.println(i);
   session.commit(); //提交事务,不写的话不会提交到数据库
   session.close();
}
```

## delete

### 实例

#### 根据id删除一个用户

1. 编写接口方法

```java
//根据id删除用户
int deleteUser(int id);
```

2. 编写对应的配置文件SQL

```xml
<delete id="deleteUser" parameterType="int">
  delete from user where id = #{id}
</delete>
```

3. 测试

```java
@Test
public void testDeleteUser() {
   SqlSession session = MybatisUtils.getSession();
   UserMapper mapper = session.getMapper(UserMapper.class);
   int i = mapper.deleteUser(5);
   System.out.println(i);
   session.commit(); //提交事务,不写的话不会提交到数据库
   session.close();
}
```

