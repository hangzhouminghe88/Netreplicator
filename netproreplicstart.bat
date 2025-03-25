@echo off

SET WORK_DIR=C:\NETPRO5.02.8\plugins\NetReplicator\bin
SET WORK_CONF=C:\NETPRO5.02.8\plugins\NetReplicator\conf
SET CYG_WORK_CONF=/cygdrive/C/NETPRO5.02.8/plugins/NetReplicator/conf

cd %WORK_DIR%

:: 关闭已有的 netreplicator 进程
taskkill /F /IM netreplicator.exe >nul 2>&1

:: 删除旧的 PID 和日志文件
if exist "%WORK_DIR%\netreplicator.pid" del "%WORK_DIR%\netreplicator.pid"
if exist "%WORK_DIR%\netreplicator.log" del "%WORK_DIR%\netreplicator.log"

:: 断开已有的 Z: 盘符（如果存在）
net use Z: /delete /y >nul 2>&1

:: 等待 5 秒，确保 Z: 断开
timeout /t 5 /nobreak >nul

:: 设置网络盘符 Z:，使用 Administrator 账户
net use Z: \\10.10.10.200\data /USER:test  test /persistent:no

:: 等待 10 秒，确保映射成功
timeout /t 10 /nobreak >nul

:: 检查 Z: 是否成功挂载
if not exist Z:\ (
    echo [ERROR] 无法挂载 Z: 盘符，请检查网络路径或凭据！
    timeout /t 5 /nobreak
    exit /b 1
)

:: 启动 NetReplicator 服务
"%WORK_DIR%\netreplicator" --daemon --config="%CYG_WORK_CONF%/netreplicator.conf"
