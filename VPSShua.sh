#!/bin/bash

# ==============================================
# 流量消耗脚本 - 终极稳定版
# 功能：
# 1. 保留所有原始资源名称
# 2. 支持国内/海外资源选择
# 3. 可设置流量限制和线程数
# 4. 实时统计显示
# 5. 取消设置面板和开机自启功能
# ==============================================

# 定义颜色代码
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[0m"  # 重置颜色

# 初始化变量
TOTAL_BYTES=0
REQUEST_COUNT=0
START_TIME=$(date +%s)
STAT_FILE="/tmp/flow_stats_$$.tmp"
STOP_FILE="/tmp/flow_stop_$$.tmp"
THREADS=1
LIMIT_GB=1
RESOURCE_TYPE="未选择"
SELECTED_URLS=()

# 国内资源（完全保持原始名称）
DOMESTIC=(
    "腾讯:https://www.tencent.com/data/index/index_develop_bg3.jpg "
    "腾讯云:https://qcloudimg.tencent-cloud.cn/raw/a6acc2eb4684190b47a283b636fbe085.png "
    "腾讯视频:https://puui.qpic.cn/vpic_cover/g3346tki83w/g3346tki83w_hz.jpg "
    "WeGame:https://wegame.gtimg.com/g.55555-r.c4663/wegame-home/sc02-03.514d7db8.png "
    "百度网盘:https://nd-static.bdstatic.com/m-static/wp-brand/img/banner.5783471b.png "
    "阿里:https://gw.alicdn.com/tfs/TB1k07QUoY1gK0jSZFCXXcwqXXa-810-450.png "
    "微软:https://cdn.microsoftstore.com.cn/media/product_long_description/3781-00000/2_dupn50xr/4h0yzz2_360.jpg "
    "OPPO:https://dsfs.oppo.com/archives/202505/20250520040508682c3f3436ff8.jpg "
    "VIVO:https://wwwstatic.vivo.com.cn/vivoportal/files/image/home/20250516/0b3ee0e9c797bc3e6756b94f5ddd838b.png "
    "拼多多:https://funimg.pddpic.com/c3affbeb-9b31-4546-b2df-95b62de81639.png.slim.png "
    "斗鱼:https://shark2.douyucdn.cn/front-publish/douyu-web-master/_next/static/media/8.ce6e862f.jpg "
    "字节跳动:https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/8-4@2x-f85835b5e482bccf94c824067caac899.png "
)

# 海外资源（完全保持原始名称）
OVERSEAS=(
    "Cloudflare:https://cf-assets.www.cloudflare.com/dzlvafdwdttg/3NFuZG6yz35QXSBt4ToS9y/920197fd1229641b4d826d9f5d0aa169/globe.webp "
    "GitHub:https://docs.github.com/assets/images/search/copilot-action.png "
    "Vultr:https://www.vultr.com/_images/company/sla-banner-bg.png "
    "Linode:https://www.akamai.com/content/dam/site/en/images/video-thumbnail/2024/learn-akamai-live-api-security.png "
    "BBS中文:https://ichef.bbci.co.uk/ace/ws/800/cpsprodpb/61b3/live/bdc7c940-317f-11f0-96c3-cf669419a2b0.jpg.webp "
    "腾讯云:https://staticintl.cloudcachetci.com/cms/backend-cms/VyhG740_iClick%E5%AE%A2%E6%88%B7%E6%A1%88%E4%BE%8B%E8%A7%86%E9%A2%91%E5%B0%81%E9%9D%A2.png "
    "腾讯视频:https://vfiles.gtimg.cn/vupload/20211124/6d0d431637725495400.png "
    "微软:https://cdn.microsoftstore.com.cn/media/product_long_description/3781-00000/2_dupn50xr/4h0yzz2_360.jpg "
    "OPPO:https://www.oppo.com/content/dam/oppo/common/mkt/v2-2/a5-series-en/v3/topbanner/5120-1280.jpg "
    "VIVO:https://asia-exstatic-vivofs.vivo.com/PSee2l50xoirPK7y/1741005511420/a6938ac9d8aaa342065dc5c9ef1679df.jpg "
    "拼多多:https://funimg.pddpic.com/c3affbeb-9b31-4546-b2df-95b62de81639.png.slim.png "
    "斗鱼:https://shark2.douyucdn.cn/front-publish/douyu-web-master/_next/static/media/8.ce6e862f.jpg "
    "字节跳动:https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/8-4@2x-f85835b5e482bccf94c824067caac899.png "
)

# 清理函数
cleanup() {
    rm -f "$STAT_FILE" "$STOP_FILE" &>/dev/null
    kill $(jobs -p) &>/dev/null
    exit 0
}

# 字节转换
format_bytes() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        echo "$(echo "scale=2; $bytes/1073741824" | bc)GB"
    elif (( bytes >= 1048576 )); then
        echo "$(echo "scale=2; $bytes/1048576" | bc)MB"
    elif (( bytes >= 1024 )); then
        echo "$(echo "scale=2; $bytes/1024" | bc)KB"
    else
        echo "${bytes}B"
    fi
}

# 下载任务
download_task() {
    local url="$1"
    while [ ! -f "$STOP_FILE" ]; do
        # 获取下载字节数
        bytes=$(curl -o /dev/null -s -w "%{size_download}" --connect-timeout 10 "$url" 2>/dev/null)
        
        if [[ "$bytes" =~ ^[0-9]+$ ]] && (( bytes > 0 )); then
            # 写入统计文件
            echo "$bytes" >> "$STAT_FILE"
        fi
        
        sleep 0.1
    done
}

