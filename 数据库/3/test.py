import pymssql

# 连接数据库
conn = pymssql.connect(server='LAPTOP-EEVLKGR0\SQL',
                       user='MicrosoftAccount\linking1997@live.com',
                       password='91088300.l',
                       database='test',
                       charset='GBK')

# 打开游标
cursor = conn.cursor()
if not cursor:
    raise Exception('数据库连接失败！')

# # 获取News表中的数据
# cursor.execute('SELECT * FROM News')
# result = cursor.fetchall()
# #1.result是list，而其中的每个元素是 tuple
# print(type(result),type(result[0]))
# #2.行数
# print('\n\n总行数：'+ str(cursor.rowcount))
# #3.通过enumerate返回行号
# for i,(id,name,v) in enumerate(result):
#     print('第 '+str(i+1)+' 行记录->>> '+ str(id) +':'+ name+ ':' + str(v) )


# 准备插入的数据
filename = 'train_data.txt'
with open(filename, encoding='utf-8') as f:
    full_text = f.read()
    items = full_text.split('\n')
# 构造列表元组
for item in items:
    temp = item.replace('\ufeff', '')
    temp = temp.split('\t', 6)
    data = tuple(temp)
    cursor.execute("INSERT INTO News VALUES (%s, %s, %s, %s, %s, %s)",data)
conn.commit()

# 查询数据
cursor.execute('SELECT * FROM News')
result = cursor.fetchall()
if result:
    for row in result:
        print(row)


# 关闭连接
conn.close()