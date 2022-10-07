---
title: Elasticsearch 整合Kibana
categories:
- Software
- BackEnd
- Database
- ElasticSearch
---
# Elasticsearch 整合Kibana

## 安装

### Docker

```shell
$ docker run --name kibana --net elastic -p 5601:5601 \
-e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" \
--hostname kibana \
docker.elastic.co/kibana/kibana:7.13.2
```

## 使用

- 浏览器访问http://localhost:5061
- 通过Dev Tools可以使用Console查询

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20210714093855919.png)