# 显示菜单
show_menu() {
    clear
    echo "======================================"
    echo "         VPSShua|VPS刷下行流量         "
    echo "======================================"
    echo "当前设置:"
    echo "  - 资源类型: $([ -z "$RESOURCE_TYPE" ] && echo "未选择" || echo "$RESOURCE_TYPE")"
    echo "  - 流量限制: ${LIMIT_GB}GB"
    echo "  - 线程数量: ${THREADS}"
    echo "--------------------------------------"
    echo "1. 选择地区 (国内/海外)"
    echo "2. 设置流量限制"
    echo "3. 设置线程数"
    echo "4. 开始运行"
    echo "5. 退出"
    echo "6. 更新 VPSShua"
    echo "======================================"
    echo -e "${RED}VPSShua提醒您："
    echo -e "本脚本仅限交流学习使用|请勿违反使用者当地法律法规的用途"
    echo -e "否则后果自负|我们将不承担任何法律责任${RESET}"
    echo "======================================"
}

# 选择地区
select_region() {
    echo "请选择资源地区:"
    echo "1) 国内资源"
    echo "2) 海外资源"
    read -p "请输入选择(1-2): " choice
    
    case $choice in
        1) RESOURCES=("${DOMESTIC[@]}"); RESOURCE_TYPE="国内" ;;
        2) RESOURCES=("${OVERSEAS[@]}"); RESOURCE_TYPE="海外" ;;
        *) echo "无效选择"; return 1 ;;
    esac
    
    # 显示资源列表
    echo "可用的${RESOURCE_TYPE}资源:"
    for i in "${!RESOURCES[@]}"; do
        echo "$((i+1)). ${RESOURCES[$i]%%:*}"
    done
    
    read -p "选择要使用的资源(默认全部): " res_choice
    if [[ "$res_choice" =~ ^[0-9]+$ ]] && (( res_choice >= 1 && res_choice <= ${#RESOURCES[@]} )); then
        SELECTED_URLS=("${RESOURCES[$((res_choice-1))]#*:}")
    else
        SELECTED_URLS=()
        for res in "${RESOURCES[@]}"; do
            SELECTED_URLS+=("${res#*:}")
        done
    fi
    
    echo "已选择 ${#SELECTED_URLS[@]} 个资源"
}

# 更新 VPSShua
update_vpsshua() {
    echo "正在更新 VPSShua..."
    # 这里添加你的更新逻辑，比如 git pull 或下载最新脚本
    echo "更新完成！"
}

# 主控制函数
main() {
    trap cleanup INT TERM
    
    while true; do
        show_menu
        read -p "请输入选项(1-6): " option
        
        case $option in
            1) select_region ;;
            2) read -p "输入要消耗的流量(GB): " LIMIT_GB ;;
            3) read -p "输入线程数量: " THREADS ;;
            4) start_download ;;
            5) cleanup ;;  # 退出
            6) update_vpsshua ;;
            *) echo "无效选项，请重新输入" ;;
        esac
    done
}

# 开始下载
start_download() {
    [ ${#SELECTED_URLS[@]} -eq 0 ] && { echo "请先选择资源！"; return; }
    
    rm -f "$STAT_FILE" "$STOP_FILE"
    TOTAL_BYTES=0
    REQUEST_COUNT=0
    START_TIME=$(date +%s)
    
    echo "开始下载，按Ctrl+C停止..."
    
    # 启动下载线程
    for ((i=0; i<THREADS; i++)); do
        for url in "${SELECTED_URLS[@]}"; do
            download_task "$url" &
        done
    done
    
    # 监控进度
    while true; do
        if [ -f "$STAT_FILE" ]; then
            TOTAL_BYTES=$(awk '{sum+=$1} END{print sum}' "$STAT_FILE" 2>/dev/null || echo 0)
            REQUEST_COUNT=$(wc -l < "$STAT_FILE" 2>/dev/null || echo 0)
            
            # 检查限制
            LIMIT_BYTES=$(echo "$LIMIT_GB * 1073741824" | bc)
            if (( $(echo "$TOTAL_BYTES >= $LIMIT_BYTES" | bc -l) )); then
                touch "$STOP_FILE"
                break
            fi
            
            # 显示状态
            printf "\r状态: %-10s | 请求: %-6d | 线程: %-2d | 运行: %-4ds" \
                "$(format_bytes $TOTAL_BYTES)" \
                "$REQUEST_COUNT" \
                "$THREADS" \
                "$(( $(date +%s) - START_TIME ))"
        fi
        sleep 1
    done
    
    wait
    echo -e "\n\n报告MJJ|流量任务完成！！！"
    echo "总消耗流量: $(format_bytes $TOTAL_BYTES)"
    echo "总请求次数: $REQUEST_COUNT"
    echo "运行时间: $(( $(date +%s) - START_TIME ))秒"
    echo "======================================"
    echo -e "${RED}        感谢使用|VPSShua|在线要饭        "
    echo -e "U(Tron)：TAKzggBPqf3NmnnJRyKXkT7HduRg999999"
    echo -e "U(Polygon)：0x03ee741aA4cEa38Fd96851995271745BE99FF098${RESET}"
    echo "======================================"
    echo "恰饭广告：联系我们投放广告|TG：baolihou"
    echo "速翻翻|因为专注|所以专业：SUFANFAN.COM"
    echo "======================================"
}

# 启动脚本
main
