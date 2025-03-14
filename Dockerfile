# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ"

# 工作目录
WORKDIR /root

# 将 shellcrash.sh 文件添加到镜像中的 /root 目录
COPY shellcrash.sh /root/shellcrash.sh

# 设置脚本的可执行权限
RUN chmod +x /root/shellcrash.sh

# 修改系统时间
RUN apk add --no-cache curl wget nftables tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    && apk del tzdata \
    && wget -O /tmp/ShellCrash.tar.gz https://github.com/juewuy/ShellCrash/releases/download/1.9.0/ShellCrash.tar.gz \
    && mkdir -p /tmp/SC_tmp \
    && tar -zxf /tmp/ShellCrash.tar.gz -C /tmp/SC_tmp/ \
    && /bin/sh /tmp/SC_tmp/init.sh \
    && /etc/profile >/dev/null 2>&1 \
    && (echo "2"; sleep 2; echo "0"; sleep 2; echo "1"; sleep 2; echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "https://suo.yt/MQazzkQ"; sleep 2; echo "1"; sleep 5; echo "1"; sleep 5; echo "0") | /etc/ShellCrash/menu.sh \
    && mv /etc/ShellCrash /etc/ShellCrash_bak \
    && mkdir /etc/ShellCrash \
    && rm -rf /tmp/ShellCrash.tar.gz /tmp/SC_tmp
# 映射端口
EXPOSE 7890
EXPOSE 9999

## 设置挂载点
#VOLUME ["/etc/ShellCrash"]

# 设置环境变量
ENV ENV="/etc/profile"

#启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
