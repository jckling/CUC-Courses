<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TestController extends Controller
{
    // 测试
    public function show()
    {
    	//echo "Hello World";
    	// 表示/view/test/
    	return view('test.test');
	}

	// 展示
	 public function index()
	 {
	 	// 返回数据表的数据
	 	$articles = \App\Note::all();
    	return view('test.test',compact('articles'));
	 }

	 // 储存留言板数据
	 public function store(Request $request)
	 {
	 	// 新建实例对象
	 	$input = new \App\Note;

	 	// 如果没填则设置为ip地址
	 	if(null == $request->get('name'))
	 		$input->name = $_SERVER['REMOTE_ADDR'];
	 	else
	 		$input->name = $request->get('name');
	 	
	 	// 填写的内容
	 	$input->content = $request->get('content');

	 	// 保存
	 	$input->save();

	 	// 重定向回页面
	 	return redirect('test');
	 }
}
