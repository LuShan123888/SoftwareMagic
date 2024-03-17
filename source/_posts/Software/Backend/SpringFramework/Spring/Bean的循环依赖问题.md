---
title: Bean的循环依赖问题
categories:
- Software
- BackEnd
- SpringFramework
- Spring
---
# Bean的循环依赖问题

## 什么是循环依赖？

- 从字面上来理解就是A依赖B的同时B也依赖了A,就像下面这样

![image-20200705175322521](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314235001482.png)

```java
@Component
public class A {
    // A中注入了B
    @Autowired
    private B b;
}

@Component
public class B {
    // B中也注入了A
    @Autowired
    private A a;
}
```

## 什么情况下循环依赖可以被处理？

- Spring解决循环依赖的前置条件
    1. 出现循环依赖的Bean必须要是单例
    2. 依赖注入的方式不能全是构造器注入的方式
- 如果A中注入B的方式是通过构造器,B中注入A的方式也是通过构造器，这个时候循环依赖是无法被解决，如果你的项目中有两个这样相互依赖的Bean,在启动时就会报出以下错误:

```
Caused by: org.springframework.beans.factory.BeanCurrentlyInCreationException: Error creating bean with name 'a': Requested bean is currently in creation: Is there an unresolvable circular reference?
```

- 循环依赖的解决情况跟注入方式的关系:

| 依赖情况               | 依赖注入方式                                       | 循环依赖是否被解决 |
| :--------------------- | :------------------------------------------------- | :----------------- |
| AB相互依赖（循环依赖)| 均采用setter方法注入                               | 是                 |
| AB相互依赖（循环依赖)| 均采用构造器注入                                   | 否                 |
| AB相互依赖（循环依赖)| A中注入B的方式为setter方法,B中注入A的方式为构造器 | 是                 |
| AB相互依赖（循环依赖)| B中注入A的方式为setter方法,A中注入B的方式为构造器 | 否                 |

- 不是只有在setter方法注入的情况下循环依赖才能被解决，即使存在构造器注入的场景下，循环依赖依然被可以被正常处理掉，但是要确保第一个初始化的Bean为setter方法注入

## Spring是如何解决的循环依赖？

- 关于循环依赖的解决方式应该要分两种情况来讨论
    1. 简单的循环依赖
    2. 结合了AOP的循环依赖

### 简单的循环依赖

```java
@Component
public class A {
    // A中注入了B
    @Autowired
    private B b;
}

@Component
public class B {
    // B中也注入了A
    @Autowired
    private A a;
}
```

- 首先**Spring在创建Bean的时候默认是按照自然排序来进行创建的，所以第一步Spring会去创建A**,与此同时,Spring在创建Bean的过程中分为三步
    1. 实例化，对应方法:`AbstractAutowireCapableBeanFactory`中的`createBeanInstance`方法
    2. 属性注入，对应方法:`AbstractAutowireCapableBeanFactory`的`populateBean`方法
    3. 初始化，对应方法:`AbstractAutowireCapableBeanFactory`的`initializeBean`

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314234935119.png" alt="image-20200706092738559" style="zoom:50%;" />

- 创建A的过程实际上就是调用`getBean`方法，这个方法有两层含义
    1. 创建一个新的Bean
    2. 从缓存中获取到已经被创建的对象

#### 调用getSingleton(beanName)

- 首先调用`getSingleton(a)`方法，这个方法又会调用`getSingleton(beanName, true)`

```java
public Object getSingleton(String beanName) {
    return getSingleton(beanName, true);
}
```

- `getSingleton(beanName, true)`这个方法实际上就是到缓存中尝试去获取Bean,整个缓存分为三级
    1. `singletonObjects`,一级缓存，存储的是所有创建好了的单例Bean
    2. `earlySingletonObjects`,完成实例化，但是还未进行属性注入及初始化的对象
    3. `singletonFactories`,提前暴露的一个单例工厂，二级缓存中存储的就是从这个工厂中获取到的对象
