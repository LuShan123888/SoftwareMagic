---
title: Spring Boot 实现 Markdown 编辑与持久化
categories:
  - Software
  - BackEnd
  - SpringFramework
  - 实例
---
# Spring Boot 实现 Markdown 编辑与持久化

## 准备工作

### 数据库设计

- article：文章表。

| 字段    |          | 备注         |
| ------- | -------- | ------------ |
| id      | int      | 文章的唯一ID |
| author  | varchar  | 作者         |
| title   | varchar  | 标题         |
| content | longtext | 文章的内容   |

- 建表SQL:

```sql
CREATE TABLE `article` (
    `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'int文章的唯一ID',
    `author` varchar(50) NOT NULL COMMENT '作者',
    `title` varchar(100) NOT NULL COMMENT '标题',
    `content` longtext NOT NULL COMMENT '文章的内容',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

### 基础项目搭建

- 新建SpringBoot项目并创建如下配置文件。

```yaml
spring:
datasource:
  username: root
  password: 123456
  url: jdbc:mysql://localhost:3306/springboot?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8
  driver-class-name: com.mysql.cj.jdbc.Driver
```

- 实体类。

```java
// 文章类。
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Article implements Serializable {

    private int id; // 文章的唯一ID
    private String author; // 作者名。
    private String title; // 标题。
    private String content; // 文章的内容。

}
```

- mapper接口。

```java
@Mapper
@Repository
public interface ArticleMapper {
    // 查询所有的文章。
    List<Article> queryArticles();

    // 新增一个文章。
    int addArticle(Article article);

    // 根据文章id查询文章。
    Article getArticleById(int id);

    // 根据文章id删除文章。
    int deleteArticleById(int id);

}
<?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

    <mapper namespace="com.example.mapper.ArticleMapper">

    <select id="queryArticles" resultType="Article">
    select * from article
    </select>

    <select id="getArticleById" resultType="Article">
    select * from article where id = #{id}
</select>

    <insert id="addArticle" parameterType="Article">
    insert into article (author,title,content) values (#{author},#{title},#{content});
</insert>

    <delete id="deleteArticleById" parameterType="int">
    delete from article where id = #{id}
</delete>

    </mapper>
```

- Mybatis配置。

```yaml
mybatis:
  mapper-locations: classpath:com/example/mapper/*.xml
  type-aliases-package: com.example.entity
```

### 文章编辑整合

