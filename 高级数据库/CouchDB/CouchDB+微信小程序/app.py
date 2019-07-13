from flask import Flask, request
from cloudant.client import CouchDB
from flask_apscheduler import APScheduler
import json, re

# 连接数据库
client = CouchDB("admin", "ubuntu", url="http://127.0.0.1:5984", connect=True, auto_renew=True)
db = client["expert"]

# 电影 top20
movies, top = {}, {}

# 类型
genres = ["fantasy", "comedy", "drama", "thriller", "imax",
        "adventure", "animation", "western", "war", "musical",
        "mystery", "sci-fi", "crime", "horror", "film-noir",
        "romance", "documentary", "action", "children", "others"]

# 定时任务
class Config(object):
    JOBS = [
            {
                'id': 'my_update',
                'func': 'app:my_update',
                'trigger': 'interval',
                'seconds': 30
            }
           ]
    SCHEDULER_API_ENABLED = True

# 更新
def my_update():
    print("update movies and top20")
    global movies, top
    movies = db.get_view_result('_design/task12', 'movies')
    for genre in genres:
        if genre in top.keys():
            selected = db.get_view_result('_design/task3', genre)
            if len(selected.all()) != top[genre]["total"]:
                for doc in selected:
                    tmp = db.get_view_result('_design/task3', 'ratings', key=doc['key'], reduce=False)
                    resp.append({"name":doc['value']['title'], "value":len(tmp.all())})
                resp.sort(key=lambda k:k.get('value'), reverse=True)
                top[genre] = {"total":len(resp), "top20":resp[:20]}
                print("update", genre)
    print("update finished")

# 初始化并生成app
def create_app():
    my_update()
    return Flask(__name__)

# 读取配置
app = create_app()
app.config.from_object(Config())

# 启动定时任务
scheduler = APScheduler()
scheduler.init_app(app)
scheduler.start()

# 默认路由
@app.route('/')
def index():
    return 'Hello World!'

# task1
@app.route('/search1')
def search1():
    key = request.args.get('id')
    result = db.get_view_result('_design/task12', 'users', startkey=[key], endkey=[key,{}])
    resp = []
    for res in result:
        values = res['value']
        movie = movies[values['movieId']][0]['value']
        resp.append({'userId':values['userId'], 'movieId':values['movieId'], 'title':movie['title'], 'genres':movie['genres'], 'rating':values['rating'], 'genres':movie['genres']}) 
    return json.dumps(resp)

# task2
@app.route('/search2')
def search2():
    key = request.args.get('key')
    #if '(' in key or ')' in key:
    #    regex = '(?i)\\'+key[:-1]+'\\)'
    #elif re.fullmatch("^[0-9]+$", key):
    #    regex = key
    #else:
    #    regex = '(?i)(^'+key+' )|( '+key+'$)|( '+key+' )'
    #selector = {'title':{'$regex': regex}}
    #resp = db.get_query_result(selector, raw_result=True)
    #return json.dumps(resp['docs'])
    key = key.lower()
    resp = []
    if '(' in key or ')' in key:
        pattern = re.compile(r'\('+key+'\)')
    elif re.fullmatch("^[0-9]+$", key):
        pattern = re.compile(r+key)
    else:
        pattern = re.compile(r'(^'+key+' )|( '+key+'$)|( '+key+' )')
    for m in movies:
        if pattern.search(m['value']['title'].lower()):
            resp.append({"title":m['value']['title'], "genres":m['value']['genres']})
    return json.dumps(resp)

# task3
@app.route('/search3')
def search3():
    key = request.args.get('key').lower()
    if key in genres:
        if key in top.keys():
            return json.dumps(top[key]["top20"])
        selected = db.get_view_result('_design/task3', key)
        resp = []
        for doc in selected:
            tmp = db.get_view_result('_design/task3', 'ratings', key=doc['key'], reduce=False)
            resp.append({"name":doc['value']['title'], "value":len(tmp.all())})
            #if tmp[0]:
            #    resp.append({"name":doc['value']['title'], "value":tmp[0][0]['value']})
            #else:
            #    resp.append({"name":doc['value']['title'], "value":0})
        resp.sort(key=lambda k:k.get('value'), reverse=True)
        top[key] = { "total":len(resp), "top20":resp[:20] }
        return json.dumps(top[key]["top20"])
    else:
        return json.dumps([])


if __name__ == '__main__':
    app.run()
