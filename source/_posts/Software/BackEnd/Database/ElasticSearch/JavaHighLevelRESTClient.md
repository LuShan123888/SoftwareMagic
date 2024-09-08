---
title: Elasticsearch Java High Level REST Client
categories:
- Software
- BackEnd
- Database
- ElasticSearch
---
# Elasticsearch Java High Level REST Client

## 初始化

```java
RestHighLevelClient restHighLevelClient = new RestHighLevelClient(
    RestClient.builder(
        new HttpHost("localhost", 9200, "http"),
        new HttpHost("localhost", 9201, "http")));
```

## 关闭连接

```java
restHighLevelClient.close();
```

## 索引API

### 创建索引

```java
// 创建索引请求。
CreateIndexRequest request = new CreateIndexRequest("test_index");
// 客服端执行请求IndicesClient，请求后返回响应。
CreateIndexResponse response = restHighLevelClient.indices().create(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

### 判断索引是否存在

```java
GetIndexRequest request = new GetIndexRequest("test_index");
boolean response = restHighLevelClient.indices().exists(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

### 查询索引

```java
GetIndexRequest request = new GetIndexRequest("test_index");
GetIndexResponse response = restHighLevelClient.indices().get(request, RequestOptions.DEFAULT);
```

### 删除索引

```java
DeleteIndexRequest request = new DeleteIndexRequest("test_index");
AcknowledgedResponse response = restHighLevelClient.indices().delete(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

## 文档API

### 创建文档

```java
// 创建请求。
IndexRequest request= new IndexRequest("test_index");
// 配置请求。
request.id("1");
request.timeout(TimeValue.timeValueSeconds(1));
request.source(JSON.toJSONString(new User("user1", 20)), XContentType.JSON);
// 发送请求，获取响应的结果。
IndexResponse response = restHighLevelClient.index(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

```json
{"fragment":false,"id":"1","index":"test_index","primaryTerm":1,"result":"CREATED","seqNo":0,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":1}
```

### 判断文档是否存在

```java
GetRequest request= new GetRequest("test_index", "1");
boolean response = restHighLevelClient.exists(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

### 查询文档

```java
GetRequest request= new GetRequest("test_index", "1");
GetResponse response = restHighLevelClient.get(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

```json
{"exists":true,"fields":{},"fragment":false,"id":"1","index":"test_index","primaryTerm":1,"seqNo":0,"source":{"name":"user1","age":20},"sourceAsBytes":"eyJhZ2UiOjIwLCJuYW1lIjoidXNlcjEifQ==","sourceAsBytesRef":{"fragment":true},"sourceAsMap":{"$ref":"$.source"},"sourceAsString":"{\"age\":20,\"name\":\"user1\"}","sourceEmpty":false,"sourceInternal":{"$ref":"$.sourceAsBytesRef"},"type":"_doc","version":1}
```

### 更新文档

```java
UpdateRequest request= new UpdateRequest("test_index", "1");
request.doc(JSON.toJSONString(new User("Test", 30)), XContentType.JSON);
UpdateResponse  response= restHighLevelClient.update(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

```json
{"fragment":false,"id":"1","index":"test_index","primaryTerm":1,"result":"UPDATED","seqNo":1,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":2}
```

### 删除文档

```java
DeleteRequest request= new DeleteRequest("test_index", "1");
DeleteResponse response= restHighLevelClient.delete(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

```json
{"fragment":false,"id":"1","index":"test_index","primaryTerm":1,"result":"DELETED","seqNo":2,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":3}
```

### 批量操作文档

```java
 BulkRequest request= new BulkRequest();
        request.timeout("10s");
        ArrayList<User> userList= new ArrayList<>();
        userList.add(new User("test1", 20));
        userList.add(new User("test2", 21));
        userList.add(new User("test3", 22));

        for (int i = 0; i < userList.size(); i++) {
            // 批量添加请求。
            request.add(new IndexRequest("test_index")
                    .id("" + (i + 1))
                    .source(JSON.toJSONString(userList.get(i)), XContentType.JSON)
            );
        }
        BulkResponse response= restHighLevelClient.bulk(request, RequestOptions.DEFAULT);
        System.out.println(JSON.toJSONString(response));
    }
```

```json
{"fragment":false,"ingestTook":{"days":0,"daysFrac":-1.1574074074074074E-8,"hours":0,"hoursFrac":-2.7777777777777776E-7,"micros":-1000,"microsFrac":-1000.0,"millis":-1,"millisFrac":-1.0,"minutes":0,"minutesFrac":-1.6666666666666667E-5,"nanos":-1000000,"seconds":0,"secondsFrac":-0.001,"stringRep":"-1"},"ingestTookInMillis":-1,"items":[{"failed":false,"fragment":false,"id":"1","index":"test_index","itemId":0,"opType":"INDEX","response":{"fragment":false,"id":"1","index":"test_index","primaryTerm":1,"result":"CREATED","seqNo":3,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":1},"type":"_doc","version":1},{"failed":false,"fragment":false,"id":"2","index":"test_index","itemId":1,"opType":"INDEX","response":{"fragment":false,"id":"2","index":"test_index","primaryTerm":1,"result":"CREATED","seqNo":4,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":1},"type":"_doc","version":1},{"failed":false,"fragment":false,"id":"3","index":"test_index","itemId":2,"opType":"INDEX","response":{"fragment":false,"id":"3","index":"test_index","primaryTerm":1,"result":"CREATED","seqNo":5,"shardId":{"fragment":true,"id":-1,"index":{"fragment":false,"name":"test_index","uUID":"_na_"},"indexName":"test_index"},"shardInfo":{"failed":0,"failures":[],"fragment":false,"successful":1,"total":2},"type":"_doc","version":1},"type":"_doc","version":1}],"took":{"days":0,"daysFrac":1.7476851851851853E-6,"hours":0,"hoursFrac":4.194444444444445E-5,"micros":151000,"microsFrac":151000.0,"millis":151,"millisFrac":151.0,"minutes":0,"minutesFrac":0.0025166666666666666,"nanos":151000000,"seconds":0,"secondsFrac":0.151,"stringRep":"151ms"}}
```

## 搜索API

### match

```java
// 创建查询请求。
SearchRequest request = new SearchRequest();
// 构建查询条件。
MatchQueryBuilder query = QueryBuilders.matchQuery("name", "test1");
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
searchSourceBuilder.from(0);
searchSourceBuilder.size(2);
searchSourceBuilder.query(query);
request.source(searchSourceBuilder);
// 执行查询。
SearchResponse response= restHighLevelClient.search(request, RequestOptions.DEFAULT);
System.out.println(JSON.toJSONString(response));
```

```json
{"clusters":{"fragment":true,"skipped":0,"successful":0,"total":0},"failedShards":0,"fragment":false,"hits":{"fragment":true,"hits":[{"fields":{},"fragment":false,"highlightFields":{"$ref":"$.hits.hits[0].fields"},"id":"1","matchedQueries":[],"primaryTerm":0,"rawSortValues":[],"score":0.9808291,"seqNo":-2,"sortValues":[],"sourceAsMap":{"name":"test1","age":20},"sourceAsString":"{\"age\":20,\"name\":\"test1\"}","sourceRef":{"fragment":true},"type":"_doc","version":-1}],"maxScore":0.9808291,"totalHits":{"relation":"EQUAL_TO","value":1}},"internalResponse":{"fragment":true,"numReducePhases":1},"numReducePhases":1,"profileResults":{"$ref":"$.hits.hits[0].fields"},"shardFailures":[],"skippedShards":0,"successfulShards":2,"timedOut":false,"took":{"days":0,"daysFrac":6.458333333333333E-6,"hours":0,"hoursFrac":1.55E-4,"micros":558000,"microsFrac":558000.0,"millis":558,"millisFrac":558.0,"minutes":0,"minutesFrac":0.0093,"nanos":558000000,"seconds":0,"secondsFrac":0.558,"stringRep":"558ms"},"totalShards":2}
```

