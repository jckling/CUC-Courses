<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Mail;

class EmailController extends Controller
{
    static public function send($to)
    {
    	$from = "Jck's Personal Blog";
    	$test = "Click http://localhost:8000/success?email=$to to confirm your account";
    	Mail::raw($test, function($message) use($to){
    		$message->to($to)->subject('Active your account');
    	});

    	if(count(Mail::failures()) < 1)
    	{
    		$message = "Check your email to confirm your address";
    	}
    	else
    	{
    		$message = "Sorry, there may be some errors.";
    	}
    	return $message;
    }
}

