#日历(基于8086汇编语言)
---
![](https://raw.githubusercontent.com/muyangren907/calendar/master/screenshot/1.jpg)
![](https://raw.githubusercontent.com/muyangren907/calendar/master/screenshot/2.jpg)

##下载
[Releases](https://github.com/muyangren907/calendar/releases)
## 使用
有两种使用方式供您选择
- 1.下载成品
在上述release中下载，解压，运行即可（64位系统需使用dosbox等模拟运行）

- 2.编译运行
下载源码文件CAL.ASM
下载编译工具MASM(包含MASM.EXE和LINK.EXE)
>MASM文件夹中包含了5和6.11两个版本的MASM,择一下载，解压可用

将源码文件和MASM置于同一文件夹，打开cmd窗口，进入该文件夹，输入
```
MASM CAL.ASM;
LINK CAL;
```
这时候就编译出了CAL.EXE文件，运行它即可