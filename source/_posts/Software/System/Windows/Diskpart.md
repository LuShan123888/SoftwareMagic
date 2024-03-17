---
title: Windows Diskpart
categories:
- Software
- System
- Windows
---
# Windows Diskpart

## 创建GPT分区

1. 全新安装Win7或者Win8系统过程中，在选择目标磁盘，安装程序会提示不创建GPT分区，不能完成安装，这时候我们按下Shift+F10，会出现命令提示符（管理员）界面。
2. 键入diskpart命令后回车，然后完成下面的命令，相关命令为：
    - `list disk`：列出系统计算机所有磁盘。
    - `select disk 0`：选择0号磁盘。
3. 选定磁盘后，完成下述命令，相关命令为：
    - `clean`：清除磁盘，该命令将擦除磁盘上的所有数据。
    - `convert gpt`：将磁盘转换为GPT格式。
    - `list partition`：列出磁盘上的分区。
4. 完成查询和转换操作后，输入`list partition`命令，会显示这个磁盘上没有显示的分区，是因为我们刚刚完成转换成GPT分区格式，分区为空，接下来要创建EFI分区及系统安装分区，相关命令为：
    - `create partition efi size=100`：创建EFI分区，大小为100M
    - `create partition msr size=128`：创建MSR分区，微软默认大小是128M
    - `create partition primary size=50000`：创建主分区，这里要注意数字按M计算，50000就是分区大小为50000M，可以根据自己实际情况调整，该分区用来安装win7
    - `list partition`：列出磁盘上的分区。
5. diskpart命令的详细内容，可以利用键入help命令查看。
6. 输入Exit，退出命令提示符界面，返回安装界面。