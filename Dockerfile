# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="1.9.0"

# 工作目录
WORKDIR /root

# 安装必要的软件包并配置
RUN apk add --no-cache curl wget tzdata nftables && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    apk del tzdata

# 复制文件
COPY ./shellcrash.sh /root/shellcrash.sh
COPY ./ShellCrash.tar.gz /tmp/

# 本地安装ShellCrash并配置
RUN set -ex && mkdir -p /tmp/SC_tmp && \
    tar -zxf '/tmp/ShellCrash.tar.gz' -C /tmp/SC_tmp/ && \
    (echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "1") | sh /tmp/SC_tmp/init.sh && \
    source /etc/profile >/dev/null && \
    (echo "2"; sleep 2; \
     echo "0"; sleep 2; \
     echo "1"; sleep 4; \
     echo "1"; sleep 2; \
     echo "2"; sleep 2; \
     echo "1"; sleep 2; \
     echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 3; \
     echo "1"; sleep 4; \
    #echo "1"; sleep 5; \
     echo "0") | /etc/ShellCrash/menu.sh && \
    # 配置内核和面板
    printf "9\n2\n3\n4\n3\n0" | /etc/ShellCrash/menu.sh &&\
    mv /etc/ShellCrash /etc/ShellCrash_bak && \
    mkdir /etc/ShellCrash && \
    rm -rf /tmp/SC_tmp /tmp/ShellCrash.tar.gz

# 端口映射
EXPOSE 7890 9999
VOLUME /etc/ShellCrash

# 设置环境变量
ENV ENV="/etc/profile"

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]