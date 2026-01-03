#!/bin/sh

# 检测/etc/ShellCrash文件夹是否为空
if [ -z "$(ls -A /etc/ShellCrash)" ]; then
    # 如果文件夹为空，则运行指定命令
    cp -rL /etc/ShellCrash_bak/* /etc/ShellCrash
fi

# 在文件恢复后再加载配置，避免 profile 中引用的 menu.sh 不存在
source /etc/profile

# 启动服务
/etc/ShellCrash/start.sh start 2>/dev/null
echo "ShellCrash启动成功，请进入容器，输入crash进行管理！"

# 保持容器运行并提供终端
exec sh
