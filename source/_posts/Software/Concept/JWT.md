---
title: JWT
categories:
- Software
- Concept
---
# JWT

- JSON Web Token（简称 JWT）是目前最流行的**跨域认证**解决方案。是一种**认证授权机制**。
- JWT 的认证方式类似于**临时的证书签名**, 并且是一种服务端无状态的认证方式, 非常适合于 REST API 的场景. 所谓无状态就是服务端并不会保存身份认证相关的数据
- JWT 是自包含的（内部包含了一些会话信息），因此减少了需要查询数据库的需要
-  JWT 并不使用 Cookie 的，所以你可以使用任何域名提供你的 API 服务而不需要担心跨域资源共享问题（CORS）
-  JWT默认不加密，但可以加密。生成原始令牌后，可以使用改令牌再次对其进行加密。
-  JWT的最大缺点是服务器不保存会话状态，所以在使用期间不可能取消令牌或更改令牌的权限。也就是说，一旦JWT签发，在有效期内将会一直有效。
-  JWT本身包含认证信息，因此一旦信息泄露，任何人都可以获得令牌的所有权限。为了减少盗用，JWT的有效期不宜设置太长。对于某些重要操作，用户在使用时应该每次都进行进行身份验证。
-  为了减少盗用和窃取，JWT不建议使用HTTP协议来传输代码，而是使用加密的HTTPS协议进行传输。

> **基于JWT的验证原理**
>
> 1. 客户端通过用户名和密码登录服务器,服务端对客户端身份进行验证
> 2. 服务端会通过一些算法对该用户生成Token，如常用的HMAC-SHA256算法，然后通过BASE64编码将这个token发送给客户端
> 3. 客户端将Token保存到本地浏览器，一般保存到localStroage中
> 4. 客户端发起请求，需要请求头的 Authorization 字段中使用Bearer 模式添加 JWT
> 5. 服务端的保护路由将会检查请求头 Authorization 中的 JWT 信息，如果合法，则允许用户的行为
>
> <img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-05-1010726-20191103045557729-778248059.png" alt="img" style="zoom:50%;" />　　

## JWT格式

- JWT 的三个部分依次如下:
  - Header（头部）
  - Payload（负载）
  - Signature（签名）

### Header

- Header 部分是一个 JSON 对象，描述 JWT 的元数据，通常是下面的样子。

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

- 上面代码中，`alg`属性表示签名的算法（algorithm），默认是 HMAC SHA256（写成 HS256）；`typ`属性表示这个令牌（token）的类型（type），JWT 令牌统一写为`JWT`。
- 最后，将上面的 JSON 对象使用 Base64URL 算法（详见后文）转成字符串。

### Payload

- Payload 部分也是一个 JSON 对象，用来存放实际需要传递的数据。JWT 规定了7个官方字段供选用
  - iss (issuer)：签发人
  - exp (expiration time)：过期时间
  - sub (subject)：主题
  - aud (audience)：受众
  - nbf (Not Before)：生效时间
  - iat (Issued At)：签发时间
  - jti (JWT ID)：编号
- 除了官方字段，你还可以在这个部分定义私有字段，下面就是一个例子。

```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

- 注意，JWT 默认是不加密的，任何人都可以读到，所以不要把秘密信息放在这个部分。
- 这个 JSON 对象也要使用 Base64URL 算法转成字符串。

### Signature

- Signature 部分是对前两部分的签名，防止数据篡改。
- 首先，需要指定一个密钥（secret）。这个密钥只有服务器才知道，不能泄露给用户。然后，使用 Header 里面指定的签名算法（默认是 HMAC SHA256），按照下面的公式产生签名。

```javascript
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

- 算出签名以后，把 Header、Payload、Signature 三个部分拼成一个字符串，每个部分之间用"点"（`.`）分隔，就可以返回给用户。

## 编码JWT

```java
String token = Jwts.builder()
  // 放入用户名和用户ID
  .setId(selfUserEntity.getUserId()+"")
  // 主题
  .setSubject(selfUserEntity.getUsername())
  // 签发时间
  .setIssuedAt(new Date())
  // 签发者
  .setIssuer("sans")
  // 自定义属性 放入用户拥有权限
  .claim("authorities", JSON.toJSONString(selfUserEntity.getAuthorities()))
  // 失效时间
  .setExpiration(new Date(System.currentTimeMillis() + JWTConfig.expiration))
  // 签名算法和密钥
  .signWith(SignatureAlgorithm.HS512, JWTConfig.secret)
  .compact();
```

## 解码JWT

```java
Claims claims = Jwts.parser()
  .setSigningKey(JWTConfig.secret)
  .parseClaimsJws(token)
  .getBody();
String username = claims.getSubject();
String userId=claims.getId();
String authority = claims.get("authorities").toString();
```

