# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ"
LABEL version="1.9.0"

WORKDIR /root

# 复制本地安装包和配置文件
COPY shellcrash.sh /root/
COPY ShellCrash.tar.gz /tmp/
COPY config.yaml /tmp/

# 设置时区并安装ShellCrash
RUN apk add --no-cache curl wget tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone && apk del tzdata \
    && mkdir -p /tmp/SC_tmp \
    && tar -zxf '/tmp/ShellCrash.tar.gz' -C /tmp/SC_tmp/ \
    && (echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "1") | sh /tmp/SC_tmp/install.sh \
    && source /etc/profile > /dev/null \
    && (echo "2"; sleep 2; echo "0"; sleep 2; echo "1"; sleep 2; echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "3"; sleep 2; echo "1"; sleep 5; echo "0") | /etc/ShellCrash/menu.sh \
    && mv /etc/ShellCrash /etc/ShellCrash_bak \
    && mkdir /etc/ShellCrash

# 端口映射
EXPOSE 7890 9999

# 设置环境变量
ENV ENV="/etc/profile"

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
