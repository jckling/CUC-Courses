<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;

class RegisterController extends Controller
{

    protected function create(Requests\CreateUserRequest $request)
    {
    	$user = \App\Test::find($request->get('email'));
    	if($user != null)
        {
            # 已经注册过
    		$message = "The email has already been registered";
        }
    	else
    	{
            # 生成新用户
    		\App\Test::create([
            	'name' => $request->get('name'),
            	'email' => $request->get('email'),
            	'password' => bcrypt($request->get('password')),
        	]);

            # 发送邮件
        	$email = $request->get('email');
            $message = EmailController::send($email);
    	} 
    	
        return view('/home',compact('message'));
    }

    protected function confirm(Request $request)
    {
        $email = $request->email;
        $user = \App\Test::where('email', $email)->first();
        if($user != null)
        {
            # 重复激活
            if($user->active == 0)
            {
                $user->active = 1;
                $user->save();
                $message = "Your account has been actived.";
            }
            else
            {
                $message = "Your account has already been actived. Don't repeat register.";
            }
            
        }
        else
        {
            $message = "Sorry, there may be some errors.";
        }

        //return redirect('/home')->with('message',$message);
        return view('/home',compact('message'));
    }
}
