# 基础镜像
FROM alpine:latest

# 版本参数
ARG VERSION=1.9.1

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" \
      version="${VERSION}"

# 工作目录
WORKDIR /root

# 设置时区
ENV TZ=Asia/Shanghai \
    ENV="/etc/profile"

# 复制文件
COPY shellcrash.sh /root/shellcrash.sh

# 安装软件
RUN set -ex && chmod +x /root/shellcrash.sh \
    && apk add --no-cache curl wget nftables tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone && apk del tzdata \
    # 安装ShellCrash
    && wget https://raw.githubusercontent.com/juewuy/ShellCrash/master/install.sh \
    && (echo "1"; sleep 1; echo "2"; sleep 3; echo "1"; sleep 1; echo "1") | sh install.sh \
    # 配置ShellCrash
    && source /etc/profile &> /dev/null \
    && (echo "2"; sleep 2; \
        echo "1"; sleep 4; \
        echo "1"; sleep 2; \
        echo "2"; sleep 2; \
        echo "1"; sleep 2; \
        echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 4; \
        echo "1"; sleep 4; \
        echo "0"; sleep 1; \
        echo "1") | /etc/ShellCrash/menu.sh \
    && mv /etc/ShellCrash /etc/ShellCrash_bak && mkdir /etc/ShellCrash \
    && rm -rf /tmp/* /var/cache/apk/*

# 端口映射
EXPOSE 7890 9999

# 目录映射
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]