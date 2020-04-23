<?php

// 登录

include 'include.php';

if(!$_POST){
	// 自引用表单
	$display_block = <<<END_OF_BLOCK
<form method="POST" action="$_SERVER[PHP_SELF]">

<p><label for="email">E-Mail:</label><br>
<input type ="email" id="email" name="email" size="40" maxlength="150"></p>
	
<p><label for="password">Password:</label><br>
<input type ="password" id="password" name="password" size="40" maxlength="150"></p>
	
<button type ="submit" name="submit" value="signin">Sign in</button>
</form>
	
END_OF_BLOCK;
}else if($_POST){
	if($_POST['email'] == "" || $_POST['password'] == ""){
		// 重定向回来
		header("Location: signin.php");
		exit;
	}else{
		// 连接数据库
		doDB();
		
		// 邮箱密码转义
		$safe_email = mysqli_real_escape_string($mysqli, $_POST['email']);
		$safe_password = mysqli_real_escape_string($mysqli, $_POST['password']);
		//$safe_password = md5($safe_password);
		
		// 查询
		$check_sql = "SELECT active FROM USERS WHERE email = '".$safe_email."' and password = '".$safe_password."'";
		$check_res = mysqli_query($mysqli, $check_sql) or die(mysqli_error($mysqli));

		// 表中存在该数据
		if($res = mysqli_fetch_array($check_res)){
			if($res['active'] == 0){
				$display_block = "<p>Your Account has not been actived!</p>";
			}else{		
				// 提示信息
				$display_block = "<p>Welcome!</p>";
			
				$_SESSION['name'] = $check_res;
     			$_SESSION['email'] = $safe_email;

				// 释放资源
				mysqli_free_result($check_res);

				// 关闭数据库
				mysqli_close($mysqli);
			}
			
		}else{
			// 表中不存在或数据不对应，提示信息
			$display_block = "<p>Email or Password Wrong!</p>";
		}
	}
}else if($_GET['action']=="logout"){
	// 登出
	unset($_SESSION['name']);
    unset($_SESSION['email']);
	$display_block = "<p>Bye</p>";
	exit();
}

?>


<!DOCTYPE html>
<html>
<head>
	<title>Sign in</title>
	</head>
	<body>
		<h1>Sign in</h1>
		<?php echo "$display_block"; ?>
	</body>
</html>