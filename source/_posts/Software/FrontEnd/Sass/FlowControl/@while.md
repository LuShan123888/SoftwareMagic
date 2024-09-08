---
title: Sass @while
categories:
- Software
- FrontEnd
- Sass
- FlowControl
---
# Sass @while

The `@while` rule, written `@while <expression> { ... }`, evaluates its block if its [expression](https://sass-lang.com/documentation/syntax/structure#expressions) returns `true`. Then, if its expression still returns `true`, it evaluates its block again. This continues until the expression finally returns `false`.

**SCSS SYNTAX**

```scss
/// Divides `$value` by `$ratio` until it's below `$base`.
@function scale-below($value, $base, $ratio: 1.618) {
  @while $value > $base {
    $value: $value / $ratio;
  }
  @return $value;
}

$normal-font-size: 16px;
sup {
  font-size: scale-below(20px, 16px);
}
```

**CSS OUTPUT**

```css
sup {
  font-size: 12.36094px;
}
```

**⚠️ Heads up!**

Although `@while` is necessary for a few particularly complex stylesheets, you’re usually better of using either [`@each`](https://sass-lang.com/documentation/at-rules/control/each) or [`@for`](https://sass-lang.com/documentation/at-rules/control/for)if either of them will work. They’re clearer for the reader, and often faster to compile as well.

**Truthiness and Falsiness**

Anywhere `true` or `false` are allowed, you can use other values as well. The values `false` and [`null`](https://sass-lang.com/documentation/values/null) are *falsey*, which means Sass considers them to indicate falsehood and cause conditions to fail. Every other value is considered *truthy*, so Sass considers them to work like `true` and cause conditions to succeed.

For example, if you want to check if a string contains a space, you can just write `string.index($string, " ")`. The [`string.index()` function](https://sass-lang.com/documentation/modules/string#index) returns `null` if the string isn’t found and a number otherwise.

**⚠️ Heads up!**

Some languages consider more values falsey than just `false` and `null`. Sass isn’t one of those languages! Empty strings, empty lists, and the number `0` are all truthy in Sass.