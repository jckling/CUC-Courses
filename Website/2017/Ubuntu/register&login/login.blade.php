<!DOCTYPE html>
<html>
<head>
	<title>Log in</title>
</head>
<body>

	<form action="/login" method="POST">
		{!! csrf_field()!!}
		<p><label for="email">Email</label><br>
			<input type="email" name="email"></p>
		<p><label for="password">Password</label><br>
			<input type="password" name="password"></p>
		<button>Log in</button>
	</form>

	@if($errors->any())
        <ul class="alert alert-danger">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
	@endif
	
</body>
	</html>
