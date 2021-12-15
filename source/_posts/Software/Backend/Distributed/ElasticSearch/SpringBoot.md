---
title: Elasticsearch 整合Spring Boot
categories:
- Software
- Backend
- Distributed
- ElasticSearch
---
# Elasticsearch 整合Spring Boot

## pom.xml

```xml
<properties>
    <elasticsearch.version>7.13.2</elasticsearch.version>
</properties>
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-high-level-client</artifactId>
    <version>7.13.2</version>
</dependency>
```

## 配置

- 将RestHighLevelClient注入Spring

```java
@Configuration
public class ElasticsearchClientConfig {

    @Bean
    public RestHighLevelClient restHighLevelClient() {
        RestHighLevelClient client = new RestHighLevelClient(
            RestClient.builder(
                new HttpHost("localhost", 9200, "http"))
        );
        return client;
    }
}
```

## 测试

```java
public class ElasticsearchClientTest {
    @Autowired
    private RestHighLevelClient restHighLevelClient;

    @Test
    void ClientTest() throws IOException {
        CreateIndexRequest test_index = new CreateIndexRequest("test_index");
        CreateIndexResponse createIndexResponse = restHighLevelClient.indices().create(test_index, RequestOptions.DEFAULT);
        System.out.println(JSON.toJSONString(createIndexResponse));
    }
}
```

```json
{"acknowledged":true,"fragment":false,"shardsAcknowledged":true}
```

