FROM ubuntu:24.04

RUN apt-get update && apt-get install wget curl vim openssh-client -y
RUN apt-get install python3 python3-pip -y
RUN pip3 install mkdocs --break-system-packages
RUN mkdocs -V
RUN pip3 install pymdown-extensions mkdocs-material --break-system-packages