---
title: JavaScript Array对象
categories:
- Software
- Language
- JavaScript
- 对象
---
# JavaScript Array对象

- 数组对象是使用单独的变量名来存储一系列的值
- 数组可以用一个变量名存储所有的值，并且可以用变量名访问任何一个值
- 数组中的每个元素都有自己的的ID,以便它可以很容易地被访问到

## 创建数组

- 创建一个数组，有三种方法
- 下面的代码定义了一个名为 myCars的数组对象:

### 常规方式

```js
var myCars=new Array();
myCars[0]="Saab";
myCars[1]="Volvo";
myCars[2]="BMW";
```

### 简洁方式

```js
var myCars=new Array("Saab","Volvo","BMW");
```

###  字面

```js
var myCars=["Saab","Volvo","BMW"];
```

**在一个数组中你可以有不同的对象**

- 所有的JavaScript变量都是对象，数组元素是对象，函数是对象
- 因此，你可以在数组中有不同的变量类型
- 你可以在一个数组中包含对象元素，函数，数组:

```js
myArray[0]=Date.now;
myArray[1]=myFunction;
myArray[2]=myCars;
```

## 访问数组

- 通过指定数组名以及索引号码，你可以访问某个特定的元素
- 以下实例可以访问myCars数组的第一个值:

```js
var name=myCars[0];
```

- 以下实例修改了数组 myCars 的第一个元素:

```js
myCars[0]="Opel";
```

## 数组方法和属性

### length

- length 属性可设置或返回数组中元素的数目

**语法**

- 设置数组的数目

```js
array.length=number
```

**实例**

- 返回数组的中元素的数目

```js
var x=myCars.length
```

### indexOf()

- indexOf() 方法可返回数组中某个指定的元素位置
- 该方法将从头到尾地检索数组，看它是否含有对应的元素，开始检索的位置在数组 start 处或数组的开头(没有指定 start 参数时),如果找到一个 item,则返回 item 的第一次出现的位置，开始位置的索引为 0
- 如果在数组中没找到指定元素则返回 -1

**语法**

```js
array.indexOf(item,start)
```

**参数值**

| 参数  | 描述                                                         |
| :---- | :----------------------------------------------------------- |
| item  | 必须，查找的元素,                                             |
| start | 可选的整数参数，规定在数组中开始检索的位置，它的合法取值是 0 到 stringObject.length - 1,如省略该参数，则将从字符串的首字符开始检索, |

**返回值**

| 类型   | 描述                                          |
| :----- | :-------------------------------------------- |
| Number | 元素在数组中的位置，如果没有搜索到则返回 -1,|

**实例**

- 查找数组中 "Apple" 的元素, 在数组的第四个位置开始检索

```js
var fruits=["Banana","Orange","Apple","Mango","Banana","Orange","Apple"];
var a = fruits.indexOf("Apple",4); //6
```

### splice()

- splice() 方法向/从数组中添加/删除项目，然后返回被删除的项目
- **注意**:该方法会改变原始数组

**语法**

```js
arrayObject.splice(index,howmany,item1,.....,itemX)
```

**参数**

| 参数              | 描述                                                         |
| :---------------- | :----------------------------------------------------------- |
| index             | 必需，规定从何处添加/删除元素，该参数是开始插入和(或)删除的数组元素的下标，必须是数字, |
| howmany           | 可选，规定应该删除多少元素，必须是数字，但可以是 "0",如果未规定此参数，则删除从 index 开始到原数组结尾的所有元素, |
| item1, ..., itemX | 可选，要添加到数组的新元素                                    |

**返回值**

| Type  | 描述                                                         |
| :---- | :----------------------------------------------------------- |
| Array | 如果从 arrayObject 中删除了元素，则返回的是含有被删除的元素的数组,|

**实例**

- 移除数组的第三个元素，并在数组第三个位置添加新元素

```js
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.splice(2,1,"Lemon","Kiwi");

Banana,Orange,Lemon,Kiwi,Mango
```

### toFixed()

- toFixed() 方法可把 Number 四舍五入为指定小数位数的数字

**语法**

```js
number.toFixed(x)
```

**参数值**

| 参数 | 描述                                                         |
| :--- | :----------------------------------------------------------- |
| *x*  | 必需，规定小数的位数，是 0 ~ 20 之间的值，包括 0 和 20,有些实现可以支持更大的数值范围，如果省略了该参数，将用 0 代替,|

**返回值**

| 类型   | 描述                      |
| :----- | :------------------------ |
| String | 小数点后有固定的 x 位数字 |

**实例**

- 把数字转换为字符串，结果的小数点后有指定位数的数字

```js
var num = 5.56789;
var n=num.toFixed(2); //5.57
```

### 创建新方法

- 原型是JavaScript全局构造函数，它可以构建新Javascript对象的属性和方法

```js
Array.prototype.myUcase=function(){
    for (i=0;i<this.length;i++){
        this[i]=this[i].toUpperCase();
    }
}
```

- 上面的例子创建了新的数组方法用于将数组小写字符转为大写字符

### map()

- 将原数组中的所有元素通过一个函数进行处理并放入到一个新数组中并返回该新数组

**实例**

- 有一个字符串数组，希望转为int数组，并乘以2

```js
let arr = ['1', '20', '-5', '3'];
console.log(arr)
var newarr = arr.map(function (value) {
return parseInt(value) * 2;
});
// 箭头函数简化
var newarr = arr.map(value => parseInt(value) * 2);
console.log("原数组:", arr);
console.log("map的newarr数组:", newarr); // 2 40 -10 6
```

### reduce()

```js
reduce(function(a,b),初始值)
```

- `reduce()`会从左到右依次把数组中的元素用`function(a,b)`处理，并把处理的结果作为下次`function(a,b)`的第一个参数，如果是第一次，会把前两个元素作为计算参数，或者把用户指定的初始值作为起始参数

```js
let arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
// 原始写法
var result = arr2.reduce(function(a,b){
return a+b;
})
// 箭头函数简化
var result = arr2.reduce((a, b) => a + b);
console.log(result);
```