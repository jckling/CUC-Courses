<!DOCTYPE html>
<html>
<head>
	<title>Sign up</title>
</head>
<body>

	<form action="/register" method="POST">
		{!! csrf_field()!!}
		<p><label for="name">Name</label><br>
			<input type="text" name="name"></p>
		<p><label for="email">Email</label><br>
			<input type="email" name="email"></p>
		<p><label for="password">Password</label><br>
			<input type="password" name="password"></p>
		<p><label for="password">Confirm password</label><br>
			<input type="password" name="password_confirmation"></p>
		<button>Sign up</button>
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
