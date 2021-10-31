---
title: Java final
categories:
- Software
- Java
- JavaSE
- 继承与多态
---
# Java final

## final作为类修饰符

被final修饰符所修饰的类称为最终类,最终类的特点是不允许继承,JavaAPI中不少类定义为final类,这些类通常用来完成某种标准功能,如Math类,String类,Integer类等

## 用final修饰方法

用final修饰符修饰的方法,是功能和内部语句不能被更改的最终方法,在子类中不能再对父类的final方法重新定义,所有已被private修饰符限定为私有的方法,以及所有包含在final类中的方法,都被默认地认为是final的

## 用final定义常量

用final标记的变量也就是常量,例如,”final double PI=3.14159;"

常量可以在定义时赋值,也可以先定义后赋值,但只能赋值一次,与普通属性变量不同的是,系统不会给常量赋默认初值,因此,要保证引用常量前给其赋初值

需要注意的是,如果将引用类型的变量标记为final,那么该变量只能固定指向一个对象,不能修改,但可以改变对象的内容,因为只有引用本身是final的,例如,以下程序中将t定义为常量,因而不能再对t重新赋值,但可以更改t所指对象的内容,如更改对象的weight属性值

**[例6-9]**:常量赋值测试

```java
public class AssignTest {
    public static int totalNumber = 5;
    public final int id;    //定义对象的常量属性
    public int weight;

    public void m() {
        id++;               //实例方法中不能给常量赋值
    }

    public AssignTest(final int weight) {
        id = totalNumber++; //由于常量id为赋初值,允许在构造方法中给其赋值
        weight++;               //不允许,不能更改定义为常量的参数
        this.weight = weight;
    }

    public static void main(String[] args) {
        final AssignTest t = new AssignTest(5);
        t.weight = t.weight + 2;  //允许
        t.id++;                         //不允许
        t = new.AssignTest(4);  //不允许
    }
}
```

**说明**:即使是未赋过值的常量id,在实例方法中也不能给其赋值,所以第7行的id++不被允许,因为实例方法可多次调用,但构造方法中可以给未初始化的常量赋值,例如第11行的情形,因为构造方法只在创建对象时执行一次

**注意**:对于属性常量,要注意是否加有static修饰,两者性质是不同的,带有static修饰的常量是属于类的常量,只能在定义时或者在静态初始化代码块中给其赋值