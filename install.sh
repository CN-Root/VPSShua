#!/bin/bash

REPO="CN-Root/VPSShua"
INSTALL_DIR="/etc/VPSShua"
BIN_PATH="/usr/local/bin/vpsshua"

# 1. 获取最新版本信息
echo "🔍 获取最新版本信息..."
API_RESPONSE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
LATEST_TAG=$(echo "$API_RESPONSE" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "❌ 获取最新版本失败，使用 main 分支版本代替"
    SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/vpsshua.sh"
else
    echo "✅ 最新版本是 $LATEST_TAG"
    
    # 2. 获取发布资产 vpsshua.sh 的下载链接
    SCRIPT_URL=$(echo "$API_RESPONSE" | grep "browser_download_url" | grep "vpsshua.sh" | cut -d '"' -f 4)
    
    if [ -z "$SCRIPT_URL" ]; then
        echo "⚠️ 在最新版本中未找到 vpsshua.sh 资产，尝试从源码下载"
        SCRIPT_URL="https://raw.githubusercontent.com/$REPO/$LATEST_TAG/vpsshua.sh"
    fi
fi

echo "📁 创建安装目录: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

echo "⬇️ 正在下载主程序到 $INSTALL_DIR/vpsshua.sh ..."
sudo curl -L "$SCRIPT_URL" -o "$INSTALL_DIR/vpsshua.sh"

echo "🔒 设置执行权限..."
sudo chmod +x "$INSTALL_DIR/vpsshua.sh"

echo "🔗 添加软链接到 $BIN_PATH"
sudo ln -sf "$INSTALL_DIR/vpsshua.sh" "$BIN_PATH"

# 检查是否成功
if command -v vpsshua >/dev/null 2>&1; then
    echo -e "\n✅ 安装成功！你现在可以输入以下命令启动脚本：\n"
    echo "  vpsshua"
    echo -e "\n📂 安装路径：${INSTALL_DIR}"
else
    echo "⚠️ 安装完成，但未检测到 vpsshua 命令，请检查软链接或重新安装"
fi
