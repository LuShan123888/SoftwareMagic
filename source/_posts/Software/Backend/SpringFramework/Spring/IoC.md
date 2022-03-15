---
title: Spring IoC 控制反转
categories:
- Software
- Backend
- SpringFramework
- Spring
---
# Spring IoC 控制反转

## IoC本质

- 控制反转,是把传统上由程序代码直接操控的对象的调用权交给容器,由容器来创建对象并管理对象之间的依赖关系,DI是对IoC更准确的描述,即由容器动态的将某种依赖关系注入到组件之中

## IoC 容器

- **BeanFactory**:是一个工厂类，它是一个负责生产和管理bean的工厂。在Spring中，BeanFactory是IoC容器的核心接口，它的职责包括：实例化、定位、配置应用程序中的对象及建立这些对象间的依赖。
    - **延迟实例化**:
    - 在启动IoC容器的时候不会去实例化Bean，只有在使用到某个Bean时(即调用getBean0方法获取时)，才对该Bean进行加载实例化
    - 因为容器启动的时候不用实例化Bean，所以应用启动的时候占用资源较少，程序启动较快，适合对资源要求较高的应用
        - 系统运行的速度相对来说慢一些，井且有可能会出现空指针异常的情况
        - 不能提前发现一些存在的Spring的配置问题。如果Bean的某一个属性没有注入，当BeanFacotry加载后，直至第一次使用调用getBean方法时才会抛出异常
- **ApplicationContext** :是 BeanFactory 的子类,因为古老的 BeanFactory 无法满足不断更新的的需求,于是 ApplicationContext 就基本上代替了 BeanFactory 的工作
    - **非延迟实例化**
        - 在启动IoC容器的时候会预先加载单例Bean，也可以通过设置bean的属性lazy-init =true来让Bean延迟实例化
        - 在容器启动时，可以发现Spring中存在的一些配置问题，即方便检查所依赖属性是否注入等
        - 因为在容器启动的时候会预加载单例Bean，这是一个比较耗时的操作，所以当应用程序配置Bean较多时，将会导致应用程序启动较慢，即在启动阶段会有较大的系统开销
    - ApplicationContext继承自ListableBeanFactory接口,而ListableBeanFactory又继承自BeanFactory,所以ApplicationContext具有BeanFactory所支持的所有功能,当然ApplicationContext还提供了一些额外的功能
        - ApplicationContext继承自MessageSource,因此ApplicationContext为应用提供118n 国际化消息访问的功能
        - ApplicationContext继承自ApplicationEventPublisher,使得容器拥有发布应用上下文事件的功能,包括容器启动事件、关闭
            事件等.实现了 ApplicationListener 事件监听接口的 Bean 可以接收到容器事件,并对事件进行响应处理
        - ApplicationContext间接继承自ResourceLoader,提供了统一的资源文件访问方式
            - **FileSystemXmlApplicationContext**:该容器从 XML 文件中加载已被定义的 bean,在这里,你需要提供给构造器 XML 文件的完整路径
            - **ClassPathXmlApplicationContext**:该容器从 XML 文件中加载已被定义的 bean,在这里,你不需要提供 XML 文件的完整路径,只需正确配置 CLASSPATH 环境变量即可,因为,容器会从 CLASSPATH 中搜索 bean 配置文件
            - **WebXmlApplicationContext**:该容器会在一个 web 应用程序的范围内加载在 XML 文件中已被定义的 bean
        - 与BeanFactory需要手动注册BeanPostProcessor/BeanFactoryPostProcessor不同,ApplicationContext则是自动注册BeanPostProcessor/BeanFactoryPostProcessor

## IoC 容器启动过程

