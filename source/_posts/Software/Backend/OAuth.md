---
title: OAuth
categories:
- Software
- BackEnd
---
# OAuth

- OAuth是一种授权机制，数据的所有者告诉系统，同意授权第三方应用进入系统，获取这些数据，系统从而产生一个短期的进入令牌（token)，用来代替密码，供第三方应用使用。

## 令牌和密码

- 令牌（token)与密码（password)的作用是一样的，都可以进入系统，但是有三点差异。
    - 令牌是短期的，到期会自动失效，用户自己无法修改，密码一般长期有效，用户不修改，就不会发生变化。
    - 令牌可以被数据所有者撤销，会立即失效，以上例而言，屋主可以随时取消快递员的令牌，密码一般不允许被他人撤销。
    - 令牌有权限范围（scope)，比如只能进小区的二号门，对于网络服务来说，只读令牌就比读写令牌更安全，密码一般是完整权限。
- 上面这些设计，保证了令牌既可以让第三方应用获得权限，同时又随时可控，不会危及系统安全，这就是 OAuth 2.0 的优点。
- 注意，只要知道了令牌，就能进入系统，系统一般不会再次确认身份，所以令牌必须保密，泄漏令牌与泄漏密码的后果是一样的，这也是为什么令牌的有效期，一般都设置得很短的原因。

## RFC 6749

- OAuth 2.0 的标准是 [RFC 6749](https://tools.ietf.org/html/rfc6749) 文件。
- OAuth 引入了一个授权层，用来分离两种不同的角色：客户端和资源所有者。
- 资源所有者同意以后，资源服务器可以向客户端颁发令牌，客户端通过令牌，去请求数据。
- OAuth 的核心就是向第三方应用颁发令牌。
- OAuth 2.0 规定了四种获得令牌的流程：
    - 授权码（authorization-code)
    - 隐藏式（implicit)
    - 密码式（password)
    - 客户端凭证（client credentials)
- **注意**：不管哪一种授权方式，第三方应用申请令牌之前，都必须先到系统备案，说明自己的身份，然后会拿到两个身份识别码：客户端 ID(client ID)和客户端密钥（client secret)，这是为了防止令牌被滥用，没有备案过的第三方应用，是不会拿到令牌的。

## 授权方式

### 授权码

- 授权码（authorization code)方式，指的是第三方应用先申请一个授权码，然后再用该码获取令牌。
- 这种方式是最常用的流程，安全性也最高，它适用于那些有后端的 Web 应用，授权码通过前端传送，令牌则是储存在后端，而且所有与资源服务器的通信都在后端完成，这样的前后端分离，可以避免令牌泄漏。

> **步骤**
>
> 1. 用户访问客户端，后者将前者导向认证服务器。
> 2. 假设用户给予授权，认证服务器将用户导向客户端事先指定的"重定向URI"(redirection URI)，同时附上一个授权码。
> 3. 客户端收到授权码，附上早先的"重定向URI"，向认证服务器申请令牌，这一步是在客户端的后台的服务器上完成的，对用户不可见。
> 4. 认证服务器核对了授权码和重定向URI，确认无误后，向客户端发送访问令牌（access token)和更新令牌（refresh token)

1. A 网站提供一个链接，用户点击后就会跳转到 B 网站，授权用户数据给 A 网站使用，下面就是 A 网站跳转 B 网站的一个示意链接。

```shell
https://b.com/oauth/authorize?
response_type=code&
client_id=CLIENT_ID&
redirect_uri=CALLBACK_URL&
scope=read
```

- `response_type`：表示授权类型，必选项，此处的值固定为`code`
- `client_id`：表示客户端的ID，必选项。
- `redirect_uri`：表示重定向URI，可选项。
- `scope`：表示申请的权限范围，可选项。
- `state`：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019040902.jpg)

2. 用户跳转后，B网站会要求用户登录，然后询问是否同意给予 A 网站授权，如果用户表示同意，这时 B 网站就会跳回`redirect_uri`参数指定的网址，跳转时，会传回一个授权码，就像下面这样：

```shell
https://a.com/callback?code=AUTHORIZATION_CODE
```

- `code`：表示授权码，必选项，该码的有效期应该很短，通常设为10分钟，客户端只能使用该码一次，否则会被授权服务器拒绝，该码与客户端ID和重定向URI，是一一对应关系。
- `state`：如果客户端的请求中包含这个参数，认证服务器的回应也必须一模一样包含这个参数。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019040907.jpg)

