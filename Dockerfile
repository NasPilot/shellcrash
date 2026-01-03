# 基础镜像
FROM alpine:latest
# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="1.9.3"

# 参数和环境变量
ARG TARGETPLATFORM
ENV TZ="Asia/Shanghai" \
    CRASHDIR="/etc/ShellCrash" \
    URL="https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@stable" \
    systype="container"

WORKDIR /root

# 1. 安装基础依赖
RUN set -ex \
    && apk add --no-cache curl wget nftables tzdata ca-certificates bash tar \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata

# 2. 安装 ShellCrash 脚本 (非交互式)
# 直接下载并解压脚本包，替代 install.sh 的交互过程
RUN set -ex \
    && mkdir -p ${CRASHDIR} \
    && wget -q --no-check-certificate -O /tmp/ShellCrash.tar.gz ${URL}/ShellCrash.tar.gz \
    && tar -zxf /tmp/ShellCrash.tar.gz -C ${CRASHDIR}/ \
    && rm /tmp/ShellCrash.tar.gz \
    # 运行初始化脚本
    && sh ${CRASHDIR}/init.sh \
    # 创建软链接 (模拟 install.sh 中的 set_alias)
    && ln -sf ${CRASHDIR}/menu.sh /usr/bin/crash \
    && chmod +x ${CRASHDIR}/menu.sh ${CRASHDIR}/start.sh

# 3. 下载并安装内核 (非交互式)
# 根据架构自动选择内核文件，替代 menu.sh 的下载过程
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/amd64")  K=amd64 ;; \
      "linux/arm64")  K=arm64 ;; \
      *) echo "Unsupported platform: $TARGETPLATFORM"; exit 1 ;; \
    esac; \
    wget -q --no-check-certificate -O /tmp/CrashCore.tar.gz "https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/meta/clash-linux-${K}.tar.gz" \
    && tar -zxf /tmp/CrashCore.tar.gz -O > ${CRASHDIR}/CrashCore \
    && chmod +x ${CRASHDIR}/CrashCore \
    && rm /tmp/CrashCore.tar.gz

# 4. 下载配置文件
RUN mkdir -p ${CRASHDIR}/yamls \
    && wget -q --no-check-certificate -O ${CRASHDIR}/yamls/config.yaml "https://cdn.jsdelivr.net/gh/NasPilot/shellcrash@main/config.yaml"

# 5. 下载数据库文件 (非交互式)
RUN set -ex \
    && mkdir -p ${CRASHDIR}/ruleset \
    && wget -q --no-check-certificate -O /tmp/mrs.tar.gz https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/mrs.tar.gz \
    && tar -zxf /tmp/mrs.tar.gz -C ${CRASHDIR}/ruleset/ \
    && wget -q --no-check-certificate -O ${CRASHDIR}/Country.mmdb https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/cn_mini.mmdb \
    && wget -q --no-check-certificate -O ${CRASHDIR}/GeoSite.dat https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/geosite.dat \
    && rm -rf /tmp/*

# 6. 备份配置以便启动时恢复
# shellcrash.sh 启动脚本会检查 /etc/ShellCrash 是否为空，如果为空则从备份恢复
# 这对于持久化存储挂载非常重要
RUN mv ${CRASHDIR} /etc/ShellCrash_bak && mkdir ${CRASHDIR}

# 复制启动脚本
COPY shellcrash.sh /root/shellcrash.sh
RUN chmod +x /root/shellcrash.sh

# 端口和目录映射
EXPOSE 7890 9999
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
