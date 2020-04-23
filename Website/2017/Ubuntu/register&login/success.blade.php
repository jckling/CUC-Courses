<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
</head>
<body>

	@if($message)
	<h3>{{ $message }}</h3>
	@endif
	
	{!! csrf_field()!!}

	@if($errors->any())
        <ul class="alert alert-danger">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
	@endif
</body>
	</html>
