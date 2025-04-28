# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" \
      version="1.9.2beta3"

# 工作目录
WORKDIR /root

# 环境变量
ENV TZ=Asia/Shanghai \
    ENV="/etc/profile"

# 复制文件
COPY shellcrash.sh /root/shellcrash.sh

# 安装软件
RUN set -ex \
    && apk add --no-cache curl wget tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone && apk del tzdata \
    && wget https://raw.githubusercontent.com/juewuy/ShellCrash/master/install.sh && (echo "1"; sleep 2; echo "1"; sleep 2; echo "1"; sleep 2; echo "1") | sh install.sh \
    && source /etc/profile &> /dev/null && (echo "2"; sleep 2; echo "0"; sleep 2; echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 2; echo "1"; sleep 5; echo "0") | /etc/ShellCrash/menu.sh && mv /etc/ShellCrash /etc/ShellCrash_bak && mkdir /etc/ShellCrash

# 端口映射
EXPOSE 7890 9999

# 挂载目录
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]