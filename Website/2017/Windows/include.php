<?php

// 连接数据库
function doDB(){
	global $mysqli;
	
	// 连接数据库
	$mysqli = mysqli_connect("localhost", "", "", "");
	
	// 连接失败，提示
	if(mysqli_connect_errno()){
		printf("Connect failed: %s\n", mysqli_connect_error());
		exit();
	}
}

?>