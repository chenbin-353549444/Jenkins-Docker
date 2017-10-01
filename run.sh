#!/bin/bash

#删除以前的jenkins目录（慎重）
# rm -rf /var/jenkins_home

#新建新的目录
# mkdir /var/jenkins_home

#给新建的目录添加权限
# chmod 777 /var/jenkins_home

#运行jenkins容器，将宿主的 /var/run/docker.sock 文件挂载到容器内的同样位置，从而让容器内可以通过 unix socket 调用宿主的 Docker 引擎。
#将jenkins目录挂载到宿主机同样位置，以便查看初始密码和workspace
docker run --name jenkins \
    -d \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/jenkins_home:/var/jenkins_home \
    -e TZ=Asia/Shanghai \
    superbin/jenkins-docker