3. A 网站拿到授权码以后，就可以在后端，向 B 网站请求令牌。

```shell
https://b.com/oauth/token?
client_id=CLIENT_ID&
client_secret=CLIENT_SECRET&
grant_type=authorization_code&
code=AUTHORIZATION_CODE&
redirect_uri=CALLBACK_URL
```

- `client_id`和`client_secret`：用来让 B 确认 A 的身份，其中`client_secret`参数是保密的，因此只能在后端发请求。
- `grant_type`：表示使用的授权模式，必选项，此处的值固定为"authorization_code"
- `code`：表示上一步获得的授权码，必选项。
- `redirect_uri`：表示重定向URI，必选项，且必须与步骤1中的该参数值保持一致。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019040904-20201210155049080.jpg)

4. B 网站收到请求以后，就会颁发令牌，具体做法是向`redirect_uri`指定的网址，发送一段 JSON 数据。

```json
{
"access_token":"ACCESS_TOKEN",
"token_type":"bearer",
"expires_in":2592000,
"refresh_token":"REFRESH_TOKEN",
"scope":"read",
"uid":100101,
"info":{...}
}
```

- `access_token`：表示访问令牌，必选项。
- `token_type`：表示令牌类型，该值大小写不敏感，必选项，可以是bearer类型或mac类型。
- `expires_in`：表示过期时间，单位为秒，如果省略该参数，必须其他方式设置过期时间。
- `refresh_token`：表示更新令牌，用来获取下一次的访问令牌，可选项。
- `scope`：表示权限范围，如果与客户端申请的范围一致，此项可省略。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019040905.jpg)

### 隐藏式

- 有些 Web 应用是纯前端应用，没有后端，这时就不能用上面的方式了，必须将令牌储存在前端。
- RFC 6749 就规定了第二种方式，允许直接向前端颁发令牌，这种方式没有授权码这个中间步骤，所以称为隐藏式。

> **步骤**
>
> 1. 客户端将用户导向认证服务器。
> 2. 假设用户给予授权，认证服务器将用户导向客户端指定的"重定向URI"，并在URI的Hash部分包含了访问令牌。
> 3. 浏览器向资源服务器发出请求，其中不包括上一步收到的Hash值。
> 4. 资源服务器返回一个网页，其中包含的代码可以获取Hash值中的令牌。
> 5. 浏览器执行上一步获得的脚本，提取出令牌。
> 6. 浏览器将令牌发给客户端。

1. A 网站提供一个链接，要求用户跳转到 B 网站，授权用户数据给 A 网站使用。

```shell
https://b.com/oauth/authorize?
response_type=token&
client_id=CLIENT_ID&
redirect_uri=CALLBACK_URL&
scope=read
```

- `response_type`：表示授权类型，此处的值固定为"token"，必选项。
- `client_id`：表示客户端的ID，必选项。
- `redirect_uri`：表示重定向的URI，可选项。
- `scope`：表示权限范围，可选项。
- `state`：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

2. 用户跳转到 B 网站，登录后同意给予 A 网站授权，这时，B 网站就会跳回`redirect_uri`参数指定的跳转网址，并且把令牌作为 URL 参数，传给 A 网站。

```bash
https://a.com/callback#
access_token=2YotnFZFEjr1zCsicMWpAA&
state=xyz&
token_type=example&
expires_in=3600
```

- `access_token`：表示访问令牌，必选项。
- `token_type`：表示令牌类型，该值大小写不敏感，必选项。
- `expires_in`：表示过期时间，单位为秒，如果省略该参数，必须其他方式设置过期时间。
- `scope`：表示权限范围，如果与客户端申请的范围一致，此项可省略。
- `state`：如果客户端的请求中包含这个参数，认证服务器的回应也必须一模一样包含这个参数。
- **注意**：令牌的位置是 URL 锚点（fragment)，而不是查询字符串（querystring)，这是因为 OAuth 2.0 允许跳转网址是 HTTP 协议，因此存在"中间人攻击"的风险，而浏览器跳转时，锚点不会发到服务器，就减少了泄漏令牌的风险。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019040906.jpg)

- 这种方式把令牌直接传给前端，是很不安全的，因此，只能用于一些安全要求不高的场景，并且令牌的有效期必须非常短，通常就是会话期间（session)有效，浏览器关掉，令牌就失效了。