- 因为A是第一次被创建，所以不管哪个缓存中必然都是没有的，因此会进入`getSingleton`的另外一个重载方法`getSingleton(beanName, singletonFactory)`

#### 调用getSingleton(beanName, singletonFactory)

- 创建Bean

```java
public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
    Assert.notNull(beanName, "Bean name must not be null");
    synchronized (this.singletonObjects) {
        Object singletonObject = this.singletonObjects.get(beanName);
        if (singletonObject == null) {

            // ....
            // 省略异常处理及日志
            // ....

            // 在单例对象创建前先做一个标记
            // 将beanName放入到singletonsCurrentlyInCreation这个集合中
            // 标志着这个单例Bean正在创建
            // 如果同一个单例Bean多次被创建，这里会抛出异常
            beforeSingletonCreation(beanName);
            boolean newSingleton = false;
            boolean recordSuppressedExceptions = (this.suppressedExceptions == null);
            if (recordSuppressedExceptions) {
                this.suppressedExceptions = new LinkedHashSet<>();
            }
            try {
                // 上游传入的lambda在这里会被执行，调用createBean方法创建一个Bean后返回
                singletonObject = singletonFactory.getObject();
                newSingleton = true;
            }
            // ...
            // 省略catch异常处理
            // ...
            finally {
                if (recordSuppressedExceptions) {
                    this.suppressedExceptions = null;
                }
                // 创建完成后将对应的beanName从singletonsCurrentlyInCreation移除
                afterSingletonCreation(beanName);
            }
            if (newSingleton) {
                // 添加到一级缓存singletonObjects中
                addSingleton(beanName, singletonObject);
            }
        }
        return singletonObject;
    }
}
```

- 上面的代码通过`createBean`方法返回的Bean最终被放到了一级缓存

#### 调用addSingletonFactory方法

- 在完成Bean的实例化后，属性注入之前Spring将Bean包装成一个工厂添加进了三级缓存中

```java
// 这里传入的参数也是一个lambda表达式,() -> getEarlyBeanReference(beanName, mbd, bean)
protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
    Assert.notNull(singletonFactory, "Singleton factory must not be null");
    synchronized (this.singletonObjects) {
        if (!this.singletonObjects.containsKey(beanName)) {
            // 添加到三级缓存中
            this.singletonFactories.put(beanName, singletonFactory);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
}
```

- 这里只是添加了一个工厂，通过这个工厂(`ObjectFactory`)的`getObject`方法可以得到一个对象，而这个对象实际上就是通过`getEarlyBeanReference`这个方法创建的，当创建B的流程中会调用这个工厂的`getObject`方法
- 当A完成了实例化并添加进了三级缓存后，就要开始为A进行属性注入了，在注入时发现A依赖了B,那么这个时候Spring又会去`getBean(b)`,然后反射调用setter方法完成属性注入

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314235458883.png" alt="image-20200706114501300" style="zoom:50%;" />

- 因为B需要注入A,所以在创建B的时候，又会去调用`getBean(a)`,这个时候就又回到之前的流程了，但是不同的是，之前的`getBean`是为了创建Bean,而此时再调用`getBean`不是为了创建了，而是要从缓存中获取，因为之前A在实例化后已经将其放入了三级缓存`singletonFactories`中，所以此时`getBean(a)`的流程如下

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314235512961.png" alt="image-20200706115959250" style="zoom:67%;" />

- 从这里我们可以看出，注入到B中的A是通过`getEarlyBeanReference`方法提前暴露出去的一个对象，还不是一个完整的Bean

