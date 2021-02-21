---
title: Sass @for
categories:
- Software
- Frontend
- Sass
- FlowControl
---
# Sass @for

The `@for` rule, written `@for <variable> from <expression> to <expression> { ... }` or `@for <variable> from <expression> through <expression> { ... }`, counts up or down from one number (the result of the first [expression](https://sass-lang.com/documentation/syntax/structure#expressions)) to another (the result of the second) and evaluates a block for each number in between. Each number along the way is assigned to the given variable name. If `to` is used, the final number is excluded; if `through` is used, it's included.

**SCSS SYNTAX**

```css
$base-color: #036;

@for $i from 1 through 3 {
  ul:nth-child(3n + #{$i}) {
    background-color: lighten($base-color, $i * 5%);
  }
}
```

**CSS OUTPUT**

```css
ul:nth-child(3n + 1) {
  background-color: #004080;
}

ul:nth-child(3n + 2) {
  background-color: #004d99;
}

ul:nth-child(3n + 3) {
  background-color: #0059b3;
}
```

