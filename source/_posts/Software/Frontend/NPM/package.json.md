---
title: NPM package.json
categories:
- Software
- FrontEnd
- NPM
---
# NPM package.json

- `package.json` 位于模块的目录下，用于定义包的属性。

```json
{
  "name": "express",
  "description": "Fast, unopinionated, minimalist web framework",
  "version": "4.13.3",
  "author": {
    "name": "TJ Holowaychuk",
    "email": "tj@vision-media.ca"
  },
  "contributors": [
    {
      "name": "Aaron Heckmann",
      "email": "aaron.heckmann+github@gmail.com"
    }
  ],
  "homepage": "http://expressjs.com/",
  "keywords": [
    "express",
  ],
  "dependencies": {
    "accepts": "~1.2.12",
    "array-flatten": "1.1.1",
    "content-disposition": "0.5.0"
  },
  "devDependencies": {
    "after": "0.8.1",
    "ejs": "2.3.3"
  },
  "engines": {
    "node": ">= 0.10.0"
  },
  "files": [
    "LICENSE",
    "History.md",
    "Readme.md",
    "index.js",
    "lib/"
  ],
  "scripts": {
    "test": "mocha --require test/support/env --reporter spec --bail --check-leaks test/ test/acceptance/",
    "test-ci": "istanbul cover node_modules/mocha/bin/_mocha --report lcovonly -- --require test/support/env --reporter spec --check-leaks test/ test/acceptance/",
    "test-cov": "istanbul cover node_modules/mocha/bin/_mocha -- --require test/support/env --reporter dot --check-leaks test/ test/acceptance/",
    "test-tap": "mocha --require test/support/env --reporter tap --check-leaks test/ test/acceptance/"
  },
  "gitHead": "ef7ad681b245fba023843ce94f6bcb8e275bbb8e",
  "bugs": {
    "url": "https://github.com/strongloop/express/issues"
  },
  "_id": "express@4.13.3",
  "_shasum": "ddb2f1fb4502bf33598d2b032b037960ca6c80a3",
  "_from": "express@*",
  "_npmVersion": "1.4.28",
  "_npmUser": {
    "name": "dougwilson",
    "email": "doug@somethingdoug.com"
  },
  "maintainers": [
    {
      "name": "tjholowaychuk",
      "email": "tj@vision-media.ca"
    }
  ],
  "dist": {
    "shasum": "ddb2f1fb4502bf33598d2b032b037960ca6c80a3",
    "tarball": "http://registry.npmjs.org/express/-/express-4.13.3.tgz"
  },
  "directories": {},
  "_resolved": "https://registry.npmjs.org/express/-/express-4.13.3.tgz",
  "readme": "ERROR: No README data found!"
}
```

- `name`：包名。
- `version`：包的版本号。
- `description`：包的描述。
- `homepage`：包的官网 url
- `author`：包的作者姓名。
- `contributors`：包的其他贡献者姓名。
- `dependencies`：依赖包列表，如果依赖包没有安装，npm 会自动将依赖包安装在 node_module 目录下。
    - `~`:匹配最近的小版本比如~1.0.2将会匹配所有的1.0.x版本，但不匹配1.1.0
    - `^`：匹配最近的一个大版本比如1.0.2 将会匹配所有 1.x.x，但不包括2.x.x
- `repository`：包代码存放的地方的类型，可以是 git 或 svn,git 可在 Github 上。
- `main`:main 字段指定了程序的主入口文件，require('moduleName') 就会加载这个文件，这个字段的默认值是模块根目录下面的 index.js
- `scirpt`:npm run 命令执行的脚本名，通过该方式运行的命令会优先使用本项目的依赖，然后再使用全局依赖。
- `keywords`：关键字。