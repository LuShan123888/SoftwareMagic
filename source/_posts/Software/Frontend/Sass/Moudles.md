---
title: Sass Modules
categories:
- Software
- FrontEnd
- Sass
---
# Sass Modules

You don't have to write all your Sass in a single file. You can split it up however you want with the `@use` rule. This rule loads another Sass file as a *module*, which means you can refer to its variables, [mixins](https://sass-lang.com/guide#topic-6), and [functions](https://sass-lang.com/documentation/at-rules/function) in your Sass file with a namespace based on the filename. Using a file will also include the CSS it generates in your compiled output!

## SCSS SYNTAX

- `_base.scss`

```css
$font-stack:    Helvetica, sans-serif;
$primary-color: #333;

body {
  font: 100% $font-stack;
  color: $primary-color;
}
```

- `styles.scss`

```scss
@use 'base';

.inverse {
  background-color: base.$primary-color;
  color: white;
}
```

## CSS OUTPUT

```css
body {
  font: 100% Helvetica, sans-serif;
  color: #333;
}

.inverse {
  background-color: #333;
  color: white;
}
```

Notice we're using `@use 'base';` in the `styles.scss` file. When you use a file you don't need to include the file extension. Sass is smart and will figure it out for you.