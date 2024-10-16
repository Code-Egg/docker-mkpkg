FROM ubuntu:24.04

RUN apt-get update && apt-get install wget curl vim -y
RUN apt-get install python3 python3-pip -y
RUN pip3 install mkdocs --break-system-packages
RUN mkdocs -V