@echo off
echo ========================================
echo MySQL 密码重置脚本
echo ========================================
echo.

set MYSQL_BIN="C:\Program Files\MySQL\MySQL Server 8.4\bin"

echo [步骤1] 停止 MySQL 服务...
net stop MySQL84
if errorlevel 1 (
    echo 停止服务失败，请以管理员身份运行此脚本！
    pause
    exit /b 1
)
echo 服务已停止
echo.

echo [步骤2] 以跳过权限模式启动 MySQL（后台运行）...
start "MySQL Skip Grant" %MYSQL_BIN%\mysqld.exe --skip-grant-tables --shared-memory --console
echo 等待 MySQL 启动...
timeout /t 5 /nobreak >nul
echo.

echo [步骤3] 连接 MySQL 并重置密码...
echo 请输入以下 SQL 命令：
echo.
echo   FLUSH PRIVILEGES;
echo   ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';
echo   EXIT;
echo.
echo ----------------------------------------
echo 请在弹出的 MySQL 窗口中执行以上命令
echo 完成后关闭该窗口，然后按任意键继续
echo ----------------------------------------
pause

echo.
echo [步骤4] 重新启动 MySQL 服务...
taskkill /f /im mysqld.exe >nul 2>&1
timeout /t 2 /nobreak >nul
net start MySQL84
if errorlevel 1 (
    echo 启动服务失败，请手动启动 MySQL84 服务
    pause
    exit /b 1
)
echo.
echo ========================================
echo 密码重置完成！现在可以用新密码登录了
echo ========================================
echo 测试登录: mysql -u root -p
echo.
pause
