# 基础镜像
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
RUN apk add --no-cache curl wget nftables tzdata ca-certificates \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata \
    && wget https://raw.githubusercontent.com/juewuy/ShellCrash/master/install.sh \
    && (echo "1"; sleep 2; echo "2"; sleep 2; echo "1"; sleep 2; echo "1") | sh install.sh \
    && source /etc/profile &> /dev/null

# 安装 ShellCrash
RUN (echo "2"; sleep 2; \
    echo "0"; sleep 2; \
    echo "1"; sleep 2; \
    echo "1"; sleep 2; \
    echo "2"; sleep 2; \
    echo "1"; sleep 2; \
    echo "https://suo.yt/kLxRjoY"; sleep 5; \
    echo "1"; sleep 5; \
    echo "1"; sleep 5; \
    echo "0") | /etc/ShellCrash/menu.sh \
    && rm -rf /tmp/* /var/cache/apk/*

# 备份初始配置
RUN cp -r /etc/ShellCrash /etc/ShellCrash_bak

# 端口映射
EXPOSE 7890 9999

# 启动命令
ENTRYPOINT ["sh", "shellcrash.sh"]
