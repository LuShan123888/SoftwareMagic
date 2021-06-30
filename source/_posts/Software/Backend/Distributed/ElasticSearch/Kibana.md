---
title: Elasticsearch 整合Kibana
categories:
- Software
- Backend
- Distributed
- ElasticSearch
---
# Elasticsearch 整合Kibana

## 安装

### Docker

```shell
$ docker run --name kib01-test --net elastic -p 5601:5601 -e "ELASTICSEARCH_HOSTS=http://es01-test:9200" docker.elastic.co/kibana/kibana:7.13.2
```

## 使用

- 浏览器访问http://localhost:5061
- 通过Dev Tools可以使用Console查询

![image-20210622143048341](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210622143116.png)
