#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''地区特色日历App — 一键启动前后端'''

import subprocess, time, socket, os

BASE = os.path.dirname(os.path.abspath(__file__))
BE = os.path.join(BASE, 'backend')
FE = os.path.join(BASE, 'frontend')

BE_PORT = 8080
FE_PORT = 55872

SWAGGER = f'http://localhost:{BE_PORT}/api/swagger-ui.html'
FLUTTER_URL = f'http://localhost:{FE_PORT}'

def check_port(host, port):
	try:
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.settimeout(2)
		s.connect((host, port))
		s.close()
		return True
	except:
		return False

def find_pid_by_port(port):
	'''查找占用指定端口的进程 PID'''
	try:
		out = subprocess.check_output(
			f'netstat -ano | findstr ":{port}" | findstr "LISTENING"',
			shell=True, text=True
		)
		for line in out.strip().split('\n'):
			parts = line.split()
			if len(parts) >= 5:
				return parts[-1]
	except:
		pass
	return None

def kill_port(port):
	'''释放指定端口'''
	pid = find_pid_by_port(port)
	if pid:
		try:
			subprocess.run(f'cmd /c "taskkill /F /PID {pid}"', shell=True,
				capture_output=True, check=False)
			print(f'  [清理] 已释放端口 {port} (原 PID: {pid})')
			time.sleep(1)
		except:
			pass

def start_in_window(title, cwd, cmd):
	subprocess.Popen(
		f'start "{title}" cmd /k "cd /d {cwd} && {cmd}"',
		shell=True
	)
	print(f'  [启动] {title} - 新窗口已打开')

def main():
	print('=' * 50)
	print('  地区特色日历App — 一键启动')
	print('=' * 50)
	print()

	print('[1/4] 检测依赖服务...')
	for name, host, port in [('MySQL', 'localhost', 3306), ('Redis', 'localhost', 6379)]:
		if check_port(host, port):
			print(f'  [OK] {name} ({host}:{port}) 已就绪')
		else:
			print(f'  [!!] {name} ({host}:{port}) 未就绪，请先启动！')
	print()

	print('[2/4] 清理旧进程...')
	kill_port(BE_PORT)
	kill_port(FE_PORT)
	print()

	print('[3/4] 编译并启动后端 (Spring Boot)...')
	start_in_window('Backend-API', BE, 'mvn clean compile spring-boot:run')
	print('  等待后端初始化 (约25秒)...')
	time.sleep(25)
	print()

	print('[4/4] 启动前端 (Flutter Web)...')
	start_in_window('Frontend-Flutter', FE,
		f'flutter run -d chrome --web-port={FE_PORT}')
	print()

	print('=' * 50)
	print('  启动完成！')
	print()
	print(f'  后端 Swagger: {SWAGGER}')
	print(f'  前端页面:     {FLUTTER_URL}')
	print()
	print('  后端和前端各自在独立窗口运行')
	print('  关闭对应窗口即可停止服务')
	print('=' * 50)

if __name__ == '__main__':
	try:
		main()
	except KeyboardInterrupt:
		print('\n已取消')
	input('\n按 Enter 退出...')