```java
protected Object getEarlyBeanReference(String beanName, RootBeanDefinition mbd, Object bean) {
    Object exposedObject = bean;
    if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
        for (BeanPostProcessor bp : getBeanPostProcessors()) {
            if (bp instanceof SmartInstantiationAwareBeanPostProcessor) {
                SmartInstantiationAwareBeanPostProcessor ibp = (SmartInstantiationAwareBeanPostProcessor) bp;
                exposedObject = ibp.getEarlyBeanReference(exposedObject, beanName);
            }
        }
    }
    return exposedObject;
}
```

- 该方法实际上就是调用了后置处理器的`getEarlyBeanReference`,而真正实现了这个方法的后置处理器只有一个，就是通过`@EnableAspectJAutoProxy`注解导入的`AnnotationAwareAspectJAutoProxyCreator`,**也就是说如果在不考虑`AOP`的情况下，上面的代码等价于**

```java
protected Object getEarlyBeanReference(String beanName, RootBeanDefinition mbd, Object bean) {
    Object exposedObject = bean;
    return exposedObject;
}
```

- 这个工厂直接将实例化阶段创建的对象返回了，所以说在不考虑`AOP`的情况下三级缓存没有起到作用

>- **注意**:B中提前注入了一个没有经过初始化的A类型对象是否会有问题，这个时候我们需要将整个创建A这个Bean的流程走完，如下图:
>
><img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314235649231.png" alt="image-20200706133018669" style="zoom:67%;" />
>
>- 从上图中我们可以看到，虽然在创建B时会提前给B注入了一个还未初始化的A对象，但是在创建A的流程中一直使用的是注入到B中的A对象的引用，之后会根据这个引用对A进行初始化，所以这是没有问题的
>
>

### 结合了AOP的循环依赖

- 三级缓存实际上跟Spring中的`AOP`相关,`getEarlyBeanReference`的代码如下:

```java
protected Object getEarlyBeanReference(String beanName, RootBeanDefinition mbd, Object bean) {
    Object exposedObject = bean;
    if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
        for (BeanPostProcessor bp : getBeanPostProcessors()) {
            if (bp instanceof SmartInstantiationAwareBeanPostProcessor) {
                SmartInstantiationAwareBeanPostProcessor ibp = (SmartInstantiationAwareBeanPostProcessor) bp;
                exposedObject = ibp.getEarlyBeanReference(exposedObject, beanName);
            }
        }
    }
    return exposedObject;
}
```

- 如果在开启`AOP`的情况下，那么会调用`AnnotationAwareAspectJAutoProxyCreator`的`getEarlyBeanReference`方法，对应的源码如下:

```java
public Object getEarlyBeanReference(Object bean, String beanName) {
    Object cacheKey = getCacheKey(bean.getClass(), beanName);
    this.earlyProxyReferences.put(cacheKey, bean);
    // 如果需要代理，返回一个代理对象，不需要代理，直接返回当前传入的这个bean对象
    return wrapIfNecessary(bean, beanName, cacheKey);
}
```

- 回到上面的例子，我们对A进行了`AOP`代理的话，那么此时`getEarlyBeanReference`将返回一个代理后的对象，而不是实例化阶段创建的对象，这样就意味着B中注入的A将是一个代理对象而不是A的实例化阶段创建后的对象

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/format,png-20220314235643603.png" alt="image-20200706161709829" style="zoom:67%;" />

