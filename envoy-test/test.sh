#!/bin/bash

set -e  # 发生错误时终止脚本执行

# 进入 istio-proxy-builder 容器并构建 envoy
echo "Building envoy inside istio-proxy-builder container..."
docker exec -it istio-proxy-builder bash -c "make build BAZEL_STARTUP_ARGS='' BAZEL_BUILD_ARGS='-s --override_repository=envoy=/work/envoy' BAZEL_TARGETS=':envoy'"

# 复制构建完成的 envoy 二进制文件到 /mydata/istio-testing
echo "Copying built envoy binary to /mydata/istio-testing..."
docker cp istio-proxy-builder:/work/bazel-bin/envoy /mydata/istio-testing/envoy-test/envoy

docker build -t my-custom-envoy .
docker run --rm -it my-custom-envoy

# docker exec -it my-custom-envoy bash -c "envoy -c /etc/envoy/bootstrap.yaml"