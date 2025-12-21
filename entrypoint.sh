#!/bin/sh

# 在后台启动 s6-overlay 服务扫描
# s6-svscan 会监控 /etc/s6-overlay/s6-rc.d 目录并启动所有服务
echo "Starting s6-overlay services in background..."
/bin/s6-svscan /etc/s6-overlay/s6-rc.d &

# 在前台执行一个交互式 shell，作为容器的主进程
# 当你从 Docker UI 连接时，你将连接到这个 shell
exec /bin/sh