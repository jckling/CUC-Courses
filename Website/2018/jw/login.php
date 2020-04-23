<?php

	$cookie_file = dirname(__FILE__).'/cookie.tmp';

	// 参数
	$arr = array(
		'groupid:' => '',
		'j_username' => $_POST['name'],
		'j_password' => $_POST['psw'],
		'j_captcha' => $_POST['cap'],
		'login' => '登录');

	// 使用cookie
	$url = 'http://jw.cuc.edu.cn/academic/j_acegi_security_check?';
	foreach($arr as $k => $v){
		$url = $url.$k.'='.$v.'&';
	}

	$ch = curl_init($url);
	curl_setopt($ch, CURLOPT_HEADER, true);
	curl_setopt($ch, CURLOPT_REFERER, 'http://jw.cuc.edu.cn/home/index.do');
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
	curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
	curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file);
	$res = curl_exec($ch);
	curl_close($ch);
	

	// 使用cookie，首页
	// $ch = curl_init();
	// curl_setopt($ch, CURLOPT_URL, 'http://jw.cuc.edu.cn/academic/calendarinfo/viewCalendarInfo.do');
	// curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	// curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
	// curl_setopt($ch, CURLOPT_HEADER, true);
	// curl_setopt($ch, CURLOPT_REFERER, 'http://jw.cuc.edu.cn/home/index.do');
	// $res = curl_exec($ch);
	// print($res);
	// curl_close($ch);

	// 使用cookie，成绩查询
	$arr = array(
		'year' => '', //36-2016 37-2017
		'term' => '', //1春2夏3秋
		'prop' => '',
		'para' => 0,
		'sortColumn' => '',
		'Submit' => '查询'
	);
	$url = 'http://jw.cuc.edu.cn/academic/manager/score/studentOwnScore.do?';
	foreach($arr as $k => $v){
		$url = $url.$k.'='.$v.'&';
	}

	$ch = curl_init($url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
	curl_setopt($ch, CURLOPT_HEADER, true);
	$res = curl_exec($ch);
	curl_close($ch);

	// 取出datalist
	preg_match('/<table[^>]*class="datalist"[^>]*>(.*?)<\/table>/s', $res, $match);
	// print_r($match[1]);
	// print("<br>");

	// 取出每行
    preg_match_all("/<tr[^>]*?>(.*?)<\/tr>/s", $match[1], $arr);
    // print_r($arr[1]);
    // print("<br>");

    // 取出每列
    $rows = array();
    preg_match_all("/<th[^>]*?>(.*?)<\/th>/s", $arr[1][0], $temp);
    $rows[] = $temp[1];
    for($i=1; $i < count($arr[1]); $i++) {
    	preg_match_all("/<td[^>]*?>(.*?)<\/td>/s", $arr[1][$i], $temp);
    	$rows[] = $temp[1];
    }
    print_r($rows);
?>