### 密码式

- 如果你高度信任某个应用，RFC 6749 也允许用户把用户名和密码，直接告诉该应用，该应用就使用你的密码，申请令牌，这种方式称为"密码式"(password)
- 这种方式需要用户给出自己的用户名/密码，显然风险很大，因此只适用于其他授权方式都无法采用的情况，而且必须是用户高度信任的应用。

> **步骤**
>
> 1. 客户端将用户名和密码发给认证服务器，向后者请求令牌。
> 2. 认证服务器确认无误后，向客户端提供访问令牌。

1. A 网站要求用户提供 B 网站的用户名和密码，拿到以后，A 就直接向 B 请求令牌。

```bash
https://oauth.b.com/token?
grant_type=password&
username=USERNAME&
password=PASSWORD&
client_id=CLIENT_ID
```

- `grant_type`：表示授权类型，此处的值固定为"password"，必选项。
- `username`：表示用户名，必选项。
- `password`：表示用户的密码，必选项。
- `scope`：表示权限范围，可选项。

2. B 网站验证身份通过后，直接给出令牌，注意，这时不需要跳转，而是把令牌放在 JSON 数据里面，作为 HTTP 回应，A 因此拿到令牌。

```json
     {
       "access_token":"2YotnFZFEjr1zCsicMWpAA",
       "token_type":"example",
       "expires_in":3600,
       "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
       "example_parameter":"example_value"
     }
```

- `access_token`：表示访问令牌，必选项。
- `token_type`：表示令牌类型，该值大小写不敏感，必选项，可以是bearer类型或mac类型。
- `expires_in`：表示过期时间，单位为秒，如果省略该参数，必须其他方式设置过期时间。
- `refresh_token`：表示更新令牌，用来获取下一次的访问令牌，可选项。
- `scope`：表示权限范围，如果与客户端申请的范围一致，此项可省略。

### 凭证式

- 凭证式（client credentials)，适用于没有前端的命令行应用，即在命令行下请求令牌。
- 这种方式给出的令牌，是针对第三方应用的，而不是针对用户的，即有可能多个用户共享同一个令牌。

> **步骤**
>
> 1. 客户端向认证服务器进行身份认证，并要求一个访问令牌。
> 2. 认证服务器确认无误后，向客户端提供访问令牌。

1. A 应用在命令行向 B 发出请求。

```bash
https://oauth.b.com/token?
grant_type=client_credentials&
client_id=CLIENT_ID&
client_secret=CLIENT_SECRET
```

- `grant_type`：表示授权类型，参数`client_credentials`表示采用凭证式。
- `client_id`和`client_secret`：用来让 B 确认 A 的身份。
- `scope`：表示权限范围，可选项。

2. B 网站验证通过以后，直接返回令牌。

```json
     {
       "access_token":"2YotnFZFEjr1zCsicMWpAA",
       "token_type":"example",
       "expires_in":3600,
       "example_parameter":"example_value"
     }
```

- `access_token`：表示访问令牌，必选项。
- `token_type`：表示令牌类型，该值大小写不敏感，必选项，可以是bearer类型或mac类型。
- `expires_in`：表示过期时间，单位为秒，如果省略该参数，必须其他方式设置过期时间。
- `scope`：表示权限范围，如果与客户端申请的范围一致，此项可省略。

## 令牌的使用

- A 网站拿到令牌以后，就可以向 B 网站的 API 请求数据了。
- 此时，每个发到 API 的请求，都必须带有令牌，具体做法是在请求的头信息，加上一个`Authorization`字段，令牌就放在这个字段里面。

```bash
curl -H "Authorization: Bearer ACCESS_TOKEN" \
"https://api.b.com"
```

- 上面命令中，`ACCESS_TOKEN`就是拿到的令牌。

## 更新令牌

- 令牌的有效期到了，如果让用户重新走一遍上面的流程，再申请一个新的令牌，很可能体验不好，而且也没有必要，OAuth 2.0 允许用户自动更新令牌。

1. B 网站颁发令牌的时候，一次性颁发两个令牌，一个用于获取数据，另一个用于获取新的令牌（refresh token 字段）
2. 令牌到期前，用户使用 refresh token 发一个请求，去更新令牌：

```bash
https://b.com/oauth/token?
grant_type=refresh_token&
client_id=CLIENT_ID&
client_secret=CLIENT_SECRET&
refresh_token=REFRESH_TOKEN
```

