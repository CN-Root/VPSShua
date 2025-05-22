#!/bin/bash

INSTALL_DIR="/etc/VPSShua"
BIN_PATH="/usr/local/bin/vpsshua"
SCRIPT_URL="https://raw.githubusercontent.com/yourname/vpsshua/main/vpsshua.sh"  # ← 请替换为你的真实 URL

echo "📁 创建安装目录: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

echo "⬇️ 正在下载主程序到 $INSTALL_DIR/vpsshua.sh ..."
sudo curl -Ls "$SCRIPT_URL" -o "$INSTALL_DIR/vpsshua.sh"

echo "🔒 设置执行权限..."
sudo chmod +x "$INSTALL_DIR/vpsshua.sh"

echo "🔗 添加软链接到 /usr/local/bin/vpsshua"
sudo ln -sf "$INSTALL_DIR/vpsshua.sh" "$BIN_PATH"

# 检查是否成功
if command -v vpsshua >/dev/null 2>&1; then
    echo -e "\n✅ 安装成功！你现在可以输入以下命令启动脚本：\n"
    echo "  vpsshua"
    echo -e "\n🚨 提示：脚本默认安装路径为 ${INSTALL_DIR}"
else
    echo "⚠️ 安装完成，但未检测到 vpsshua 命令，请检查软链接或重新安装"
fi
