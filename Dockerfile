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
    # 安装 ShellCrash
    && printf "1\n1\n1\n1\n" | sh /tmp/install.sh \
    && . /etc/profile \
    # 创建配置目录
    && mkdir -p /etc/ShellCrash/yamls \
    # 下载并配置文件
    && wget -q --no-check-certificate -O /etc/ShellCrash/configs/ShellCrash.yaml https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml \
    # 配置 ShellCrash（选择Linux设备模式并完成初始化配置）
    && printf "2\n1\n1\n1\n1\n1\n0\n" | /etc/ShellCrash/menu.sh \
    && rm -rf /tmp/* /var/cache/apk/*

# 端口映射
EXPOSE 7890 9999

# 健康检查
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-check-certificate -q -O - http://localhost:9999/version || exit 1

# 备份初始配置
RUN cp -r /etc/ShellCrash /etc/ShellCrash_bak

# 启动命令
ENTRYPOINT ["sh", "shellcrash.sh"]
