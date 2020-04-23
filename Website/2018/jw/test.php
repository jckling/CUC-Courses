<?php

	$cookie_file = dirname(__FILE__).'/cookie.tmp';

	// 获得cookie
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL,'http://jw.cuc.edu.cn/academic/getCaptcha.do');
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_COOKIEJAR, $cookie_file);
	$img = curl_exec($curl);
	curl_close($curl);

	// 保存验证码为图片
	$fp = fopen("Code.jpg","w");
	fwrite($fp,$img);
	fclose($fp);

?>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<form method="post" action="login.php">
	<label>用户名</label>
		<input type="text" name="name" value=""/>

	<label>密码</label>
		<input type="password" name="psw" value=""/>

	<img src="Code.jpg" />
	<label>验证码</label>
		<input type="text" name="cap">
	<button type="submit">提交</button>
</form>

</body>
</html>