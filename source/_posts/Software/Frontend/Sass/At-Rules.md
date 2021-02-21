---
title: Sass At-Rules
categories:
- Software
- Frontend
- Sass
---
# Sass At-Rules

## @Functions

Functions allow you to define complex operations on [SassScript values](https://sass-lang.com/documentation/values) that you can re-use throughout your stylesheet. They make it easy to abstract out common formulas and behaviors in a readable way.

Functions are defined using the `@function` at-rule, which is written `@function <name>(<arguments...>) { ... }`. A function’s name can be any Sass identifier. It can only contain [universal statements](https://sass-lang.com/documentation/syntax/structure#universal-statements), as well as the [`@return` at-rule](https://sass-lang.com/documentation/at-rules/function#return) which indicates the value to use as the result of the function call. Functions are called using the normal CSS function syntax.

**SCSS SYNTAX**

```scss
@function pow($base, $exponent) {
  $result: 1;
  @for $_ from 1 through $exponent {
    $result: $result * $base;
  }
  @return $result;
}

.sidebar {
  float: left;
  margin-left: pow(4, 3) * 1px;
}
```

**CSS OUTPUT**

```css
.sidebar {
  float: left;
  margin-left: 64px;
}
```

**💡 Fun fact:**

Function names, like all Sass identifiers, treat hyphens and underscores as identical. This means that `scale-color` and `scale_color` both refer to the same function. This is a historical holdover from the very early days of Sass, when it *only* allowed underscores in identifier names. Once Sass added support for hyphens to match CSS’s syntax, the two were made equivalent to make migration easier.

**⚠️ Heads up!**

While it’s technically possible for functions to have side-effects like setting [global variables](https://sass-lang.com/documentation/variables#scope), this is strongly discouraged. Use [mixins](https://sass-lang.com/documentation/at-rules/mixin) for side-effects, and use functions just to compute values.

## Arguments

Arguments allow functions’ behavior to be customized each time they’re called. The arguments are specified in the `@function` rule after the function’s name, as a list of variable names surrounded by parentheses. The function must be called with the same number of arguments in the form of [SassScript expressions](https://sass-lang.com/documentation/syntax/structure#expressions). The values of these expression are available within the function’s body as the corresponding variables.

**💡 Fun fact:**

Argument lists can also have trailing commas! This can makes it easier to avoid syntax errors when refactoring your stylesheets.

### Optional Arguments

Normally, every argument a function declares must be passed when that function is included. However, you can make an argument optional by defining a *default value* which will be used if that arguments isn’t passed. Default values use the same syntax as [variable declarations](https://sass-lang.com/documentation/variables): the variable name, followed by a colon and a [SassScript expression](https://sass-lang.com/documentation/syntax/structure#expressions). This makes it easy to define flexible function APIs that can be used in simple or complex ways.

**SCSS SYNTAX**

```scss
@function invert($color, $amount: 100%) {
  $inverse: change-color($color, $hue: hue($color) + 180);
  @return mix($inverse, $color, $amount);
}

$primary-color: #036;
.header {
  background-color: invert($primary-color, 80%);
}
```

**CSS OUTPUT**

```css
.header {
  background-color: #523314;
}
```

**💡 Fun fact:**

Default values can be any SassScript expression, and they can even refer to earlier arguments!

### Keyword Arguments

When a function is called, arguments can be passed by name in addition to passing them by their position in the argument list. This is especially useful for functions with multiple optional arguments, or with [boolean](https://sass-lang.com/documentation/values/booleans) arguments whose meanings aren’t obvious without a name to go with them. Keyword arguments use the same syntax as [variable declarations](https://sass-lang.com/documentation/variables) and [optional arguments](https://sass-lang.com/documentation/at-rules/function#optional-arguments).

**SCSS SYNTAX**

```scss
$primary-color: #036;
.banner {
  background-color: $primary-color;
  color: scale-color($primary-color, $lightness: +40%);
}
```

**CSS OUTPUT**

```css
.banner {
  background-color: #036;
  color: #0a85ff;
}
```

**⚠️ Heads up!**

Because *any* argument can be passed by name, be careful when renaming a function’s arguments... it might break your users! It can be helpful to keep the old name around as an [optional argument](https://sass-lang.com/documentation/at-rules/function#optional-arguments) for a while and printing a [warning](https://sass-lang.com/documentation/at-rules/warn) if anyone passes it, so they know to migrate to the new argument.

### Taking Arbitrary Arguments

Sometimes it’s useful for a function to be able to take any number of arguments. If the last argument in a `@function`declaration ends in `...`, then all extra arguments to that function are passed to that argument as a [list](https://sass-lang.com/documentation/values/lists). This argument is known as an [argument list](https://sass-lang.com/documentation/values/lists#argument-lists).

**SCSS SYNTAX**

```scss
@function sum($numbers...) {
  $sum: 0;
  @each $number in $numbers {
    $sum: $sum + $number;
  }
  @return $sum;
}

.micro {
  width: sum(50px, 30px, 100px);
}
```

**CSS OUTPUT**

```css
.micro {
  width: 180px;
}
```

### Taking Arbitrary Keyword Arguments

Argument lists can also be used to take arbitrary keyword arguments. The [`meta.keywords()` function](https://sass-lang.com/documentation/modules/meta#keywords) takes an argument list and returns any extra keywords that were passed to the function as a [map](https://sass-lang.com/documentation/values/maps) from argument names (not including `$`) to those arguments’ values.

**💡 Fun fact:**

If you don’t ever pass an argument list to the [`meta.keywords()` function](https://sass-lang.com/documentation/modules/meta#keywords), that argument list won’t allow extra keyword arguments. This helps callers of your function make sure they haven’t accidentally misspelled any argument names.

### Passing Arbitrary Arguments

Just like argument lists allow functions to take arbitrary positional or keyword arguments, the same syntax can be used to *pass* positional and keyword arguments to a function. If you pass a list followed by `...` as the last argument of a function call, its elements will be treated as additional positional arguments. Similarly, a map followed by `...` will be treated as additional keyword arguments. You can even pass both at once!

**SCSS SYNTAX**

```scss
$widths: 50px, 30px, 100px;
.micro {
  width: min($widths...);
}
```

**CSS OUTPUT**

```css
.micro {
  width: 30px;
}
```

**💡 Fun fact:**

Because an [argument list](https://sass-lang.com/documentation/values/lists#argument-lists) keeps track of both positional and keyword arguments, you use it to pass both at once to another function. That makes it super easy to define an alias for a function!

**SCSS SYNTAX**

```scss
@function fg($args...) {
  @warn "The fg() function is deprecated. Call foreground() instead.";
  @return foreground($args...);
}
```

## @return

The `@return` at-rule indicates the value to use as the result of calling a function. It’s only allowed within a `@function`body, and each `@function` must end with a `@return`.

When a `@return` is encountered, it immediately ends the function and returns its result. Returning early can be useful for handling edge-cases or cases where a more efficient algorithm is available without wrapping the entire function in an [`@else` block](https://sass-lang.com/documentation/at-rules/control/if#else).

**SCSS SYNTAX**

```scss
@use "sass:string";

@function str-insert($string, $insert, $index) {
  // Avoid making new strings if we don't need to.
  @if string.length($string) == 0 {
    @return $insert;
  }

  $before: string.slice($string, 0, $index);
  $after: string.slice($string, $index);
  @return $before + $insert + $after;
}
```

## Other Functions

In addition to user-defined function, Sass provides a substantial [core library](https://sass-lang.com/documentation/modules) of built-in functions that are always available to use. Sass implementations also make it possible to define [custom functions](https://sass-lang.com/documentation/js-api#functions) in the host language. And of course, you can always call [plain CSS functions](https://sass-lang.com/documentation/at-rules/function#plain-css-functions) (even ones with [weird syntax](https://sass-lang.com/documentation/syntax/special-functions)).

### Plain CSS Functions

Any function call that’s not either a user-defined or [built-in](https://sass-lang.com/documentation/modules) function is compiled to a plain CSS function (unless it uses [Sass argument syntax](https://sass-lang.com/documentation/at-rules/function#arguments)). The arguments will be compiled to CSS and included as-is in the function call. This ensures that Sass supports all CSS functions without needing to release new versions every time a new one is added.

**SCSS SYNTAX**

```scss
@debug var(--main-bg-color); // var(--main-bg-color)

$primary: #f2ece4;
$accent: #e1d7d2;
@debug radial-gradient($primary, $accent); // radial-gradient(#f2ece4, #e1d7d2)
```

**⚠️ Heads up!**

Because any unknown function will be compiled to CSS, it’s easy to miss when you typo a function name. Consider running a [CSS linter](https://stylelint.io/) on your stylesheet’s output to be notified when this happens!

**💡 Fun fact:**

Some CSS functions, like `calc()` and `element()` have unusual syntax. Sass [parses these functions specially](https://sass-lang.com/documentation/syntax/special-functions) as [unquoted strings](https://sass-lang.com/documentation/values/strings#unquoted).