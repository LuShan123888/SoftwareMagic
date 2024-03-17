---
title: Elasticsearch 中文分词插件IK
categories:
- Software
- BackEnd
- Database
- ElasticSearch
---
# Elasticsearch 中文分词插件 IK

- **分词**: 即把一段中文或者别的划分成一个个的关键字，在搜索时候会把信息进行分词，会把数据库中或者索引库中的数据进行分词，然后进行一个匹配操作，默认的中文分词是将每个字看成一个词，这显然是不符合要求的，所以需要安装中文分词器ik来解决这个问题
- IK 提供了两个分词算法: ik_smart 和 ik_max_word, 其中 ik smart 为最少切分, ik_max_word 为最细粒度划分

### 安装

```shell
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.13.2/elasticsearch-analysis-ik-7.13.2.zip
```

- **注意**: 版本需要和 Elasticsearch 的版本匹配

### 测试

- 使用 Kibana 测试不同分词算法的差别

**ik_smart**: 最少切分每个字只会出现一次

```json
GET _analyze
{
    "analyzer": "ik_smart",
    "text": ["南京市长江大桥"]
}
```

```json
{
    "tokens" : [
        {
            "token" : "南京市",
            "start_offset" : 0,
            "end_offset" : 3,
            "type" : "CN_WORD",
            "position" : 0
        },
        {
            "token" : "长江大桥",
            "start_offset" : 3,
            "end_offset" : 7,
            "type" : "CN_WORD",
            "position" : 1
        }
    ]
}

```

**ik_max_word**: 最细粒度划分，尽量匹配更多的词语，单字会重复

```json
GET _analyze
{
    "analyzer": "ik_max_word",
    "text": ["南京市长江大桥"]
}
```

```json
{
    "tokens" : [
        {
            "token" : "南京市",
            "start_offset" : 0,
            "end_offset" : 3,
            "type" : "CN_WORD",
            "position" : 0
        },
        {
            "token" : "南京",
            "start_offset" : 0,
            "end_offset" : 2,
            "type" : "CN_WORD",
            "position" : 1
        },
        {
            "token" : "市长",
            "start_offset" : 2,
            "end_offset" : 4,
            "type" : "CN_WORD",
            "position" : 2
        },
        {
            "token" : "长江大桥",
            "start_offset" : 3,
            "end_offset" : 7,
            "type" : "CN_WORD",
            "position" : 3
        },
        {
            "token" : "长江",
            "start_offset" : 3,
            "end_offset" : 5,
            "type" : "CN_WORD",
            "position" : 4
        },
        {
            "token" : "大桥",
            "start_offset" : 5,
            "end_offset" : 7,
            "type" : "CN_WORD",
            "position" : 5
        }
    ]
}
```

## 扩展配置

- 新建 `test.dic`

```
江大桥
```

- 修改 IKanalyer 配置文件 `./config/analysis-ik/IKAnalyzer.cfg.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
        <comment>IK Analyzer 扩展配置</comment>
        <!--用户可以在这里配置自己的扩展字典 -->
        <entry key="ext_dict">test.dic</entry>
         <!--用户可以在这里配置自己的扩展停止词字典-->
        <entry key="ext_stopwords"></entry>
        <!--用户可以在这里配置远程扩展字典 -->
        <!-- <entry key="remote_ext_dict">words_location</entry> -->
        <!--用户可以在这里配置远程扩展停止词字典-->
        <!-- <entry key="remote_ext_stopwords">words_location</entry> -->
</properties>
```

- 重启 Elasticsearch, 使用 Kibana 测试

```json
GET _analyze
{
  "analyzer": "ik_max_word",
  "text": ["南京市长江大桥"]
}
```

```json
{
  "tokens" : [
    {
      "token" : "南京市",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "CN_WORD",
      "position" : 0
    },
    {
      "token" : "南京",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "CN_WORD",
      "position" : 1
    },
    {
      "token" : "市长",
      "start_offset" : 2,
      "end_offset" : 4,
      "type" : "CN_WORD",
      "position" : 2
    },
    {
      "token" : "长江大桥",
      "start_offset" : 3,
      "end_offset" : 7,
      "type" : "CN_WORD",
      "position" : 3
    },
    {
      "token" : "长江",
      "start_offset" : 3,
      "end_offset" : 5,
      "type" : "CN_WORD",
      "position" : 4
    },
    {
      "token" : "江大桥",
      "start_offset" : 4,
      "end_offset" : 7,
      "type" : "CN_WORD",
      "position" : 5
    },
    {
      "token" : "大桥",
      "start_offset" : 5,
      "end_offset" : 7,
      "type" : "CN_WORD",
      "position" : 6
    }
  ]
}

```

- 相比于之前 `江大桥` 成功被分词