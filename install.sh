#!/bin/bash

REPO="CN-Root/VPSShua"
INSTALL_DIR="/etc/VPSShua"
BIN_PATH="/usr/local/bin/vpsshua"

# 1. 通过 GitHub API 获取最新 release 的 tag 名称
echo "🔍 获取最新版本号..."
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "❌ 获取最新版本失败，使用 main 分支版本代替"
    SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/VPSShua.sh"
else
    echo "✅ 最新版本是 $LATEST_TAG"
    # 2. 拼接最新版本脚本的下载地址
    # 假设脚本在 releases 中是以 VPSShua.sh 命名的资产，或者放在源码树下
    # 这里以源码树的方式示范，如果你有上传资产，请替换为实际的资产下载地址
    SCRIPT_URL="https://raw.githubusercontent.com/$REPO/$LATEST_TAG/VPSShua.sh"
fi

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
