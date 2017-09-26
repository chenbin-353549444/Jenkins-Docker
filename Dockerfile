FROM jenkins:alpine
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
# 下载安装Docker CLI
USER root
ENV NODE_VERSION 8.5.0
RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
    && curl -O "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz \
    && mkdir /usr/mynode \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/mynode --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && ln -s /usr/mynode/bin/node /usr/local/bin/node
# 将 `jenkins` 用户的组 ID 改为宿主 `docker` 组的组ID，从而具有执行 `docker` 命令的权限。
ARG DOCKER_GID=993
USER jenkins:${DOCKER_GID}
