FROM jenkins:alpine
# 下载安装Docker CLI
USER root
ENV NODE_VERSION 8.5.0
RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
    && curl -O "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs
# 将 `jenkins` 用户的组 ID 改为宿主 `docker` 组的组ID，从而具有执行 `docker` 命令的权限。
ARG DOCKER_GID=993
USER jenkins:${DOCKER_GID}