>1. 明明初始化的时候是A对象，那么Spring是在哪里将代理对象放入到容器中的呢？
>
>    - 在完成初始化后,Spring又调用了一次`getSingleton`方法，这一次传入的参数又不一样了,false可以理解为禁用三级缓存，前面图中已经提到过了，在为B中注入A时已经将三级缓存中的工厂取出，并从工厂中获取到了一个对象放入到了二级缓存中，所以这里的这个`getSingleton`方法就是从二级缓存中获取到这个代理后的A对象,`exposedObject == bean`可以认为是必定成立的，除非你非要在初始化阶段的后置处理器中替换掉正常流程中的Bean,例如增加一个后置处理器
>    - <img src="https://imgconvert.csdnimg.cn/aHR0cHM6Ly9naXRlZS5jb20vd3hfY2MzNDdiZTY5Ni9ibG9nSW1hZ2UvcmF3L21hc3Rlci9pbWFnZS0yMDIwMDcwNjE2MDU0MjU4NC5wbmc?x-oss-process=image/format,png" alt="image-20200706160542584" style="zoom:50%;" />
>
>2. 为什么需要三级缓存，直接通过二级缓存暴露一个引用不行吗？
>
>    - 这个工厂的目的在于延迟对实例化阶段生成的对象的代理，只有真正发生循环依赖的时候，才去提前生成代理对象，否则只会创建一个工厂并将其放入到三级缓存中，但是不会去通过这个工厂去真正创建对象
>
>    - 我们思考一种简单的情况，就以单独创建A为例，假设AB之间现在没有依赖关系，但是A被代理了，这个时候当A完成实例化后还是会进入下面这段代码:
>
>    - ```java
>         // A是单例的,mbd.isSingleton()条件满足
>         // allowCircularReferences:这个变量代表是否允许循环依赖，默认是开启的，条件也满足
>         // isSingletonCurrentlyInCreation:正在在创建A,也满足
>         // 所以earlySingletonExposure=true
>         boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
>                                          isSingletonCurrentlyInCreation(beanName));
>         // 还是会进入到这段代码中
>         if (earlySingletonExposure) {
>            // 还是会通过三级缓存提前暴露一个工厂对象
>            addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
>         }
>        ```
>
>    - 可以得出，即使没有循环依赖,Spring 也会将其添加到三级缓存中，因为到目前为止Spring也不能确定这个Bean有没有跟别的Bean出现循环依赖
>
>    - 假设在这里直接使用二级缓存的话，那么意味着所有的Bean在这一步都要完成AOP代理，这样做不仅没有必要，而且违背了Spring在结合AOP跟Bean的生命周期的设计!
>
>    - Spring结合AOP跟Bean的生命周期本身就是通过AnnotationAwareAspectJAutoProxyCreator这个后置处理器来完成的，在这个后置处理器的postProcessAfterInitialization方法中对初始化后的Bean完成AOP代理，如果出现了循环依赖，那没有办法，只有给Bean先创建代理，但是没有出现循环依赖的情况下，设计之初就是让Bean在生命周期的最后一步完成代理而不是在实例化后就立马完成代理

## 三级缓存真的提高了效率了吗？

1. 没有进行`AOP`的Bean间的循环依赖
    - 从上文分析可以看出，这种情况下三级缓存根本没用!所以不会存在什么提高了效率的说法

1. 进行了`AOP`的Bean间的循环依赖
    - 就以我们上的A,B为例，其中A被`AOP`代理，我们先分析下使用了三级缓存的情况下,A,B的创建流程

![image-20200706171514327](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9naXRlZS5jb20vd3hfY2MzNDdiZTY5Ni9ibG9nSW1hZ2UvcmF3L21hc3Rlci9pbWFnZS0yMDIwMDcwNjE3MTUxNDMyNy5wbmc?x-oss-process=image/format,png)

- 假设不使用三级缓存，直接在二级缓存中

![image-20200706172523258](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9naXRlZS5jb20vd3hfY2MzNDdiZTY5Ni9ibG9nSW1hZ2UvcmF3L21hc3Rlci9pbWFnZS0yMDIwMDcwNjE3MjUyMzI1OC5wbmc?x-oss-process=image/format,png)

- 上面两个流程的唯一区别在于为A对象创建代理的时机不同，在使用了三级缓存的情况下为A创建代理的时机是在B中需要注入A的时候，而不使用三级缓存的话在A实例化后就需要马上为A创建代理然后放入到二级缓存中去，对于整个A,B的创建过程而言，消耗的时间是一样的
- 综上，不管是哪种情况，三级缓存提高了效率这种说法都是错误的!