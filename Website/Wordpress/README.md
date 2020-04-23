# 目录
* [Wordpress](#wordpress)
* [插件](#安装插件)
* [配置](#简单配置)
* [总结1](#总结1)
* [添加“关于我们”页面](#添加关于我们页面)
* [添加“售罄”提示](#添加售罄提示)
* [添加“立即购买”按钮](#添加立即购买按钮)
* [前后端相关](#前后端相关)
* [总结2](#总结2)

## Wordpress
* 已搭建过了XAMPP环境
* 下载wordpress，解压后放在xampp的htdocs目录下
* 著名的5分钟安装法
> 参考教程:https://codex.wordpress.org/zh-cn:WordPress_%E6%96%B0%E6%89%8B_-_%E5%A6%82%E4%BD%95%E5%BC%80%E5%A7%8B

## 安装插件
* 仪表盘-插件-安装插件
    * 安装电商插件——WooCommerce
* 仪表盘-外观-主题
    * 选择同时提供的主题Storefront
* 仪表盘-工具-导入
    * 导入测试文件
        * WooCommerce同时提供的测试文件在这个目录下`xampp\htdocs\wordpress\wp-content\plugins\woocommerce\dummy-data`
        * 安装WordPress导入器，安装完毕后导入目录下的xml文件
        * 然后就能查看自带商品页面了，随便点开一个看
![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/example.png) 

## 简单配置
* 页面文章管理
    * 不用的文章可以直接删除(我觉得ok)
    * 页面同理
* WooCommerce配置
    * 安装的时候一步步填好也没什么改的
    * 可以在仪表盘的WooCommerce-设置下更改设置
    * WooCommerce-状态-工具
        * 创建默认的WooCommerce页面
    * 产品
        * 进行产品管理和发布
* 评论管理
    * 导入文件后，会自动生成评论，可以对评论进行一波管理
* 外观
    * 可以捣鼓捣鼓自定义

## 总结1
* 傻瓜式安装和操作
* 暂时还不知道后端工作要做什么
    * 发现可以直接编辑插件
* 可以在父主题的基础上写子主题
    * 尚待尝试

## 添加“关于我们”页面
* 页面-新建页面
    * 添加标题和段落
    * ![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/page.png) 
* 外观-菜单
    * 新建菜单，菜单名称自定义
    * 此时已经有“关于我们”这个页面了
    * ![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/menu.jpg) 
    * 添加菜单项，并进行排序
    * 将其设置为主菜单(?我猜是这么叫的)
    * ![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/setmenu.png) 
    * 然后首页就显示了！戳进去看看！
    * ![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/showmenu.jpg) 

## 添加“售罄”提示
* 外观-编辑-模板函数（functions.php）
![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/soldout.png) 

## 添加“立即购买”按钮
* 外观-编辑-模板函数（functions.php）
![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/buynow.png) 

* 点击后
![](https://github.com/jckling/LearnWebsite/blob/master/SQ/Wordpress/check.jpg) 

## 前后端相关
* 外观-编辑
    * 模板函数和css
    * 增加功能和样式
* 插件-编辑
    * 直接对插件进行编辑  

## 总结2
* 安装了几个阿里支付的插件，其中一个不支持中国，还有一个是韩国人做的插件，上他们官网弄不懂。反正还没搞清楚。
* 安装了一个微信支付插件，需要商户账号就没继续捣腾了
* 添加的按钮不能直接写中文，大概是因为woocommerce的页面是直接翻译过来的？
* 在css里头加了点对按钮的修饰，没有显示样式，还没弄明白为什么
* 折腾了一下产品设置，各种参数还蛮多的。但其实每个选项下的可调整的地方都很多...
* 暂时收工~