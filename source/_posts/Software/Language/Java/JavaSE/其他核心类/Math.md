---
title: Java  Math
categories:
- Software
- Language
- Java
- JavaSE
- 其他核心类
---
# Java  Math

`Java.lang.Math`类封装了常用的数学函数和常量,Math.PI和Math.E两个常量分别代表数学上的π和e,下表列出了Math类的常用静态方法,通过类名作前缀即可调用,例如,`Math.round(5.56)`的结果为6,`Math.floor(5.56)`的结果为5.9

方法|	功能
:---:|:---:
int abs(int i)|	求绝对值(另有针对long,float,double类型参数的多态方法)
double ceil(double d)|	不小于d的最小整数(返回值为double型)
double floor(double d)|	不大于d的最大整数(返回值为double型)
int max(int i1,int i2)|	求两个整数中最大数(另有针对long,float,double类型参数的多态方法)
int min(int i1,int i2)|	求两个整数中最小数(另有针对long,float,double类型参数的多态方法)
double random()|	0-1之间的随机数,不包括0和1
int round(float f)|	求最靠近f的整数
long round(double d)|	求最靠近d的长整数
double sqrt(double d)|	求a的平方根
double cos(double d)|	求d的cos函数(其他求三角函数的方法sin,tan等)
double log(double d)|	求d的自然对数
double exp(double x)|	求e的x次幂(ex)
double pow(double a,double b)|	求a的b次幂

**[例2-5]**:输入圆的半径,计算圆面积,输出结果精确到小数点后3位

```java
import javax.swing.*;
import java.lang.Math;
public class 常用的数学方法 {
    public static void main(String[] args) {
        String s = JOptionPane.showInputDialog("请输入圆的半径: ");
        double r = Double.parseDouble(s);
        double area = Math.PI*r*r;
        System.out.printf("圆的面积=%.3f",area);
    }
}
```

**Math.round(11.5) 等于多少？Math.round(-11.5)等于多少？**

- Math.round(11.5)的返回值是12,Math.round(-11.5)的返回值是-11,四舍五入的原理是在参数上加0.5然后进行下取整

