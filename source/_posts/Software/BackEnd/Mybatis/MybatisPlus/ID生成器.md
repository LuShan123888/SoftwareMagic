---
title: Mybatis Plus ID生成器
categories:
- Software
- BackEnd
- Mybatis
- MybatisPlus
---
# Mybatis Plus ID生成器

## 实体类字段注解`@TableId(type=IdType.)`

- 自3.3.0开始，默认使用雪花算法+UUID（不含中划线）

|        值         |                             描述                             |
| :---------------: | :----------------------------------------------------------: |
|       AUTO        |                         数据库ID自增                         |
|       NONE        | 无状态，该类型为未设置主键类型（注解里等于跟随全局，全局里约等于 INPUT) |
|       INPUT       |                    insert前自行set主键值                     |
|     ASSIGN_ID     | 分配ID（主键类型为Number(Long和Integer）或String)(since 3.3.0)，使用接口`IdentifierGenerator`的方法`nextId`（默认实现类为`DefaultIdentifierGenerator`雪花算法） |
|    ASSIGN_UUID    | 分配UUID，主键类型为String(since 3.3.0)，使用接口`IdentifierGenerator`的方法`nextUUID`（默认default方法） |
|   ~~ID_WORKER~~   |     分布式全局唯一ID 长整型类型（please use `ASSIGN_ID`)      |
|     ~~UUID~~      |           32位UUID字符串（please use `ASSIGN_UUID`)           |
| ~~ID_WORKER_STR~~ |     分布式全局唯一ID 字符串类型（please use `ASSIGN_ID`)      |

## 自定义ID生成器

| 方法     | 主键生成策略                        | 主键类型            | 说明                                                         |
| -------- | ----------------------------------- | ------------------- | ------------------------------------------------------------ |
| nextId   | ASSIGN_ID, ID_WORKER, ID_WORKER_STR | Long,Integer,String | 支持自动转换为String类型，但数值类型不支持自动转换，需精准匹配，例如返回Long，实体主键就不支持定义为Integer |
| nextUUID | ASSIGN_UUID, UUID                   | String              | 默认不含中划线的UUID生成                                     |

### 方式一：声明为bean供spring扫描注入

```java
@Component
public class CustomIdGenerator implements IdentifierGenerator {
    @Override
    public Long nextId(Object entity) {
      	// 可以将当前传入的class全类名来作为bizKey，或者提取参数来生成bizKey进行分布式Id调用生成。
      	String bizKey = entity.getClass().getName();
        // 根据bizKey调用分布式ID生成。
        long id = ....;
      	// 返回生成的id值即可。
        return id;
    }
}
```

### 方式二：使用配置类

```java
@Bean
public IdentifierGenerator idGenerator() {
    return new CustomIdGenerator();
}
```

### 方式三：通过MybatisPlusPropertiesCustomizer自定义

```java
@Bean
public MybatisPlusPropertiesCustomizer plusPropertiesCustomizer() {
    return plusProperties -> plusProperties.getGlobalConfig().setIdentifierGenerator(new CustomIdGenerator());
}
```