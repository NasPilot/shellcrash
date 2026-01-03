# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="1.9.3"

# 环境变量
ENV TZ="Asia/Shanghai" \
    ENV="/etc/profile" \
    URL="https://raw.githubusercontent.com/juewuy/ShellCrash/stable"

# 工作目录
WORKDIR /root

# 复制文件并执行所有安装配置
COPY shellcrash.sh /root/shellcrash.sh
RUN set -ex && apk add --no-cache curl wget nftables tzdata ca-certificates bash \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && apk del tzdata && chmod +x /root/shellcrash.sh \
    # 安装ShellCrash
    ## && wget -q --no-check-certificate -O /tmp/install.sh ${URL}/install.sh  && bash /tmp/install.sh && source /etc/profile &> /dev/null \
    && wget ${URL}/install.sh \
    && (echo "1"; sleep 1; echo "1"; sleep 3; echo "1"; sleep 2; echo "1") | sh install.sh \
    # 配置ShellCrash 切换稳定版及Github直连源 更新面板和内核
    && (echo "2"; sleep 2; \
        echo "1"; sleep 2; \
        echo "0"; sleep 1; \
        echo "9"; sleep 3; \
        echo "7"; sleep 1; \
        echo "a"; sleep 1; \
        echo "2"; sleep 2; \
        echo "4"; sleep 1; \
        echo "1"; sleep 3; \
        echo "2"; sleep 2; \
        echo "1"; sleep 4; \
        echo "6"; sleep 1; \
        echo "2"; sleep 1; \
        echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 4; \
        echo "1"; sleep 4; \
        echo "0") | /etc/ShellCrash/menu.sh \
    # 更新mihomo数据库
    && printf "9\n3\n3\n5\n0\n0\n0" | /etc/ShellCrash/menu.sh \
    && mv /etc/ShellCrash /etc/ShellCrash_bak && mkdir /etc/ShellCrash \
    && rm -rf /tmp/* /var/cache/apk/*

# 端口和目录映射
EXPOSE 7890 9999
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
