---
title: 一致性Hash
categories:
- Software
- BackEnd
- Distributed
---
# 一致性Hash

- 一致性Hash算法主要应用于分布式存储系统中,可以有效地解决分布式存储结构下普通余数Hash算法带来的伸缩性差的问题,可以保证在动态增加和删除节点的情况下尽量有多的请求命中原来的机器节点

### Hash环

- 一致性Hash算法也是使用取模的方法,只是刚才描述的取模法是对服务器的数量进行取模,而一致性Hash算法是对2^ 32取模,,一致性Hash算法将整个Hash值控件组织成一个虚拟的圆环,如假设某Hash函数H的值空间为0~2^32^-1取模(即Hash值是一个32位无符号整型),整个Hash环如下

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20210727105027679.png" alt="image-20210727105027679" style="zoom:67%;" />

- 整个空间按顺时针方向组织,圆环的正上方的点代表0,0点右侧的第一个点代表1,以此类推,2,3,4,5,6...直到2^32^-1,也就是说0点左侧的第一个点代表2^32^-1,把这个由2^32个点组成的圆环称为Hash环
- 下一步将各个服务器使用Hash函数得到Hash值,具体可以选择服务器的主机名(考虑到ip变动,不要使用ip)作为关键字进行Hash,这样每台机器就能确定其在Hash环上的位置,这里假设将上文中三个master节点的IP地址Hash后在Hash环空间的位置如下:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-26-image-20210726230600054.png" alt="image-20210726230600054" style="zoom:33%;" />

- 下面将三条key-value数据也放到环上:将数据key使用相同的函数Hash计算出Hash值,并确定此数据在环上的位置,将数据从所在位置顺时针找第一台遇到的服务器节点,这个节点就是该key存储的服务器
- 例如我们有a,b,c三个key,经过Hash计算后,在环空间上的位置如下:key-a存储在node1,key-b存储在node2,key-c存储在node3

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-26-image-20210726230623831.png" alt="image-20210726230623831" style="zoom:33%;" />

### 容错性和可扩展性

- 现假设Node 2不幸宕机,可以看到此时对象key-a和key-c不会受到影响,只有key-b被重定位到Node 3,一般的,在一致性Hash算法中,如果一台服务器不可用,则受影响的数据仅仅是此服务器到其环空间中前一台服务器(即沿着逆时针方向行走遇到的第一台服务器,如下图中Node 2与Node 1之间的数据,图中受影响的是key-2)之间数据,其它不会受到影响
- 同样的,如果集群中新增一个node 4,受影响的数据是node 1和node 4之间的数据,其他的数据是不受影响的

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-26-image-20210726230713949.png" alt="image-20210726230713949" style="zoom:33%;" />

- 综上所述,一致性Hash算法对于节点的增减都只需重定位环空间中的一小部分数据,具有较好的容错性和可扩展性

### 数据倾斜

- 一致性Hash算法在服务节点太少时,容易因为节点分部不均匀而造成数据倾斜(被缓存的对象大部分集中缓存在某一台服务器上)问题,例如系统中只有两台服务器,此时必然造成大量数据集中到Node 2上,而只有极少量会定位到Node 1上,其环分布如下:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-26-image-20210726231612362.png" alt="image-20210726231612362" style="zoom:33%;" />

- 为了解决数据倾斜问题,一致性Hash算法引入了虚拟节点机制,即对每一个服务节点计算多个Hash,每个计算结果位置都放置一个此服务节点,称为虚拟节点,具体做法可以在主机名的后面增加编号来实现,例如上面的情况,可以为每台服务器计算三个虚拟节点,于是可以分别计算"Node 1#1”,"Node 1#2”,"Node 1#3”,"Node 2#1”,"Node 2#2”,"Node 2#3”的Hash值,于是形成六个虚拟节点:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-26-image-20210726231446887.png" alt="image-20210726231446887" style="zoom:33%;" />

- 上图中虚拟节点node 1#1,node 1#2,node 1#3都属于真实节点node 1,虚拟节点node 2#1,node 2#2,node 2#3都属于真实节点node 2