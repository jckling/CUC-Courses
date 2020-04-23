<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;

class LoginController extends Controller
{
    public function log(Requests\LoginRequest $request)
    {
        $email = $request->get('email');
    	$user = \App\Test::where('email', $email)->first();
    	if(is_null($user))
    	{
            # 未找到账号
    		$message = "Oooops! Can't find the user!";
    	}
    	else
    	{
    		if(0 == $user->active)
    		{
                # 未激活
    			$message = "Oooops! Account hasn't been actived!";
    		}
    		else if(password_verify($request->get('password'), $user->password))
    		{
                # 登陆成功
    			$message = "You have logged in!";
    		}
    		else
    		{
                # 密码错误
    			$message = "Oooops! Password wrong!";
    		}
    	}
        //$message = Auth::attempt(['email' => $user->email, 'password' => $user->password]);
        //$message = $user->password;
    	return view('/home',compact('message'));
    }
}
