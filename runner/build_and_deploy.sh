#!/bin/bash

set -e  # 发生错误时终止脚本执行

# 进入 istio-proxy-builder 容器并构建 envoy
echo "Building envoy inside istio-proxy-builder container..."
docker exec -it istio-proxy-builder bash -c "make build BAZEL_STARTUP_ARGS='' BAZEL_BUILD_ARGS='-s --override_repository=envoy=/work/envoy' BAZEL_TARGETS=':envoy'"

# 复制构建完成的 envoy 二进制文件到 /mydata/istio-testing
echo "Copying built envoy binary to /mydata/istio-testing..."
mkdir -p /mydata/istio/istio/out/
docker cp istio-proxy-builder:/work/bazel-bin/envoy /mydata/istio/istio/out/envoy

# 进入 Istio 目录并构建 Istio Docker 镜像
echo "Building Istio Docker image..."
cd /mydata/istio/istio
rm -f /mydata/istio/istio/out/istio_is_init
make docker.push TAGS=1.24-dev
mv /mydata/istio/istio/out/linux_amd64/istioctl /usr/local/bin/istioctl

# 安装 Istio
# echo "Installing Istio..."
istioctl install -f /mydata/istio-testing/work/runner/istio-operator.yaml -y
kubectl apply -f /mydata/istio-testing/work/runner/addons

# 重新部署 whoami 服务
echo "Redeploying whoami service..."
kubectl delete -f /mydata/whoami || true  # 忽略不存在的错误
kubectl apply -f /mydata/whoami

echo "Deployment completed successfully!"
