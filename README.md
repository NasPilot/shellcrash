<h1 align="center">
  <br>ShellCrash<br>
</h1>

<p align="center">
  <a target="_blank" href="https://github.com/juewuy/shellcrash/releases">
    <img src="https://img.shields.io/github/release/juewuy/shellcrash.svg?style=flat-square&label=ShellCrash&colorB=green">
  </a>
  <a target="_blank" href="https://github.com/naspilot/shellcrash/actions/workflows/Build%20Image.yml">
    <img src="https://github.com/naspilot/shellcrash/actions/workflows/Build%20Image.yml/badge.svg">
  </a>
  <a target="_blank" href="https://github.com/naspilot/shellcrash">
    <img src="https://img.shields.io/github/last-commit/naspilot/shellcrash">
  </a>
  <a target="_blank" href="https://github.com/naspilot/shellcrash">
    <img src="https://img.shields.io/github/commit-activity/m/naspilot/shellcrash">
  </a>
  <a target="_blank" href="https://hub.docker.com/r/naspilot/shellcrash/tags?page=1&ordering=last_updated">
    <img src="https://img.shields.io/docker/v/naspilot/shellcrash?style=flat">
  </a>
  <a target="_blank" href="https://hub.docker.com/r/naspilot/shellcrash">
    <img src="https://img.shields.io/docker/pulls/naspilot/shellcrash.svg?style=flat">
  </a>
  <a target="_blank" href="https://hub.docker.com/r/naspilot/shellcrash">
    <img src="https://img.shields.io/docker/stars/naspilot/shellcrash?style=flat">
  </a>
  <a target="_blank" href="https://hub.docker.com/r/naspilot/shellcrash">
    <img src="https://img.shields.io/docker/image-size/naspilot/shellcrash?style=flat">
  </a>
  <a target="_blank" href="https://hub.docker.com/r/naspilot/shellcrash">
    <img src="https://img.shields.io/github/repo-size/naspilot/shellcrash">
  </a>
</p>

# shellcrash
shellcrash docker

**Docker run：**<br>

```shell
docker run -dit \
--name shellcrash \
--hostname shellcrash \
--network bridge \
--restart always \
--cap-add NET_ADMIN \
--cap-add NET_RAW \
--cap-add SYS_ADMIN \
-p 7890:7890 \
-p 9999:9999 \
-v /volume1/docker/shellcrash:/etc/ShellCrash \
naspilot/shellcrash:latest
```
## 注意事项
1. 挂载路径 /volume1/docker/shellcrash 是针对NAS系统（Synology）的路径格式。如果您在其他系统上运行，需要修改为适合您系统的路径。
2. 确保您的系统上已经创建了挂载目录，否则Docker会自动创建一个空目录。
3. 该命令使用了 --cap-add NET_ADMIN ，这赋予了容器网络管理能力，允许容器修改网络设置。