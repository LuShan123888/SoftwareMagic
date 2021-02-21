---
title: Java this
categories:
- Software
- Backend
- Java
- JavaSE
- 类与对象
---
# Java this

this出现在类的实例方法或构造方法中,用来代表使用该方法的对象,用this作前缀可访问当前对象的实例变量或成员方法,具体形式为:

-   this.实例变量

-   this.成员方法(参数)

this的用途主要包含以下几种情形:

-   在实例变量和局部变量名称相同时,用this作前缀来特指访问实例变量
-   把当前对象的引用作为参数传递给另一个方法
-   在一个构造方法中调用同类的另一个构造方法,形式为this(参数),但要注意,用this调用构造方法,必须是方法体中的第一个语句

**[例5-5]**Point类的再设计

```java
public class Point{
    private  int x,y;

    public Point(int x,int y){//构造方法
        this.x = x;							//在方法体内参变量隐藏了同名的实例变量
        this.y = y;
    }

    public Point(){						//无参构造方法
        this(0,0);							//必须是方法内第一个语句
    }

    public double distance(Point p){//求当前点与p点距离
        return Math.sqrt((this.x-p.x)*(x-p.x)+(y-p.y)*(y-p.y));
    }

    public double distance2(Point p){
        return p.distance(this);		//p到当前点的距离
    }
}
```

**说明**

在构造方法中,由于参数名x与实例变量x同名,在方法内直接写x指的是参数,要访问实例变量必须加this来特指