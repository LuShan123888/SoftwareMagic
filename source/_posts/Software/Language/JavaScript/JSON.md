---
title: JavaScript JSON
categories:
- Software
- Language
- JavaScript
---
# JavaScript JSON

## `JSON.stringify()`

- `JSON.stringify()` 方法用于将 JavaScript 值转换为 JSON 字符串。

**语法**

```js
JSON.stringify(value[, replacer[, space]])
```

**参数说明**:

- **value**：必需，要转换的 JavaScript 值（通常为对象或数组）
- **replacer**:
    - 可选，用于转换结果的函数或数组。
    - 如果 replacer 为函数，则 JSON.stringify 将调用该函数，并传入每个成员的键和值，使用返回值而不是原始值，如果此函数返回 undefined，则排除成员，根对象的键是一个空字符串：""
    - 如果 replacer 是一个数组，则仅转换该数组中具有键值的成员，成员的转换顺序与键在数组中的顺序一样。
- **space**：可选，文本添加缩进，空格和换行符，如果 space 是一个数字，则返回值文本在每个级别缩进指定数目的空格，如果 space 大于 10，则文本缩进 10 个空格，space 也可以使用非数字，如：\t

**返回值**:

- 返回包含 JSON 文本的字符串。

**实例**:

```js
var str = {"name":"test", "site":"http://www.runoob.com"}
str_pretty1 = JSON.stringify(str)
document.write( "只有一个参数情况：" );
document.write( "<br>" );
document.write("<pre>" + str_pretty1 + "</pre>" );

document.write( "<br>" );
str_pretty2 = JSON.stringify(str, null, 4) // 使用四个空格缩进。
document.write( "使用参数情况：" );
document.write( "<br>" );
document.write("<pre>" + str_pretty2 + "</pre>" ); // pre 用于格式化输出。
```

## JSON.parse()

- `JSON.parse() `方法用于将一个 JSON 字符串转换为对象。

**语法**

```js
JSON.parse(text[, reviver])
```

**参数说明**:

- **text**：必需，一个有效的 JSON 字符串。
- **reviver**：可选，一个转换结果的函数，将为对象的每个成员调用此函数。

**返回值**:

- 返回给定 JSON 字符串转换后的对象。

**实例**:

```js
JSON.parse('{"p": 5}', function(k, v) {
  if (k === '') { return v; }
  return v * 2;
});

JSON.parse('{"1": 1, "2": 2, "3": {"4": 4, "5": {"6": 6}}}', function(k, v) {
  console.log(k); // 输出当前属性，最后一个为 ""
  return v;       // 返回修改的值。
});
```

