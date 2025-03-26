#!/bin/bash

echo "[INFO] 正在查找并终止 netreplicator 进程..."

# 获取所有相关进程 PID
pids=$(ps -ef | grep '[n]etreplicator' | awk '{print $2}')

if [ -z "$pids" ]; then
    echo "[INFO] 未发现运行中的 netreplicator 进程。"
else
    echo "[INFO] 发现以下 PID：$pids"
    echo "[INFO] 开始终止..."

    for pid in $pids; do
        kill -9 $pid && echo "已终止 PID: $pid"
    done

    echo "[INFO] 所有 netreplicator 进程已终止。"
fi
