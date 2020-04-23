<?php
include 'include.php';

// 连接数据库
doDB();

// 转义
$safe_email = mysqli_real_escape_string($mysqli, $_GET['email']);

// 查询
$comfirmemail_sql = "SELECT email FROM USERS WHERE email = '".$safe_email."'";
$comfirmemail_res = mysqli_query($mysqli, $comfirmemail_sql) or die(mysqli_error($mysqli));

if(mysqli_num_rows($comfirmemail_res) > 0){
	// 将状态改为激活
	$already_sql = "SELECT active FROM USERS WHERE email = '".$safe_email."'";
	$already_res = mysqli_query($mysqli, $already_sql) or die(mysqli_error($mysqli));
	$already = mysqli_fetch_assoc($already_res);

	if($already['active'] == 1){
		// 如果已经激活
		$display_block = "Wrong! Your account have already been actived!";
	}else{
		// 更新数据表
		$sql = "UPDATE USERS SET active=1 WHERE email = '".$safe_email."'";
		$res = mysqli_query($mysqli, $sql) or die(mysqli_error($mysqli));

		
		if($res){
			$display_block = "Your account have been actived!";
		}else{
			$display_block = "System wrong";
		}
	}
}else{
	$display_block = "System wrong";
}

?>


<!DOCTYPE html>
<html>
<head>
	<title>Check</title>
	<!-- 定时跳转 -->
	<meta http-equiv="refresh" content="3;url=http://localhost/Projects/Test/phptest/index.html">
	</head>
	<body>
		<h1>Check</h1>
		<?php echo "$display_block"; ?>
	</body>
</html>