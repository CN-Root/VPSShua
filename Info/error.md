报错信息：
/usr/local/bin/vpsshua: 行 77: bc: 未找到命令


报错解析：<br/>
说明脚本第 77 行调用了 bc，但系统没装。<br/>
行 248：[: : 需要整数表达式<br/>
说明某个变量因为 bc 执行失败返回了空值，导致后续条件判断失败。

处理方案：<br/>
安装 bc（推荐）<br/>
Ubuntu / Debian：
<pre lang="markdown">sudo apt update && sudo apt install -y bc</pre>

CentOS / RHEL：
<pre lang="markdown">sudo yum install -y bc</pre>

Alpine Linux：
<pre lang="markdown">sudo apk add bc</pre>

<hr>