1. 导入[Editor.md](https://pandao.github.io/editor.md/）资源与jQuery
2. 编辑文章页面`editor.html`

```html
<!DOCTYPE html>
<html class="x-admin-sm" lang="zh" xmlns:th="http://www.thymeleaf.org">

    <head>
        <meta charset="UTF-8">
        <title>Blog</title>
        <meta name="renderer" content="webkit">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
        <!--Editor.md-->
        <link rel="stylesheet" th:href="@{/editormd/css/editormd.css}"/>
        <link rel="shortcut icon" href="https://pandao.github.io/editor.md/favicon.ico"type="image/x-icon" />
    </head>

    <body>

        <div class="layui-fluid">
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md12">
                    <!--博客表单-->
                    <form name="mdEditorForm">
                        <div>
                            标题：<input type="text" name="title">
                        </div>
                        <div>
                            作者：<input type="text" name="author">
                        </div>
                        <div id="article-content">
                            <textarea name="content" id="content" style="display:none;"> </textarea>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </body>

    <!--editormd-->
    <script th:src="@{/editormd/lib/jquery.min.js}"></script>
    <script th:src="@{/editormd/editormd.js}"></script>

    <script type="text/javascript">
        var testEditor;


        $(function() {
            testEditor = editormd("article-content", {
                width : "95%",
                height : 400,
                syncScrolling : "single",
                path : "../editormd/lib/",
                saveHTMLToTextarea : true,    // 保存 HTML 到 Textarea
                emoji: true,
                theme: "dark",// 工具栏主题。
                previewTheme: "dark",// 预览主题。
                editorTheme: "pastel-on-dark",// 编辑主题。
                tex : true,                   // 开启科学公式TeX语言支持，默认关闭。
                flowChart : true,             // 开启流程图支持，默认关闭。
                sequenceDiagram : true,       // 开启时序/序列图支持，默认关闭
                // 图片上传。
                imageUpload : true,
                imageFormats : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
                imageUploadURL : "/article/file/upload",
                onload : function() {
                    console.log('onload', this);
                },
                /*指定需要显示的功能按钮*/
                toolbarIcons : function() {
                    return ["undo","redo","|",
                            "bold","del","italic","quote","ucwords","uppercase","lowercase","|",
                            "h1","h2","h3","h4","h5","h6","|",
                            "list-ul","list-ol","hr","|",
                            "link","reference-link","image","code","preformatted-text",
                            "code-block","table","datetime","emoji","html-entities","pagebreak","|",
                            "goto-line","watch","preview","fullscreen","clear","search","|",
                            "help","info","releaseIcon", "index"]
                },

                /*自定义功能按钮，下面我自定义了2个，一个是发布，一个是返回首页*/
                toolbarIconTexts : {
                    releaseIcon : "<span bgcolor=\"gray\">发布</span>",
                    index : "<span bgcolor=\"red\">返回首页</span>",
                },

                /*给自定义按钮指定回调函数*/
                toolbarHandlers:{
                    releaseIcon : function(cm, icon, cursor, selection) {
                        // 表单提交。
                        mdEditorForm.method = "post";
                        mdEditorForm.action = "/article/addArticle";// 提交至服务器的路径。
                        mdEditorForm.submit();
                    },
                    index : function(){
                        window.location.href = '/';
                    },
                }
            });
        });
    </script>

</html>
```

- 编写Controller，进行跳转，以及保存文章。

```java
@Controller
@RequestMapping("/article")
public class ArticleController {

    @GetMapping("/toEditor")
    public String toEditor(){
        return "editor";
    }

    @PostMapping("/addArticle")
    public String addArticle(Article article){
        articleMapper.addArticle(article);
        return "editor";
    }

}
```

### 图片上传问题

- `editormd`中添加配置。

```js
// 图片上传。
imageUpload : true,
imageFormats : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
imageUploadURL : "/article/file/upload", // // 这个是上传图片时的访问地址。
```

- 后端请求接收保存这个图片，需要导入`FastJson`的依赖。

```java
@RequestMapping("/file/upload")
@ResponseBody
public JSONObject fileUpload(@RequestParam(value = "editormd-image-file", required= true) MultipartFile file, HttpServletRequest request) throws IOException {
    // 上传路径保存设置。

    // 获得SpringBoot当前项目的路径：System.getProperty("user.dir")
    String path = System.getProperty("user.dir")+"/upload/";

    // 按照月份进行分类：
    Calendar instance = Calendar.getInstance();
    String month = (instance.get(Calendar.MONTH) + 1)+"月";
    path = path+month;

    File realPath = new File(path);
    if (!realPath.exists()){
        realPath.mkdir();
    }

    // 上传文件地址。
    System.out.println("上传文件保存地址："+realPath);

    // 解决文件名字问题：我们使用uuid;
    String filename = "ks-"+UUID.randomUUID().toString().replaceAll("-", "");
    // 通过CommonsMultipartFile的方法直接写文件（注意这个时候）
    file.transferTo(new File(realPath +"/"+ filename));

    // 给editormd进行回调。
    JSONObject res = new JSONObject();
    res.put("url","/upload/"+month+"/"+ filename);
    res.put("success", 1);
    res.put("message", "upload success!");

    return res;
}
```

- 解决文件回显显示的问题，设置虚拟目录映射。

```java
@Configuration
public class MyMvcConfig implements WebMvcConfigurer {

    // 访问的时候使用虚路径，比如/upload/1.png映射到本机的file:user.dir/upload/1.png
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/upload/**")
            .addResourceLocations("file:"+System.getProperty("user.dir")+"/upload/");
    }

}
```

### 表情包问题

- 自己手动下载emoji 表情包并放到图片路径下。
- 修改`editormd.js`文件。

```js
// Emoji graphics files url path
editormd.emoji     = {
    path : "../editormd/plugins/emoji-dialog/emoji/",
    ext   : ".png"
};
```

### 文章展示

- Controller 中增加方法。

```java
@GetMapping("/{id}")
public String show(@PathVariable("id") int id,Model model){
    Article article = articleMapper.getArticleById(id);
    model.addAttribute("article",article);
    return "article";
}
```

- 编写页面`article.html`
- 导入[Editor.md](https://pandao.github.io/editor.md/）资源与jQuery

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <title th:text="${article.title}"></title>
    </head>
    <body>

        <div>
            <!--文章头部信息：标题，作者，最后更新日期，导航-->
            <h2 style="margin: auto 0" th:text="${article.title}"></h2>
            作者：<span style="float: left" th:text="${article.author}"></span>
            <!--文章主体内容-->
            <div id="doc-content">
                <textarea style="display:none;" placeholder="markdown"th:text="${article.content}"></textarea>
            </div>

        </div>

        <link rel="stylesheet" th:href="@{/editormd/css/editormd.preview.css}" />
        <script th:src="@{/editormd/lib/jquery.min.js}"></script>
        <script th:src="@{/editormd/lib/marked.min.js}"></script>
        <script th:src="@{/editormd/lib/prettify.min.js}"></script>
        <script th:src="@{/editormd/lib/raphael.min.js}"></script>
        <script th:src="@{/editormd/lib/underscore.min.js}"></script>
        <script th:src="@{/editormd/lib/sequence-diagram.min.js}"></script>
        <script th:src="@{/editormd/lib/flowchart.min.js}"></script>
        <script th:src="@{/editormd/lib/jquery.flowchart.min.js}"></script>
        <script th:src="@{/editormd/editormd.js}"></script>

        <script type="text/javascript">
            var testEditor;
            $(function () {
                testEditor = editormd.markdownToHTML("doc-content", {// 注意：这里是上面DIV的id
                    htmlDecode: "style,script,iframe",
                    emoji: true,
                    taskList: true,
                    tocm: true,
                    tex: true, // 默认不解析。
                    flowChart: true, // 默认不解析。
                    sequenceDiagram: true, // 默认不解析。
                    codeFold: true
                });});
        </script>
    </body>
</html>
```