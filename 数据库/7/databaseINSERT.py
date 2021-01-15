# -*- coding: utf-8 -*-
import pymssql
import time

# 连接数据库
conn = pymssql.connect(server='LAPTOP-EEVLKGR0\SQL',
                       user='MicrosoftAccount\linking1997@live.com',
                       password='91088300.l',
                       database='test')

# 打开游标
cursor = conn.cursor()
if not cursor:
    raise Exception('数据库连接失败！')

# 准备插入的数据
filename = 'data.txt'
with open(filename, encoding='utf-8', errors='ignore') as f:
    full_text = f.read()
    items = full_text.split('\n')

# 构造列表元组
for item in items:
    temp = item.replace('\ufeff', '')
    temp = temp.split('\t')
    if '404' in temp or 'NULL' in temp[:5] or len(temp)<6:
        pass
    else:
        temp[2] = time.strftime("%Y-%m-%d", time.localtime(int(temp[2])))
        # if temp[-1] != 'NULL':
        #     temp[-1] = time.strftime("%Y-%m-%d", time.strptime(temp[-1][:11], '%Y年%m月%d日'))
        data = tuple(temp)
        cursor.execute("INSERT INTO News(UserID, NewsID, ReadTime, Title, Content, PostTime) "
                           "VALUES (%s, %s, %s, %s, %s, %s)", data)

conn.commit()

# 查询数据
# cursor.execute('SELECT * FROM News')
# result = cursor.fetchall()
# if result:
#     for row in result:
#         print(row)


# 关闭连接
conn.close()