### InstaCUC

```python
# 初始化数据库
flask db init
flask db migrate
flask db upgrade

# 创建账号
flask user create-admin jckling@163.com jckling password

# 运行网站
flask run
```

应有功能如下：
- [x] 页面重定向
- [x] 文件类型校验
- [ ] Profile 页面
- [ ] 分页
- [ ] 删除/修改消息

### 隐蔽通信

```python
# 发送图片+文字
python sender.py

# 下载图片
python receiver.py

# 提取水印
python image.py
```

### 总结

1. 主要是对 `learn_flask_the_hard_way/app/resources/post.py` 文件进行改动；
2. 分页尝试使用 JavaScript 直接对 DOM 对象进行操作，未果，遂改用 flask-paginae 进行分页，尝试后发现需要“大改”，沉思一秒将代码 rollback；
3. 暂未感受到本项目中 RESTful API 的优势，故不作改动。
