---
title: Java Joda-Time
categories:
  - Software
  - Language
  - Java
  - JavaSE
  - 工具类
---
# Java Joda-Time

- 在Java中处理日期和时间是很常见的需求，基础的工具类就是我们熟悉的Date和Calendar，然而这些工具类的api使用并不是很方便和强大，于是就诞生了[Joda-Time](http://www.joda.org/joda-time/）这个专门处理日期时间的库。

## pom.xml

```xml
<dependency>
    <groupId>joda-time</groupId>
    <artifactId>joda-time</artifactId>
    <version>2.9.2</version>
</dependency>
```

## 核心类介绍

- **Instant**：用来表示时间轴上一个瞬时的点，比较适合用来表示一个事件发生的时间戳，不用去关心它使用的日历系统或者是所在的时区。
- **DateTime**：用来替换JDK的Calendar类，用来处理那些时区信息比较重要的场景。
- **LocalDate**：表示一个本地的日期，而不包含时间部分（没有时区信息），比较适合表示出生日期这样的类型，因为不关心这一天中的时间部分。
- **LocalTime**：表示一个本地的时间，而不包含日期部分（没有时区信息），适合表示一个商店的每天开门/关门时间，因为不用关心日期部分。
- **LocalDateTime**：表示一个本地的日期－时间（没有时区信息）

> **注意**：上述核心类均为不可变的类，表明了正如Java的String类型一样，其对象是不可变的，即，不论对它进行怎样的改变操作，返回的对象都是新对象。

## DateTime类

### 构造方法

- DateTime有很多构造方法，这是为了使用者能够很方便的由各种表示日期时间的对象构造出DateTime实例。
- `DateTime()`：这个无参的构造方法会创建一个在当前系统所在时区的当前时间，精确到毫秒。
- `DateTime(int year, int monthOfYear, int dayOfMonth, int hourOfDay, int minuteOfHour, int secondOfMinute)`：这个构造方法方便快速地构造一个指定的时间，这里精确到秒，类似地其它构造方法也可以传入毫秒。
- `DateTime(long instant)`：这个构造方法创建出来的实例，是通过一个long类型的时间戳，它表示这个时间戳距`1970-01-01T00:00:00Z`的毫秒数，使用默认的时区。
- `DateTime(Object instant)`：这个构造方法可以通过一个Object对象构造一个实例，这个Object对象可以是这些类型：`ReadableInstant`, `String`, `Calendar`和`Date`，其中String的格式需要是`ISO8601`格式，详见：[ISODateTimeFormat.dateTimeParser()](https://www.joda.org/joda-time/apidocs/org/joda/time/format/ISODateTimeFormat.html)

**实例**

```dart
DateTime dateTime1 = new DateTime();
System.out.println(dateTime1); // out: 2016-02-26T16:02:57.582+08:00
DateTime dateTime2 = new DateTime(2016,2,14,0,0,0);
System.out.println(dateTime2); // out: 2016-02-14T00:00:00.000+08:00
DateTime dateTime3 = new DateTime(1456473917004L);
System.out.println(dateTime3); // out: 2016-02-26T16:05:17.004+08:00
DateTime dateTime4 = new DateTime(new Date());
System.out.println(dateTime4); // out: 2016-02-26T16:07:59.970+08:00
DateTime dateTime5 = new DateTime("2016-02-15T00:00:00.000+08:00");
System.out.println(dateTime5); // out: 2016-02-15T00:00:00.000+08:00
```

### 设置日期时间

- 以with开头的方法用来设置DateTime实例到某个时间，例如：withYear
- 因为DateTime是不可变对象，所以没有提供setter方法可供使用，with方法也没有改变原有的对象，而是返回了设置后的一个副本对象。
- 下面这个例子，将2000-02-29的年份设置为1997，值得注意的是，因为1997年没有2月29日，所以自动转为了28日。

```dart
DateTime dateTime2000Year = new DateTime(2000,2,29,0,0,0);
System.out.println(dateTime2000Year); // out: 2000-02-29T00:00:00.000+08:00
DateTime dateTime1997Year = dateTime2000Year.withYear(1997);
System.out.println(dateTime1997Year); // out: 1997-02-28T00:00:00.000+08:00
```

### 加减日期时间

- 以plus/minus开头的方法用来返回在DateTime实例上增加或减少一段时间后的实例，比如：plusDay, minusMonths
- 下面的例子：在当前的时刻加1天，得到了明天这个时刻的时间，在当前的时刻减1个月，得到了上个月这个时刻的时间。

```dart
DateTime now = new DateTime();
System.out.println(now); // out: 2016-02-26T16:27:58.818+08:00
DateTime tomorrow = now.plusDays(1);
System.out.println(tomorrow); // out: 2016-02-27T16:27:58.818+08:00
DateTime lastMonth = now.minusMonths(1);
System.out.println(lastMonth); // out: 2016-01-26T16:27:58.818+08:00
```

- **注意**：在增减时间的时候，想象成自己在翻日历，所有的计算都将符合历法，由Joda-Time自动完成，不会出现非法的日期（比如：3月31日加一个月后，并不会出现4月31日）

### 返回Property

- Property是DateTime中的属性，保存了一些有用的信息。
- 可以通过不同Property中get开头的方法获取一些有用的信息。

```dart
DateTime now = new DateTime(); // 2016-02-26T16:51:28.749+08:00
now.monthOfYear().getAsText(); // February
now.monthOfYear().getAsText(Locale.KOREAN); // 2월
now.dayOfWeek().getAsShortText(); // Fri
now.dayOfWeek().getAsShortText(Locale.CHINESE); // 星期五。
```

- 有时我们需要对一个DateTime的某些属性进行置0操作，比如得到当天的0点时刻。
- 那么就需要用到Property中round开头的方法（例如：roundFloorCopy）如下面的例子所示：

```dart
DateTime now = new DateTime(); // 2016-02-26T16:51:28.749+08:00
now.dayOfWeek().roundCeilingCopy(); // 2016-02-27T00:00:00.000+08:00
now.dayOfWeek().roundFloorCopy(); // 2016-02-26T00:00:00.000+08:00
now.minuteOfDay().roundFloorCopy(); // 2016-02-26T16:51:00.000+08:00
now.secondOfMinute().roundFloorCopy(); // 2016-02-26T16:51:28.000+08:00
```

## 日历系统和时区

- Joda-Time默认使用的是ISO的日历系统，而ISO的日历系统是世界上公历的事实标准，然而，值得注意的是，ISO日历系统在表示1583年之前的历史时间是不精确的。
- Joda-Time默认使用的是JDK的时区设置，如果需要的话，这个默认值是可以被覆盖的。
- Joda-Time使用可插拔的机制来设计日历系统，而JDK则是使用子类的设计，比如GregorianCalendar，下面的代码，通过调用一个工厂方法获得Chronology的实现：

```java
Chronology coptic = CopticChronology.getInstance();
```

- 时区是作为Chronology的一部分来被实现的，下面的代码获得一个Joda-Time Chronology在东京的时区：

```java
DateTimeZone zone = DateTimeZone.forID("Asia/Tokyo");
Chronology gregorianJuian = GJChronology.getInstance(zone);
```

## 时间段

- Joda-Time为时间段的表示提供了支持。
- **Interval**：它保存了一个开始时刻和一个结束时刻，因此能够表示一段时间，并进行这段时间的相应操作。
- **Period**：它保存了一段时间，比如：6个月，3天，7小时这样的概念，可以直接创建Period，或者从Interval对象构建。
- **Duration**：它保存了一个精确的毫秒数，同样地，可以直接创建Duration，也可以从Interval对象构建。

**实例**

- 虽然，这三个类都用来表示时间段，但是在用途上来说还是有一些差别，请看下面的例子：

```dart
DateTime dt = new DateTime(2005, 3, 26, 12, 0, 0, 0);
DateTime plusPeriod = dt.plus(Period.days(1));
DateTime plusDuration = dt.plus(new Duration(24L*60L*60L*1000L));
```

- 因为当时那个地区执行夏令时的原因，在添加一个Period的时候会添加23个小时，而添加一个Duration，则会精确地添加24个小时，而不考虑历法。
- 所以，Period和Duration的差别不但体现在精度上，也同样体现在语义上，因为，有时候按照有些地区的历法 1天不等于 24小时。