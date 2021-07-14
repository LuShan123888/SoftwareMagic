---
title: Redis EVAL命令
categories:
- Software
- Backend
- Database
- Redis
---
# Redis EVAL命令

- Redis Eval 命令使用 Lua 解释器执行脚本
- redis Eval 命令基本语法如下:

```
redis 127.0.0.1:6379> EVAL script numkeys key [key ...] arg [arg ...]
```

- `script`:参数是一段 Lua 5.1 脚本程序,脚本不必(也不应该)定义为一个 Lua 函数
- `numkeys`:用于指定键名参数的个数
- `key [key ...]`:从 EVAL 的第三个参数开始算起,表示在脚本中所用到的那些 Redis 键(key),这些键名参数可以在 Lua 中通过全局变量 KEYS 数组,用 1 为基址的形式访问( KEYS[1],KEYS[2],以此类推)
- `arg [arg ...]`:附加参数,在 Lua 中通过全局变量 ARGV 数组访问,访问的形式和 KEYS 变量类似( ARGV[1],ARGV[2],诸如此类)

## 实例

```
redis 127.0.0.1:6379> eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second
1) "key1"
2) "key2"
3) "first"
4) "second"
```