- 以ClassPathXmlApplicationContext为例，当初始化ClassPathXmlApplicationContext对象的流程如下
    1. `super(parent)`:调用父类构造方法，进行相关的对象创建等操作，如创建资源模式解析器等
    2. `setConfigLocations (configLocations)`:设置配置文件的路径
    3. `refresh()`:刷新IoC容器，IoC的核心方法,该方法加同步监视器锁，确保只有一个线程在初始化IoC容器
        1. `prepareRefresh()`:容器刷新前的一些预处理工作
            - 设置容器启动时间
            - 置一些状态位标识，如active，closed
            - 初始化占位符属性资源
            - 创建环境对象，校验必填属性是否可解析
            -  初始化一些成员变量，如earlyApplicationListeners。 earlyApplicationEvents
        2. `obtainFreshBeanFactory()`：创建DefaultListableBeanFactory工厂,给bean工厂设置一些属性,加载配置文件信息,封装成bean定义信息
            - 创建bean工厂,类型是DefaultListableBeanFactory
            - 设置bean工厂的序列化ID
            - 定制化bean工厂,其实也是设置一些属性,如allowBeanDefinitionOverriding、 allowCircularReferences
            - 加载bean定义信息，初始化BeanDefinitionReader读取器，将配置文件转换成输入流对象，通过SAX解析XML文件中的默认标签以及自定义标签内容，封装成BeanDefinition，注册到DefaultListableBeanFactory#beanDefinitionMap中
        3. `prepareBeanFactory(beanFactory)`:设置bean工厂的一些屋性,如添加一些BeanPostProcessor增强器等
            - 设置bean类加载器信息
            - 添加一些BeanPostProcessor增强器
            - 忽略一些接口的自动装配依赖
            - 注册一些bean对象到容器中,如environment. systemProperties等
        4. `postProcessBeanFactory(beanFactory)`:模板方法，留給子类扩展实现,允许子类修改、扩展bean工厂
        5. `invokeBeanFactoryPostProcessors(beanFactory)`:执行BeanFactoryPostProcessor的`postProcessBeanFactory()`增强方法
            - 调用实现了PriorityOrdered接口的BeanDefinitionRegistryPostProcessors
            - 调用实现了Ordered接口的BeanDefinitionRegistryPostProcessors
            - 其它BeanDefinitionRegistryPostProcessors
            - 调用实现了PriorityOrdered接口的BeanFactoryPostProcessor
            - 调用实现了Ordered接口的BeanFactoryPostProcessor
            - 调用其它BeanFactoryPostProcessor
        6. `registerBeanPostProcessors(beanFactory)`:注册BeanPostProcessor增强器，注意这里只是注册，真正是在初始化阶段的前后执行
            - 注册实现了PriorityOrdered接口的BeanPostProcessor
            - 注册实现了Ordered接口的BeanPostProcessor
            - 注册其它BeanPostProcessor
        7. `initMessageSource()`:初始化MessageSource,国际化处理
        8. `initApplicationEventMulticaster()`:初始化事件多播器
            - 如果容器中存在applicationEventMulticaster,则直接获取,否则创建一个新的SimpleApplicationEventMulticaster,并注册到容器中
        9. `onRefresh()`:模板方法,在单例对象的实例化之前，允许子类做一下扩展
        10. `registerListeners()`:往applicationEventMulticaster事件多播器中注册一系列监听器
        11. `finishBeanFactoryinitialization(beanFactory)`:IoC容器创建最重要的一个步骤：完成非機加载的单例bean对象的实例化，包括反射创建bean对象、屋性填充、循环依赖的处理、bean的初始化等等
            - 循环遍历之前解析后的BeanDefinition定义信息
            - 通过反射创建bean对象
            - bean的属性填充
            - 调用Aware接口相关方法，如BeanNameAware。 BeanFactoryAware等
            - 执行BeanPostProcessor的`postProcessBeforelnitialization()`前置增强方法
            - 执行InitializingBean的`afterPropertiesSet()`方法
            - 执行自定义的初始化方法，如init-method等
            - 执行BeanPostProcessor的`postProcessAfterlnitialization()`后置增强方法
            - 执行DisposableBean的`destroy()`销毁方法
            - 执行自定义的销毁方法，如destroy-method等
        12. `finishRefresh()`:容器刷新完成之后的一些处理工作
            - 清除资源缓存
            - 初始化生命周期处理器，调用onRefreshO刷新方法
            - 发布容器已刷新事件
