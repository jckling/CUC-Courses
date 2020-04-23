<?php

// 注册

include 'include.php';
include 'stmp.php';

if(!$_POST){
	// 自引用表单
	$display_block = <<<END_OF_BLOCK
<form method="POST" action="$_SERVER[PHP_SELF]">
	
<p><label for="name">Name:</label><br>
<input type="name" id="name" name="name" size="40" maxlength="255"></p>
	
<p><label for="email">E-Mail:</label><br>
<input type ="email" id="email" name="email" size="40" maxlength="150"></p>
	
<p><label for="password">Password:</label><br>
<input type ="password" id="password" name="password" size="40" maxlength="150"></p>

<p><label for="confirmpassword">Confirm Password:</label><br>
<input type ="password" id="confirmpassword" name="confirmpassword" size="40" maxlength="150"></p>
	
<button type ="submit" name="submit" value="signin">Sign up</button>
</form>

END_OF_BLOCK;
}else{
	if($_POST['name'] == "" || $_POST['email'] == "" || $_POST['password'] == "" || $_POST['confirmpassword'] == ""){
		// 如果未填写，重定向回来
		header("Location: signup.php");
		exit;
	}else{
		if((strlen($_POST['password']) < 8 || strlen($_POST['password']) > 20) || ($_POST['password'] != $_POST['confirmpassword'])){
			// 密码长度超出范围或两次密码不一致
			$display_block = "<p>Password Wrong!</p>";
		}else{		
			if(!preg_match('/^[\w\x80-\xff]{3,15}$/', $_POST['name'])){
				// 提示信息
				$display_block = "<p>Name Wrong!</p>";
			}
			
			// 验证邮箱格式
			$pattern = "/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/";
			if(!preg_match($pattern, $_POST['email'], $matches)){
				// 邮箱格式不正确
				// 提示信息
				$display_block = "<p>Email wrong</p>";
			}

			// 验证邮箱格式
			//$email=filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
			//if($email == false){
			//	print("Submitted email address is invalid.");
			//}
			
			// 邮箱名字密码格式都正确
			// 连接数据库
			doDB();
		
			// 转义
			$safe_name = mysqli_real_escape_string($mysqli, $_POST['name']);
			$safe_email = mysqli_real_escape_string($mysqli, $_POST['email']);
			$safe_password = mysqli_real_escape_string($mysqli, $_POST['password']);
			//$safe_password = md5($safe_password);
			
			// 查询
			$checkemail_sql = "SELECT email FROM USERS WHERE email = '".$safe_email."'";		
			$checkname_sql = "SELECT name FROM USERS WHERE name = '".$safe_name."'";
			$checkname_res = mysqli_query($mysqli, $checkname_sql) or die(mysqli_error($mysqli));
			$checkemail_res = mysqli_query($mysqli, $checkemail_sql) or die(mysqli_error($mysqli));
			
			if(mysqli_num_rows($checkname_res) > 0){
				// 表中已存在该用户名
				// 释放资源
				mysqli_free_result($checkname_res);
				mysqli_free_result($checkemail_res);

				// 提示信息
				$display_block = "<p>The name has already been used!</p>";
				
				// 关闭连接
				mysqli_close($mysqli);
			}else if(mysqli_num_rows($checkemail_res) > 0){
				// 表中已存在该邮箱

				// 释放资源
				mysqli_free_result($checkemail_res);
				mysqli_free_result($checkname_res);
			
				// 提示信息
				$display_block = "<p>The email has already been registered!</p>";
				
				// 关闭连接
				mysqli_close($mysqli);				
			}else{
				// 释放资源
				mysqli_free_result($checkemail_res);
				mysqli_free_result($checkname_res);
				
				// 发送激活邮件
				confirmemail($safe_email);
				// 添加到数据库								
				$add_sql = "INSERT INTO users (name,password,email) VALUES ('".$_POST['name']."','".$safe_password."','".$safe_email."')";
				$add_res = mysqli_query($mysqli, $add_sql) or die(mysqli_error($mysqli));
				
				// 提示信息
				$display_block = "<p>Check the email to active your account!</p>";

				// 
				$_SESSION['name'] = $safe_name;
     			$_SESSION['email'] = $safe_email;
				
			}
		}
	}
}


?>


<!DOCTYPE html>
<html>
<head>
	<title>Sign up</title>
	</head>
	<body>
		<h1>Sign up</h1>
		<?php echo "$display_block"; ?>
	</body>
</html>