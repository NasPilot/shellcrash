# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ"
LABEL version="1.9.0"

WORKDIR /root

# 复制启动脚本到/root目录
COPY shellcrash.sh /root/

# 安装必要的软件包并配置
RUN apk add --no-cache curl wget tzdata  nftables \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone && apk del tzdata \
    && wget https://raw.githubusercontent.com/NasPilot/shellcrash/stable/install.sh && (echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "1") | sh install.sh \
    && source /etc/profile &> /dev/null && (echo "2"; sleep 2; echo "0"; sleep 2; echo "1"; sleep 2; echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "https://suo.yt/MaxjTyR"; sleep 2; echo "1"; sleep 5; echo "1"; sleep 5; echo "0") | /etc/ShellCrash/menu.sh && mv /etc/ShellCrash /etc/ShellCrash_bak && mkdir /etc/ShellCrash

# 端口映射
EXPOSE 7890 9999

# 设置环境变量
ENV ENV="/etc/profile"

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]