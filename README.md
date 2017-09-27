# **Jenkins-Docker**

Jenkins-Docker是一个使用Dockerfile创建可执行docker命令的Jenkins镜像的项目。之前有使用Jenkins持续集成的经历，最近开始接触Docker，那么就没有理由继续之前痛苦的Jenkins安装过程。但是使用官方镜像无法在Docker容器内使用Docker命令，所以就有了这个项目。

[![Docker Build Statu](https://img.shields.io/docker/build/jrottenberg/ffmpeg.svg)]()
[![Travis](https://img.shields.io/badge/docker-17.06.1--ce-blue.svg)]()

##详细说明
####Dockerfile
```dockerfile
FROM jenkins:alpine
# 下载安装Docker CLI
USER root
RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
    && tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz
# 将 `jenkins` 用户的组 ID 改为宿主 `docker` 组的组ID，从而具有执行 `docker` 命令的权限。
ARG DOCKER_GID=999
USER jenkins:${DOCKER_GID}
```
在这里，我们下载了静态编译的docker可执行文件，并提取命令行安装到系统目录下。然后调整了jenkins用户的组ID，调整为宿主docker组ID，从而使其具有执行docker命令的权限。
####生成镜像
```console
$ docker build -t jenkins-docker .
```
组ID使用了DOCKER_GID参数来定义，以方便进一步定制。构建时可以通过--build-arg来改变DOCKER_GID的默认值，运行时也可以通过--user jenkins:1234来改变运行用户的身份。
```console
$ docker build -t jenkins-docker --build-arg DOCKER_GID=1234 .
```
这里由于国内云主机curl步骤时间太长，所以把项目关联到DockerHub上生成镜像，点击[`这里`](https://hub.docker.com/r/superbin/jenkins-docker/)到达DockerHub项目。
```console
$ docker pull superbin/jenkins-docker
```
####运行
```console
$ docker run --name jenkins \
      -d \
      -p 8080:8080 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /var/jenkins_home:/var/jenkins_home \
      superbin/jenkins-docker
```
运行jenkins容器，将宿主的/var/run/docker.sock文件挂载到容器内的同样位置，从而让容器内可以通过unix socket调用宿主的Docker引擎；将jenkins目录挂载到宿主机同样位置，以便查看初始密码和workspace
在这里，如果是第一次运行本项目，需要查看宿主机中的/var/jenkins_home目录，如果没有该目录要新建一个，并加上权限
```console
$ mkdir /var/jenkins_home
$ chmod 777 /var/jenkins_home
```
如果要删除jenkins数据重新安装，需要删除宿主机的/var/jenkins_home目录
```console
$ rm -rf /var/jenkins_home
```
现在jenkins容器已经运行，并且可以执行docker命令了