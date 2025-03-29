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
    && source /etc/profile &> /dev/null
    
    echo "1"; sleep 2; \  1 路由设备配置局域网透明代理
    echo "1"; sleep 3; \  启用推荐的自动任务配置 是否启用？(1/0) 
    echo "2"; sleep 2; \  是否导入配置文件 
    echo "1"; sleep 1; \ 1 在线生成配置文件
    echo "https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml"; sleep 2; \ 请直接输入第1个链接或对应数字选项
    echo "1"; sleep 5; \ 1 开始生成配置文件（原文件将被备份）
    echo "1"; sleep 120; \ 立即启动服务？(1/0)
    echo "0"; echo "2"; sleep 2; \
    echo "1"; sleep 2; \
    echo "1"; sleep 2; echo "7"; sleep 2; \
    echo "4"; sleep 2; \
    echo "0"; sleep 2; \
    echo "0"; sleep 2; \
    echo "1"; sleep 2; \
RUN (echo "1"; sleep 2; \ 
    echo "1"; sleep 3; \
    echo "2"; sleep 2; \
    echo "1"; sleep 2; \
    echo "https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml"; sleep 2; \
    echo "1"; sleep 5; \
    echo "1") | /etc/ShellCrash/menu.sh

# 映射端口
EXPOSE 7890
EXPOSE 9999

## 设置挂载点
#VOLUME ["/etc/ShellCrash"]

# 设置环境变量
ENV ENV="/etc/profile"

#启动命令
#ENTRYPOINT ["sh","shellcrash.sh"]
ENTRYPOINT ["sh","/etc/ShellCrash/start.sh start 2"]
