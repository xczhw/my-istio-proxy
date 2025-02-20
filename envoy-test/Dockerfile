FROM ubuntu:20.04

# 复制你编译好的 Envoy 可执行文件
RUN rm -rf /usr/local/bin/envoy
COPY envoy /usr/local/bin/envoy

# 复制 Envoy 的配置文件
RUN rm -rf /etc/envoy/bootstrap.yaml
COPY bootstrap.yaml /etc/envoy/bootstrap.yaml

