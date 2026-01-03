# 基础镜像
FROM alpine:latest

# 作者信息
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="1.9.3"

# 环境变量
ENV TZ="Asia/Shanghai" \
    ENV="/etc/profile" \
    URL="https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@stable" \
    CRASHDIR="/etc/ShellCrash"

# 工作目录
WORKDIR /root

# 复制文件并执行所有安装配置
COPY shellcrash.sh /root/shellcrash.sh
RUN set -ex \
    && apk add --no-cache curl wget nftables tzdata ca-certificates bash \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata \
    && chmod +x /root/shellcrash.sh

# 安装ShellCrash
# 注意：
# 1. 使用 bash 运行 install.sh
# 2. 预设 CRASHDIR 以跳过目录选择，输入 "1" 确认覆盖，输入 "1" 选择 crash 别名
# 3. export systype=container 帮助脚本识别容器环境
RUN wget -q --no-check-certificate -O /tmp/install.sh ${URL}/install.sh \
    && export systype=container \
    && (echo "1"; echo "1") | bash /tmp/install.sh \
    && . /etc/profile \
    # 配置ShellCrash 切换稳定版及Github直连源 更新面板和内核
    && (echo "9"; sleep 3; \
        echo "7"; sleep 1; \
        echo "a"; sleep 1; \
        echo "2"; sleep 2; \
        echo "4"; sleep 1; \
        echo "1"; sleep 3; \
        echo "2"; sleep 2; \
        echo "1"; sleep 4; \
        echo "6"; sleep 1; \
        echo "2"; sleep 1; \
        echo "https://github.com/NasPilot/shellcrash/raw/main/config.yaml"; sleep 4; \
        echo "1"; sleep 4; \
        echo "0") | /etc/ShellCrash/menu.sh \
    && mkdir -p /etc/ShellCrash/ruleset \
    && wget -q --no-check-certificate -O /tmp/mrs.tar.gz https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/mrs.tar.gz \
    && tar -zxf /tmp/mrs.tar.gz -C /etc/ShellCrash/ruleset/ \
    && wget -q --no-check-certificate -O /etc/ShellCrash/Country.mmdb https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/cn_mini.mmdb \
    && wget -q --no-check-certificate -O /etc/ShellCrash/GeoSite.dat https://testingcf.jsdelivr.net/gh/juewuy/ShellCrash@update/bin/geodata/geosite.dat \
    && mv /etc/ShellCrash /etc/ShellCrash_bak && mkdir /etc/ShellCrash \
    && rm -rf /tmp/* /var/cache/apk/*

# 端口和目录映射
EXPOSE 7890 9999
VOLUME /etc/ShellCrash

# 启动命令
ENTRYPOINT ["sh","shellcrash.sh"]
