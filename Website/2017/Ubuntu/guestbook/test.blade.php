<!DOCTYPE html>
<html>
<head>
	<title>Note Book</title>
</head>
<body>
	<form method="GET">
		<!--遍历输出留言-->
		@foreach($articles as $article)
			<p>{{ $article->content }}</p>
			<p>{{ $article->created_at }} {{ $article->name }} #{{ $article->id }}</p>
			<br>
		@endforeach
	</form>
	
	<!--若有错误，输出错误-->
	@if($errors->any())
		<ul>
			@foreach($errors->all() as $error)
			<li>{{ $error }}</li>
			@endforeach
		</ul>
	@endif

	<!--增加留言-->
	<form method="POST">
		<p><label for="name">Name</label><br>
		<!---->
		{!! csrf_field() !!}
			<input type="text" id="name" name="name" maxlength="150" placeholder="default:your ip address"></p>

		<p><label for="text">Note</label><br>
			<textarea cols="100" rows="20" name="content" placeholder="Write down whatever you want to say"></textarea></p>
			<button type="sumbit" method="POST">Submit</button>
	</form>
	
</body>
</html>