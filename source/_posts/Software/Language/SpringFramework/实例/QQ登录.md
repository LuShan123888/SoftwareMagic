---
title: Spring Boot 整合QQ登录
categories:
  - Software
  - Language
  - SpringFramework
  - 实例
---
# Spring Boot 整合QQ登录

## 网站应用及移动应用接入申请

- 应用接入前，首先需进行申请https://wiki.connect.qq.com，获得对应的appid与appkey，以保证后续流程中可正确对网站与用户进行验证与授权。

## pom.xml

```xml
<dependency>
    <groupId>net.gplatform</groupId>
    <artifactId>Sdk4J</artifactId>
    <version>2.0</version>
</dependency
```

## Controller

```java
@Controller
public class LoginController {

    @RequestMapping("/")
    public String login(){
        return "login";
    }

    /**
     * 请求QQ登录。
     */
    @RequestMapping("/loginByQQ")
    public void loginByQQ(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            response.sendRedirect(new Oauth().getAuthorizeURL(request));
            System.out.println("请求QQ登录，开始跳转...");
        } catch (QQConnectException | IOException e) {
            e.printStackTrace();
        }
    }
    /**
     * QQ登录回调地址。
     *
     * @return
     */
    @RequestMapping("/connection")
    public String connection(HttpServletRequest request, HttpServletResponse response, Map<String,Object> map) {
        try {
            AccessToken accessTokenObj = (new Oauth()).getAccessTokenByRequest(request);
            String accessToken = null, openID = null;
            long tokenExpireIn = 0L;
            if ("".equals(accessTokenObj.getAccessToken())) {
                System.out.println("登录失败：没有获取到响应参数");
                return "accessTokenObj=>" + accessTokenObj + "; accessToken" + accessTokenObj.getAccessToken();
            } else {
                accessToken = accessTokenObj.getAccessToken();
                tokenExpireIn = accessTokenObj.getExpireIn();
                System.out.println("accessToken" + accessToken);
                request.getSession().setAttribute("demo_access_token", accessToken);
                request.getSession().setAttribute("demo_token_expirein", String.valueOf(tokenExpireIn));

                // 利用获取到的accessToken 去获取当前用的openid -------- start
                OpenID openIDObj = new OpenID(accessToken);
                openID = openIDObj.getUserOpenID();

                UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
                UserInfoBean userInfoBean = qzoneUserInfo.getUserInfo();
                if (userInfoBean.getRet() == 0) {
                    String name = removeNonBmpUnicode(userInfoBean.getNickname());
                    String imgUrl = userInfoBean.getAvatar().getAvatarURL100();
                    map.put("openId",openID);
                    map.put("name",name);
                    map.put("imgUrl",imgUrl);
                } else {
                    System.out.println("很抱歉，我们没能正确获取到您的信息，原因是：" + userInfoBean.getMsg());
                }
            }
        } catch (QQConnectException e) {
            e.printStackTrace();
        }
        return "index";
    }

    /**
     * 处理掉QQ网名中的特殊表情。
     * @param str
     * @return
     */
    public String removeNonBmpUnicode(String str) {
        if (str == null) {
            return null;
        }
        str = str.replaceAll("[^\\u0000-\\uFFFF]", "");
        if ("".equals(str)) {
            str = "(* _ *)";
        }
        return str;
    }
}
```