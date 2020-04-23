* [x] 基于ubuntu16.04
* [x] 设置每个cookie抽奖三次
* [x] 完成抽奖功能（half done）
* [ ] 防御攻击
* [ ] 使用docker容器

---

# 构建后台脚本
## 添加视图文件
* /resources/views
    * test.blade.php

## 添加路由
* /routes
    * web.php

## 构建控制器
* `php artisan make Controller TestController`

## 奖品表单
* `php artisan make:migration create_tests_table`
* 增加字段
    * `$table->string('name');$table->integer('number');`
* `php artisan migrate`

## 获奖表单
* `php artisan make:migration create_lucktests_table`
* 增加字段
    * `$table->string('name');$table->string('reward');`
* `php artisan migrate`

## Model
* `php artisan make:model Test`
* `php artisan make:model Lucktest`

## 关于Cookie
[Laravel框架中Cookie的添加、获取和清除方法](http://laramist.com/articles/20)
#### 读取
* `$value = Cookie::get('name');`
* `$request->cookie('name')`

#### 删除
* `Cookie::forget('name');`
* `Cookie::queue('name', null , -1);`

#### 写入
* `Cookie::queue('name', 'testValue', 10);`
* `$cookie = Cookie::make('name', 'value', $minutes) return view('blade')->withCookie($cookie)`

#### 输出
* `dd()`或`dump()`或`print()`，个人倾向print

# 防攻击
* 构建中间件
    * `php artisan make:middleware Check`

# 配置docker容器
1. 安装git
    * `sudo apt-get install git`
2. 安装docker-ce
    * (Ubuntu官方文档)[https://docs.docker.com/install/linux/docker-ce/ubuntu/#supported-storage-drivers]
3. 安装docker-compose
    * (github页面)[https://github.com/docker/compose/releases]


我先试用了一下laradock
## laradock
1. 克隆laradock
    * `git clone https://github.com/Laradock/laradock.git`
2. 创建环境变量文件
    * 进入laradock文件夹`cd laradock`
    * `cp env-example .env`
3. 直接用docker-compose运行服务
    * 我这里是提升了权限，因为之前报错过`sudo su`
    * `docker-compose up -d nginx mysql redis beanstalkd`
    * 等啊等啊等
4. 以laradock用户的身份进入workspace容器
    * `docker-compose exec —user=laradock workspace bash`
5. 安装Laravel
    * `composer create-project laravel/laravel blog`
6. 修改....

**重新来一下，还不会用 nginx...**
3. 提升权限，安装mysql和apache2
    * `sudo su`
    * `docker-compose up -d mysql apache2`
4. 以laradock用户的身份进入workspace容器
    * `docker-compose exec —user=laradock workspace bash`
5. 待续...

## dockerfile
1. 拉取ubuntu镜像
    * `docker pull ubuntu:16.04`
2. 运行镜像
    * `docker run -it --rm ubuntu:16.04 bash`
    * 获得镜像信息
        * `cat /etc/os-release`
3. 定制dockerfile
4. 生成镜像
5. 生成容器
6. 运行容器
7. 待续...

## 总结
* laradock是用docker来配置本地laravel环境，偏题了ORZ
* cookie的增删改捣腾了蛮久
* 攻击的具体形式还没搞清楚，没搞懂都会有什么攻击
* 抽奖功能通用性小
* 对docker一知半解...
* 完善了一下抽奖功能，一个ip只能获奖一次
    * 其实我是想一个用户一个，但还没想好根据什么来拟定用户
* docker待续
* 实验截图![](https://github.com/jckling/LearnWebsite/blob/master/SQ/18/draw/pic.png)
    * 9是剩余抽奖次数
    * rewards是奖品
    * list是获奖列表，ip和获得的奖品
    * start gambling是开始抽奖