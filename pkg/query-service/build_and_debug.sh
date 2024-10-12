#!/bin/bash
set -e
# Step 1: 构建二进制文件（本地）
echo "Binary built locally."
CGO_ENABLED=1 GOARCH=amd64  GOOS=linux go build -o ./build/query-service ./main.go
echo "Built binary finished"

# Step 2: 等待同步完成
while true; do
  STATUS=$(okteto status | grep "Synchronization status")

  if echo $STATUS | grep -q "100.00%"; then
    echo "Synchronization completed."
    break
  else
    echo "Waiting for synchronization..."
    sleep 2
  fi
done

# Step 3: 在 Okteto 容器中启动 dlv 调试器
okteto exec my-release-signoz-query-service -- bash -c "dlv --listen=:10086 --headless=true --accept-multiclient --api-version=2 exec /root/build/query-service -- --config=/root/config/prometheus.yml --experimental.cache-config /root/config/cache.yaml --flux-interval 30m --use-logs-new-schema=true"
