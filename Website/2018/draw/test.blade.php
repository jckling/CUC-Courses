<!doctype html>
<html>
<head>
	<title></title>
</head>
<body>
	<table border="1" width="20%">
		<thead><th>rewards</th></thead>
		<tr><td>One</td></tr>
		<tr><td>Two</td></tr>
		<tr><td>Three</td></tr>
		<tr><td>Four</td></tr>
	</table>

	<form action="/test" method="post">
		{!! csrf_field()!!}
		<button type="submit">
			Start Gambling!
		</button>
	</form>


	@if($prize)
		<table border="1" width="20%">
			<thead><th colspan='2'>list</th></thead>
            @foreach($prize as $ward)
            <tr>
            	<td>{{$ward->name}}</td>
            	<td>{{$ward->reward}}</td>
            </tr>
            @endforeach
        </table>
	@endif

	@if($errors->any())
        <ul class="alert alert-danger">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
	@endif
</body>
</html>
