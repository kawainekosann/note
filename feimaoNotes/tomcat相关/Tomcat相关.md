# Tomcat相关

[toc]

## 特殊问题

###  linux使用shutdown.sh命令无法关闭tomcat进程的处理方法

1. 修改bin/catalina.sh文件， 查找PRGDIR=`dirname "$PRG"` 这一行；在这一行的下面增加如下3行语句：

```
   if [ -z "$CATALINA_PID" ]; then
     CATALINA_PID=$PRGDIR/CATALINA_PID
      cat $CATALINA_PID
   fi
```
>  功能：判断 CATALINA_PID有没有配置，没有的话，就使用当前目录（bin）的CATALINA_PID文件来记录tomcat的进程ID。

2. 修改tomcat的shutdown.sh文件,在最后一行加上“-force”: 找到命令行： exec "$PRGDIR"/"$EXECUTABLE" stop "$@"  修改为：exec "$PRGDIR"/"$EXECUTABLE" stop -force "$@"  保存即可。