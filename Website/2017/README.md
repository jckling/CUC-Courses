# 目录
* [Windows](#基于windows)
	* [数据库](#使用数据库)
	* [html](#html)
	* [php](#php)
	* [总结w1](#总结w1)
	* [总结w2](#总结w2)
* [Ubuntu](#基于ubuntu)
	* [安装Ubuntu](#安装ubuntu16-04-3)
	* [搭建LAMP环境](#搭建lamp环境)
	* [配置Laravel](#配置laravel)
	* [用户认证](#用户认证)
	* [总结u1](#总结u1)
	* [基础知识](#基础知识)
	* [构建留言板](#构建留言板)
	* [总结u2](#总结u2)
	* [构建登录注册](#构建登录注册)
	* [总结u3](#总结u3)
	* [总结u4](#总结u4)


## 基于Windows
#### 使用数据库
* 登录数据库
* 创建表
	* ID
	* 用户名
	* 密码
	* 邮箱
	* 状态
	* 
```
CREATE TABLE users(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,//ID
name VARCHAR(30) UNIQUE NOT NULL,//用户名
password VARCHAR(20) NOT NULL,//密码
email VARCHAR(200) UNIQUE NOT NULL,//邮箱，主键
active INT DEFAULT 0 NOT NULL//激活标志
);
```


#### html
* index.html (首页)
	* 登录/注册


#### php
* include.php (共用函数)
	* 连接数据库
* signin.php (登录)
	* 邮箱
	* 密码
	* 连接数据库
	* 验证存在与匹配
	* 更改登录状态【SESSION未完成】
* signup.php (注册)
	* 用户名
	* 邮箱(合法性)
	* 密码(格式,长度)
	* 确认密码
	* 连接数据库
	* 存入数据
	* 等待激活
* check.php (激活账号)
	* 发送激活邮件
	* 确认激活
	* 更改状态
	* 不允许二次激活
* stmp.php (发送邮件)
	* 邮件类
	* 发送过程
	* 发送函数
	* 参考

#### 过程
* 主要界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/index.png)

* 注册界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/signup.png)

* 注册后

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/after-signup.png)

* 收到邮件

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/email.jpg)

* 激活账号

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/active.jpg)

* 登录界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/signin.png)

* 登陆成功

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/after-signin.png)

* 若有错误会以字符串形式展现，如：

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Windows/error.png)

## 总结w1
* 用xmapp集成包搭建环境
* 完成表的构建
* 实现登录验证，未实现登录与否状态的改变
* 实现注册功能
* 实现基于socket、STMP的邮件发送
* 实现激活账号后不允许再次激活


## 总结w2
* 更改表的结构
* 功能基本实现
* SESSION未掌握


<br>
<br>

## 基于Ubuntu
#### 安装Ubuntu16.04.3
* 下载镜像包
* 用虚拟机安装

##### Ubuntu技巧
> ctrl+h 显示隐藏文件


#### 搭建LAMP环境
* 管理员身份
	* `sudo su`
* 更新
	* `sudo apt-get update`
* 安装apache
	* `sudo apt-get install apache2`
	* 浏览器访问127.0.0.1验证
* 安装MYSQL
	* `sudo apt-get install mysql-server mysql-client`
	* 设置MYSQL管理员密码
* 测试MYSQL
	* `sudo netstat -tap | grep mysql`
	* 显示监听端口即安装成功
* 安装PHP
	* `sudo apt-get install php7.0 libapache2-mod-php7.0`
* 测试PHP
	* 更改权限
		* `sudo chmod 775 -R /var/www`
	* 编辑测试php文件
		* `sudo vi /var/www/info.php`
		* `<?php phpinfo(); ?>`
		* 按i开始编辑，编辑完成后先按ESC再敲`:wq`保存退出
	* 配置根目录
		* `sudo vi /etc/apache2/sites-available/000-default.conf`
		* 将 `var/www/html`改为`var/www`
	* 浏览器访问127.0.0.1/info.php验证
* 安装phpmyadmin
	* `sudo apt-get install phpmyadmin`
	* 安装会出现三次窗口，前两个选择默认选项即可，最后一个输入MYSQL管理员密码
	* 在`/var/www`下建立phpmyadmin的软连接
		* `sudo ln -s /usr/share/phpmyadmin /var/www/phpmyadmin`
* 验证phpmyadmin
	* 浏览器访问127.0.0.1/phpmyadmin
	* 若出现mbstring错误
		* `sudo apt-get install php-mbstring`
		* 修改php配置文件
			* `sudo gedit /etc/php/7.0/apache2/php.ini`
			* display_errors = On(显示错误日志，出现两次，都要改，不然无效)
			* `extension=php_mbstring.dll`
			* 开启mbstring
		* 重启apache
			* `sudo /etc/init.d/apache2 restart`
		* 再次用浏览器访问127.0.0.1/phpmyadmin
			* 用户名root
			* 密码是安装时设置的


#### 配置Laravel
* 更新
	* `sudo apt-get update`
* 安装laravel需要的加密算法库
	* `sudo apt-get install mcrypt`
* 安装php扩展
	* `sudo apt-get install curl openssl php-curl php-zip php-dom php-pdo php-xml php-mysql php7.0-mcrypt` 
	* `/etc/php/7.0/apache2`中找到php.ini，开启扩展
* 安装composer
	* `curl -sS https://getcomposer.org/installer | php`
* 移动文件到命令目录
	* `sudo mv composer.phar /usr/local/bin/composer`
* composer命令
	* 不能在root下使用
	* `composer -v` 检测是否安装成功
	* `composer config -g repo.packagist composer https://packagist.phpcomposer.com`配置国内镜像
* 安装laravel
	* `composer global require "laravel/installer"`
	* `export PATH="~/.config/composer/vendor/bin:$PATH"`配置环境变量
* 使用laravel新建项目
	* `laravel new project` project是项目名称
* 设置目录权限
	* `sudo chmod 0777 project -R` 简单方式
* 开启重写模块
	* `sudo a2enmod rewrite` 
* 重启apache
	* `service apache2 restart`
* 生成key
	* `php artisan key:generate`
	* `'key' => env('APP_KEY', 'key')`project/config/app.php
* 测试
	* 进入project目录
	* `php artisan serve`
	* 浏览器访问localhost:8000


#### 用户认证
参考文档：

* [Laravel 5.1用户认证](http://laravelacademy.org/post/1258.html)
* [Laravel 5.4用户认证](http://laravelacademy.org/post/6803.html)


## 总结u1
* 配置好Laravel环境
* 搭建完LAMP环境再搭建Laravel更方便
* 尚未弄懂框架


## 基础知识
#### 配置
* .env
* database/mail
* /config/database.php
* /config/mail.php

##### Controller
* /app/Http/Controllers
	* xxxController.php
	* `php artisan make:controller XxxController`

##### View
* /resources/views
	* xxx.blade.php

##### Route
* /routes/web.php

##### css/js
* /public


## 构建留言板
* 获得权限
	* `export PATH="~/.config/composer/vendor/bin:$PATH"`
* 使用laravel新建项目
	* `laravel new test` test是项目名称
* 路由
	* /routes/web.php
	* 添加路由
	* `Route::get('/test','TestController@index);`
	* `Route::post('/test','TestController@store);`
* Controller
	* `php artisan make:controller TestController`
* 视图
	* /resources/views
	* 新建文件`test.blade.php`
* 表单
	* `php artisan make:migration create_notes_table`
	* /database/migrations
	* 增加字段
		* `$table->string('name')`
		* `$table->text('content')`
	* 创建表
		* `php artisan migrate`
* Module
	* `php artisan make:module Note`
	* /app/
	* 测试
		* `php artisan tinker`
			> [用法参考](http://laravelacademy.org/post/4935.html)
			> 
			> 数据表xxxxs，model:Xxxx单数大写		
	* 暂时不做改动 
* 完成页面如下
![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/guestbook/test.png)


## 总结u2
* laravel框架机制基本搞明白了，但是上手还很生疏
* 自带的用户认证还没完全搞明白
* 先尝试做了个留言板
* 正在构建用户认证
* 未使用中间控件
* 回看一下windows上的php，虽然功能大体实现但是太糅杂了，有空重写。打算先了解laravel框架。

## 构建登录注册
#### 数据表
* id  //自增
* name
* email  //唯一
* password
* active
* timestamps

#### 配置.env
* 将MAIL那部分内容进行修改
	* `MAIL_HOST=smtp.163.com`
	* `MAIL_PORT=25`
	* `MAIL_USERNAME=@163.com`
	* `MAIL_PASSWORD=`

#### 控制器Controller
* LoginController
	* 登录，做各种判断
		* 账号存在
		* 密码正确
		* 用户激活
* RegisterController
	* 注册，写入数据库
		* 昵称，邮箱，密码
		* 发送激活邮件
	* 验证邮件
		* 重复激活判断
* EmailController
	* 邮件内容设定
	* 发送激活邮件

#### 路由
```
Route::get('/home', function ($message = "") {
    return view('home',compact('message'));
});

Route::get('/login', function () {
    return view('login');
});
Route::post('/login','LoginController@log');

Route::get('/register', function () {
    return view('register');
});
Route::post('/register','RegisterController@create');

Route::get('/success', 'RegisterController@confirm');
```

#### 视图View
* home.blade.php
	* 主要视图
* login.blade.php
	* 登录视图
* register.blade.php
	* 注册视图
* success.blade.php
	* 激活成功视图

#### 模型Model
* Test.php
	* 参考自带的User.php

#### 请求
* CreateUserRequest.php
	* 规定注册输入标准
* LoginRequest.php
	* 规定登录输入标准

#### 过程
* 主要界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/home.png)

* 注册界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/register.png)

* 注册后

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/after-register.png)

* 收到邮件

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/mail.jpg)


* 登录界面

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/login.png)

* 登陆成功

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/logged.png)

* 若有错误会以列表的形式展现，如：

![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/error.png)


## 总结u3
* 硬生生拼凑出来，有些重用的没规划（@yield）
* 基本弄懂了流程，没有用到中间件
* 弄懂了基本控件
* 补上代码和截图


## 总结u4
* 补上代码和截图
* 数据表结构
* ![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Ubuntu/register&login/table.png)