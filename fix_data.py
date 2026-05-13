#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''修复节日和放假安排 region_id 数据'''

import pymysql, sys

DB = {
	'host': 'localhost', 'port': 3306,
	'user': 'root', 'password': '926400',
	'database': 'regional_calendar', 'charset': 'utf8mb4'
}

def main():
	conn = pymysql.connect(**DB)
	cur = conn.cursor()

	# ===== 1. 查询映射 =====
	cur.execute("SELECT id, name, main_region_ids FROM ethnicity WHERE main_region_ids IS NOT NULL")
	eth_regions = {}
	for eth_id, name, ids_str in cur.fetchall():
		codes = [c.strip().ljust(6, '0') for c in ids_str.split(',')]
		eth_regions[eth_id] = (name, codes)

	cur.execute("SELECT id, code, name FROM region WHERE level=1 AND status=1")
	code_to_id = {}
	id_to_name = {}
	for rid, code, name in cur.fetchall():
		code_to_id[code] = rid
		id_to_name[rid] = name

	# ===== 2. 修复 festival.region_id =====
	print('=== 修复节日 region_id ===')
	updated = 0
	for eth_id, (eth_name, codes) in eth_regions.items():
		region_id = None
		for code in codes:
			if code in code_to_id:
				region_id = code_to_id[code]
				break
		if region_id is None:
			print(f'[警告] {eth_name} 的地区码 {codes} 未匹配')
			continue
		cur.execute(
			"UPDATE festival SET region_id=%s WHERE ethnicity_id=%s AND region_id IS NULL",
			(region_id, eth_id)
		)
		n = cur.rowcount
		if n > 0:
			print(f'[节日] {eth_name} -> {id_to_name.get(region_id, "?")} ({n}条)')
			updated += n

	# ===== 3. 修复 holiday_schedule =====
	print('\n=== 修复放假安排 region_id ===')

	# 删除重复的 regionId=0 记录
	cur.execute("DELETE FROM holiday_schedule WHERE region_id=0")
	print(f'删除重复记录 (regionId=0): {cur.rowcount} 条')

	# 按节日名称映射到正确地区
	# 三月三->广西, 泼水节->云南, 苗年->贵州, 雪顿节->西藏, 开斋节/古尔邦节->新疆, 那达慕->内蒙古
	schedule_fixes = {
		'三月三': '450000',   # 广西
		'泼水节': '530000',   # 云南
		'苗年':   '520000',   # 贵州
		'雪顿节': '540000',   # 西藏
		'开斋节': '650000',   # 新疆
		'古尔邦节': '650000', # 新疆
		'那达慕': '150000',   # 内蒙古
	}

	for festival_name, region_code in schedule_fixes.items():
		if region_code in code_to_id:
			correct_id = code_to_id[region_code]
			region_name = id_to_name.get(correct_id, '?')
			cur.execute(
				"UPDATE holiday_schedule SET region_id=%s, region_name=%s "
				"WHERE festival_name=%s AND region_id IS NOT NULL AND region_id != %s",
				(correct_id, region_name, festival_name, correct_id)
			)
			n = cur.rowcount
			if n > 0:
				print(f'[放假] {festival_name} -> {region_name} ({n}条)')

	conn.commit()

	# ===== 4. 验证 =====
	print('\n=== 验证结果 ===')
	cur.execute("SELECT COUNT(*) FROM festival WHERE region_id IS NOT NULL")
	print(f'有地区的节日: {cur.fetchone()[0]} 条')
	cur.execute("SELECT COUNT(*) FROM festival WHERE region_id IS NULL AND ethnicity_id IS NOT NULL")
	still_bad = cur.fetchone()[0]
	print(f'仍有问题的节日: {still_bad} 条')

	cur.execute("SELECT id, festival_name, region_id, start_date, end_date FROM holiday_schedule ORDER BY id")
	for row in cur.fetchall():
		print(f'放假: id={row[0]} name={row[1]} regionId={row[2]} {row[3]}~{row[4]}')

	cur.close()
	conn.close()
	print('\n数据修复完成！')

if __name__ == '__main__':
	try:
		main()
	except Exception as e:
		print(f'错误: {e}')
		import traceback
		traceback.print_exc()
		sys.exit(1)
