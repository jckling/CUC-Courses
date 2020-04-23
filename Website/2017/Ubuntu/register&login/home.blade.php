<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
</head>
<body>
	<h1>Welcome</h1>

	@if($message)
	<h3>{{ $message }}</h3>
	@endif
	
	{!! csrf_field()!!}
	<form action="/login" method="GET">
		<button type="submit" >Log in</button>
	</form>
	<form action="/register" method="GET">
		<button type="submit">Register</button>
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
