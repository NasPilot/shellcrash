# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" \
      version="1.9.2" \
      description="ShellCrash Docker Image"

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
    && (echo "1"; sleep 1; echo "1"; sleep 1; echo "1"; sleep 1; echo "1") | sh /tmp/install.sh \
    && source /etc/profile &> /dev/null \
    && (echo "1"; sleep 1; \
        echo "1"; sleep 1; \
        echo "2"; sleep 1; \
        echo "1"; sleep 1; \
        echo "https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml"; sleep 1; \
        echo "1"; sleep 1; \
        echo "1"; sleep 1; \
        echo "0"; echo "2"; sleep 1; \
        echo "1"; sleep 1; \
        echo "1"; sleep 1; echo "7"; sleep 1; \
        echo "4"; sleep 1; \
        echo "0"; sleep 1; \
        echo "0"; sleep 1; \
        echo "1"; sleep 1) | /etc/ShellCrash/menu.sh \
    && rm -rf /tmp/* /var/cache/apk/*

# 端口映射
EXPOSE 7890 9999

# 健康检查
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-check-certificate -q -O - http://localhost:9999/version || exit 1

# 启动命令
ENTRYPOINT ["sh","/etc/ShellCrash/start.sh","start","2"]
