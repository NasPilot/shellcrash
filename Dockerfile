FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ"

# 工作目录和环境变量设置
WORKDIR /root
ENV TZ=Asia/Shanghai \
    ENV="/etc/profile"

# 复制文件并设置权限
COPY shellcrash.sh /root/shellcrash.sh
RUN chmod +x /root/shellcrash.sh

# 安装必要的软件包并配置
RUN set -ex \
    && apk add --no-cache curl wget nftables tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata \
    && export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' \
    && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh \
    && (echo "1"; sleep 2; echo "1"; sleep 3; echo "1"; sleep 4; echo "1") | sh /tmp/install.sh \
    && source /etc/profile &> /dev/null \
    && (echo "1"; sleep 1; \
        echo "1"; sleep 2; \
        echo "2"; sleep 3; \
        echo "1"; sleep 4; \
        echo "https://suo.yt/kLxRjoY"; sleep 5; \
        echo "1"; sleep 6; \
        echo "1"; sleep 7; \
        echo "0"; echo "2"; sleep 8; \
        echo "1"; sleep 9; \
        echo "1"; sleep 10; echo "7"; sleep 11; \
        echo "4"; sleep 12; \
        echo "0"; sleep 13; \
        echo "0"; sleep 14; \
        echo "1"; sleep 15) | /etc/ShellCrash/menu.sh \
    && rm -rf /tmp/* /var/cache/apk/*

# 备份初始配置
RUN cp -r /etc/ShellCrash /etc/ShellCrash_bak

# 端口映射
EXPOSE 7890 9999

# 健康检查
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-check-certificate -q -O - http://localhost:9999/version || exit 1

# 启动命令
ENTRYPOINT ["sh", "shellcrash.sh"]
