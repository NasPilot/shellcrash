#!/bin/sh
source /etc/profile

# 初始化 nftables
nft -f /etc/nftables/nftables.conf

# 检测并补全文件
if [ -z "$(ls -A /etc/ShellCrash)" ] || [ ! -f "/etc/ShellCrash/start.sh" ]; then
    # 如果文件夹为空或缺少关键文件，从备份中复制
    cp -rL /etc/ShellCrash_bak/* /etc/ShellCrash/
fi

# 启动服务
/etc/ShellCrash/start.sh start 2>/dev/null
echo "ShellCrash启动成功，请进入容器，输入crash进行管理！"

# 保持容器运行
exec sh
