---
title: Sass @each
categories:
- Software
- Frontend
- Sass
- FlowControl
---
# Sass @each

The `@each` rule makes it easy to emit styles or evaluate code for each element of a [list](https://sass-lang.com/documentation/values/lists)or each pair in a [map](https://sass-lang.com/documentation/values/maps). It’s great for repetitive styles that only have a few variations between them. It’s usually written `@each <variable> in <expression> { ... }`, where the [expression](https://sass-lang.com/documentation/syntax/structure#expressions) returns a list. The block is evaluated for each element of the list in turn, which is assigned to the given variable name.

**SCSS SYNTAX**

```css
$sizes: 40px, 50px, 80px;

@each $size in $sizes {
  .icon-#{$size} {
    font-size: $size;
    height: $size;
    width: $size;
  }
}
```

**CSS OUTPUT**

```css
.icon-40px {
  font-size: 40px;
  height: 40px;
  width: 40px;
}

.icon-50px {
  font-size: 50px;
  height: 50px;
  width: 50px;
}

.icon-80px {
  font-size: 80px;
  height: 80px;
  width: 80px;
}
```

## With Maps

You can also use `@each` to iterate over every key/value pair in a map by writing it `@each <variable>, <variable> in <expression> { ... }`. The key is assigned to the first variable name, and the element is assigned to the second.

**SCSS SYNTAX**

```css
$icons: ("eye": "\f112", "start": "\f12e", "stop": "\f12f");

@each $name, $glyph in $icons {
  .icon-#{$name}:before {
    display: inline-block;
    font-family: "Icon Font";
    content: $glyph;
  }
}
```

**CSS OUTPUT**

```css
@charset "UTF-8";
.icon-eye:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}

.icon-start:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}

.icon-stop:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}
```

## Destructuring

If you have a list of lists, you can use `@each` to automatically assign variables to each of the values from the inner lists by writing it `@each <variable...> in <expression> { ... }`. This is known as *destructuring*, since the variables match the structure of the inner lists. Each variable name is assigned to the value at the corresponding position in the list, or [`null`](https://sass-lang.com/documentation/values/null) if the list doesn’t have enough values.

**SCSS SYNTAX**

```css
$icons:
  "eye" "\f112" 12px,
  "start" "\f12e" 16px,
  "stop" "\f12f" 10px;

@each $name, $glyph, $size in $icons {
  .icon-#{$name}:before {
    display: inline-block;
    font-family: "Icon Font";
    content: $glyph;
    font-size: $size;
  }
}
```

**CSS OUTPUT**

```css
@charset "UTF-8";
.icon-eye:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}

.icon-start:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}

.icon-stop:before {
  display: inline-block;
  font-family: "Icon Font";
  content: "";
}
```

**💡 Fun fact:**

Because `@each` supports destructuring and [maps count as lists of lists](https://sass-lang.com/documentation/values/maps), `@each`’s map support works without needing special support for maps in particular.