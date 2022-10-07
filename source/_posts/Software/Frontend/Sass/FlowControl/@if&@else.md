---
title: Sass @if&@else
categories:
- Software
- FrontEnd
- Sass
- FlowControl
---
# Sass @if&@else

## @if

The `@if` rule is written `@if <expression> { ... }`, and it controls whether or not its block gets evaluated (including emitting any styles as CSS). The [expression](https://sass-lang.com/documentation/syntax/structure#expressions) usually returns either [`true` or `false`](https://sass-lang.com/documentation/values/booleans)—if the expression returns `true`, the block is evaluated, and if the expression returns `false` it’s not.

**SCSS SYNTAX**

```css
@mixin avatar($size, $circle: false) {
  width: $size;
  height: $size;

  @if $circle {
    border-radius: $size / 2;
  }
}

.square-av { @include avatar(100px, $circle: false); }
.circle-av { @include avatar(100px, $circle: true); }
```

**CSS OUTPUT**

```css
.square-av {
  width: 100px;
  height: 100px;
}

.circle-av {
  width: 100px;
  height: 100px;
  border-radius: 50px;
}
```

##  @else

An `@if` rule can optionally be followed by an `@else` rule, written `@else { ... }`. This rule’s block is evaluated if the `@if` expression returns `false`.xw

**SCSS SYNTAX**

```css
$light-background: #f2ece4;
$light-text: #036;
$dark-background: #6b717f;
$dark-text: #d2e1dd;

@mixin theme-colors($light-theme: true) {
  @if $light-theme {
    background-color: $light-background;
    color: $light-text;
  } @else {
    background-color: $dark-background;
    color: $dark-text;
  }
}

.banner {
  @include theme-colors($light-theme: true);
  body.dark & {
    @include theme-colors($light-theme: false);
  }
}
```

**CSS OUTPUT**

```css
.banner {
  background-color: #f2ece4;
  color: #036;
}
body.dark .banner {
  background-color: #6b717f;
  color: #d2e1dd;
}
```

## @else if

You can also choose whether to evaluate an `@else` rule’s block by writing it `@else if <expression> { ... }`. If you do, the block is evaluated only if the preceding `@if`’s expression returns `false` *and* the `@else if`’s expression returns `true`.

In fact, you can to chain as many `@else if`s as you want after an `@if`. The first block in the chain whose expression returns `true` will be evaluated, and no others. If there’s a plain `@else` at the end of the chain, its block will be evaluated if every other block fails.

**SCSS SYNTAX**

```css
@mixin triangle($size, $color, $direction) {
  height: 0;
  width: 0;

  border-color: transparent;
  border-style: solid;
  border-width: $size / 2;

  @if $direction == up {
    border-bottom-color: $color;
  } @else if $direction == right {
    border-left-color: $color;
  } @else if $direction == down {
    border-top-color: $color;
  } @else if $direction == left {
    border-right-color: $color;
  } @else {
    @error "Unknown direction #{$direction}.";
  }
}

.next {
  @include triangle(5px, black, right);
}
```

**CSS OUTPUT**

```css
.next {
  height: 0;
  width: 0;
  border-color: transparent;
  border-style: solid;
  border-width: 2.5px;
  border-left-color: black;
}
```



##  Truthiness and Falsiness

Anywhere `true` or `false` are allowed, you can use other values as well. The values `false` and [`null`](https://sass-lang.com/documentation/values/null) are *falsey*, which means Sass considers them to indicate falsehood and cause conditions to fail. Every other value is considered *truthy*, so Sass considers them to work like `true` and cause conditions to succeed.

For example, if you want to check if a string contains a space, you can just write `string.index($string, " ")`. The [`string.index()` function](https://sass-lang.com/documentation/modules/string#index) returns `null` if the string isn’t found and a number otherwise.

### ⚠️ Heads up!

Some languages consider more values falsey than just `false` and `null`. Sass isn’t one of those languages! Empty strings, empty lists, and the number `0` are all truthy in Sass.