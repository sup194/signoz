#!/bin/bash

set -e

# 检查是否传递了 context 参数
if [ -n "$1" ]; then
  CONTEXT=$1
else
  # 使用 kubectx -c 获取当前上下文
  CONTEXT=$(kubectx -c)

  # 检查是否成功获取 context
  if [ -z "$CONTEXT" ]; then
    echo "Error: Could not retrieve the current context."
    echo "Please ensure you have a valid context selected."
    exit 1
  fi
fi

# 执行 okteto up 命令
echo "Using context: $CONTEXT"
okteto context use "$CONTEXT"
okteto -c "$CONTEXT" -l debug up