- `grant_type`：表示使用的授权方式，参数为`refresh_token`表示要求更新令牌。
- `client_id`和`client_secret`：用于确认身份。
- `refresh_token`：就是用于更新令牌的令牌。
- `scope`：表示申请的授权范围，不可以超出上一次申请的范围，如果省略该参数，则表示与上一次一致。

3. B 网站验证通过以后，就会颁发新的令牌。

## Github OAuth 实例

### 第三方登录的原理

- 所谓第三方登录，实质就是 OAuth 授权。
- 用户想要登录 A 网站，A 网站让用户提供第三方网站的数据，证明自己的身份。
- 获取第三方网站的身份数据，就需要 OAuth 授权。
- 举例来说，A 网站允许 GitHub 登录，背后就是下面的流程。

> 1. A 网站让用户跳转到 GitHub
> 2. GitHub 要求用户登录，然后询问"A 网站要求获得 xx 权限，你是否同意？"
> 3. 用户同意，GitHub 就会重定向回 A 网站，同时发回一个授权码。
> 4. A 网站使用授权码，向 GitHub 请求令牌。
> 5. GitHub 返回令牌。
> 6. A 网站使用令牌，向 GitHub 请求用户数据。

### 应用登记

- 一个应用要求 OAuth 授权，必须先到对方网站登记，让对方知道是谁在请求。
- 访问这个[网址](https://github.com/settings/applications/new)，填写登记表。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201210162547810.png" alt="image-20201210162547810" style="zoom:50%;" />

- 提交表单以后，GitHub 应该会返回客户端 ID(client ID)和客户端密钥（client secret)，这就是应用的身份识别码。

### 浏览器跳转 GitHub

- 这个 URL 指向 GitHub 的 OAuth 授权网址。

```bash
https://github.com/login/oauth/authorize?
  client_id=7e015d8ce32370079895&
  redirect_uri=http://localhost:8080/oauth/redirect
```

- `client_id`告诉 GitHub 谁在请求。
- `redirect_uri`是稍后跳转回来的网址。

- 用户点击转到 GitHub,GitHub 会要求用户登录，确保是本人在操作。

### 获取授权码

- 登录后，GitHub 询问用户，该应用正在请求数据，你是否同意授权。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-bg2019042104.png)

- 如果用户同意授权，GitHub 就会跳转到`redirect_uri`指定的跳转网址，并且带上授权码：

```bash
http://localhost:8080/oauth/redirect?
  code=859310e7cecc9196f4af
```

- 后端收到这个请求以后，就拿到了授权码`code`

### 返回授权码

- 这里的关键是针对`/oauth/redirect`的请求，编写一个路由，完成 OAuth 认证。

```javascript
const oauth = async ctx => {
  // ...
};

app.use(route.get('/oauth/redirect', oauth));
```

- 上面代码中，`oauth`函数就是路由的处理函数，下面的代码都写在这个函数里面。
- 路由函数的第一件事，是从 URL 取出授权码。

```javascript
const requestToken = ctx.request.query.code;
```

### 请求令牌

- 后端使用这个授权码，向 GitHub 请求令牌。

```javascript
const tokenResponse = await axios({
  method: 'post',
  url: 'https://github.com/login/oauth/access_token?' +
    `client_id=${clientID}&` +
    `client_secret=${clientSecret}&` +
    `code=${requestToken}`,
  headers: {
    accept: 'application/json'
  }
});
```

- 上面代码中，GitHub 的令牌接口`https://github.com/login/oauth/access_token`需要提供三个参数。
    - `client_id`：客户端的 ID
    - `client_secret`：客户端的密钥。
    - `code`：授权码。
- 作为回应，GitHub 会返回一段 JSON 数据，里面包含了令牌`accessToken`

```javascript
const accessToken = tokenResponse.data.access_token;
```

### API 数据

- 有了令牌以后，就可以向 API 请求数据了。

```javascript
const result = await axios({
  method: 'get',
  url: `https://api.github.com/user`,
  headers: {
    accept: 'application/json',
    Authorization: `token ${accessToken}`
  }
});
```

- 上面代码中，GitHub API 的地址是`https://api.github.com/user`，请求的时候必须在 HTTP 头信息里面带上令牌。
- 然后，就可以拿到用户数据，得到用户的身份。

```javascript
const name = result.data.name;
ctx.response.redirect(`/welcome.html?name=${name}`);
```