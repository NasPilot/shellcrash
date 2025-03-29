# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ"

# 工作目录
WORKDIR /root

ENV TZ=Asia/Shanghai

# 将 shellcrash.sh 文件添加到镜像中的 /root 目录
COPY shellcrash.sh /root/shellcrash.sh

# 设置脚本的可执行权限
RUN chmod +x /root/shellcrash.sh

# 安装必要的软件包
RUN apk add --no-cache curl wget nftables tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone && apk del tzdata \
    && export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' \
    && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh  \
    && (echo "1"; sleep 2; echo "1"; sleep 3; echo "1"; sleep 2; echo "1") | sh /tmp/install.sh \
    && source /etc/profile &> /dev/null \
    && (echo "1"; sleep 2; \
        echo "1"; sleep 3; \
        echo "2"; sleep 2; \
        echo "1"; sleep 1; \
        echo "https://suo.yt/EeCE6z4"; sleep 2; \
        echo "1"; sleep 5; \
        echo "1"; sleep 120; \
        echo "0"; echo "2"; sleep 2; \
        echo "1"; sleep 2; \
        echo "1"; sleep 2; echo "7"; sleep 2; \
        echo "4"; sleep 2; \
        echo "0"; sleep 2; \
        echo "0"; sleep 2; \
        echo "1"; sleep 2) | /etc/ShellCrash/menu.sh

# 映射端口
EXPOSE 7890
EXPOSE 9999

## 设置挂载点
#VOLUME ["/etc/ShellCrash"]

# 设置环境变量
ENV ENV="/etc/profile"

#启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
#ENTRYPOINT ["sh","/etc/ShellCrash/start.sh start 2"]
