# 🌀 VPSShua|刷VPS下行流量|VPS traffic disappears

简介：
VPSShua 是一款用于刷 VPS 下行流量的工具，具备高度稳定性、可配置性强、交互式菜单操作等特性。适合需要模拟下行带宽占用、测试网络性能、或学习流量相关操作的用户使用。<br/><br/>
一键安装：
<pre lang="markdown">bash &lt;(curl -Ls https://raw.githubusercontent.com/CN-Root/VPSShua/refs/heads/main/install.sh)</pre>
<hr/>
✨ 核心功能：
<ui>
<li>✅ 支持国内/海外资源选择：预置多个优质静态资源链接，保持原始名称不变。</li>
<li>✅ 自定义流量限制：按 GB 单位设定刷流上限，自动终止任务。</li>
<li>✅ 可调线程数：可设定并发线程数，灵活控制压力大小。</li>
<li>✅ 实时统计显示：动态展示已使用流量、请求次数与运行时间。</li>
<li>✅ 完善的设置菜单：内置安装、更新、开机自启设置功能。</li>
<li>✅ 断点中止/清理机制：支持 Ctrl+C 优雅终止，自动清理临时文件。</li>
</ui>
<hr/>
🚀 使用场景：
<ui>
<li>VPS 带宽测试与流量跑满验证</li>
<li>突发流量模拟</li>
<li>网络资源响应测试</li>
<li>教学演示 / 学习用途</li>
</ui>
<hr/>
⚠️ 注意事项：
<ui>
<li>本脚本仅用于交流学习用途，不得用于违反任何法律法规的行为。使用者需自行承担使用过程中的一切后果。</li>
</ui>
<hr/>
🧠 技术要点：
<ui>
<li>使用 curl 获取资源，支持错误处理与断点重试。</li>
<li>多线程并发执行，结合 Bash 数组与子进程。</li>
<li>使用 awk 和 bc 实现高精度流量计算。</li>
<li>脚本结构清晰，便于二次开发与扩展。</li>
</ui>
<hr/>
📦 作者附赠：
<ui>
<li>感谢使用 VPSShua，脚本尾部含加密钱包地址，欢迎打赏支持！
广告合作请联系作者：<a href="//t.me/baolihou" target="_blank">TG暴力猴</a></li>
</ui>
