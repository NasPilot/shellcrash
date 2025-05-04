# 基础镜像
FROM alpine:latest

# 版本参数和作者信息
ARG VERSION=1.9.1
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="${VERSION}"

# 环境变量和工作目录
ENV TZ=Asia/Shanghai ENV="/etc/profile"
WORKDIR /root

# 复制文件并执行所有安装配置
COPY shellcrash.sh /root/shellcrash.sh
RUN set -ex \
    # 安装基础软件包
    && apk add --no-cache curl wget nftables tzdata ca-certificates \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata \
    # 配置nftables
    && mkdir -p /etc/nftables \
    && echo "flush ruleset" > /etc/nftables/nftables.conf \
    # 安装ShellCrash
    && chmod +x /root/shellcrash.sh \
    && wget https://raw.githubusercontent.com/juewuy/ShellCrash/master/install.sh \
    && (echo "1"; sleep 1; echo "2"; sleep 3; echo "1"; sleep 1; echo "1") | sh install.sh \
    # 配置ShellCrash
    && source /etc/profile &> /dev/null \
    && until wget -q --spider https://github.com/NasPilot/shellcrash/raw/main/config.yaml; do sleep 5; done \
    && (echo "2"; sleep 2; \
        echo "1"; sleep 4; \
        echo "1"; sleep 2; \
        echo "2"; sleep 2; \
        echo "1"; sleep 2; \
        echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 4; \
        echo "1"; sleep 4; \
        echo "0") | /etc/ShellCrash/menu.sh \
    # 配置内核功能和面板
    && printf "9\n2\n3\n4\n3\n0\n2\n1\n1\n7\n4\n0\n2\n2\n0" | /etc/ShellCrash/menu.sh \
    && mv /etc/ShellCrash /etc/ShellCrash_bak \
    && mkdir /etc/ShellCrash \
    # 清理缓存
    && rm -rf /tmp/* /var/cache/apk/*

# 端口和目录映射
EXPOSE 7890 9999
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]