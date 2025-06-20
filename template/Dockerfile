FROM ubuntu:24.04

RUN apt-get update && apt-get install wget curl vim openssh-client git rsync -y
RUN apt-get install python3 python3-pip -y
RUN pip3 install mkdocs --break-system-packages
RUN mkdocs -V
RUN pip3 install pymdown-extensions mkdocs-material markdown_blockdiag markdown_include lightgallery meta --break-system-packages
RUN pip3 install mkdocs-git-revision-date-localized-plugin mkdocs-minify-plugin --break-system-packages
RUN pip3 install mkdocs-exclude-search