<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cookie;
use App\Http\Controllers\Controller;

include'function.php';

class TestController extends Controller
{
    public function index(Request $request)
    {
    	awards();
    	$chances = $request->cookie('chances');
    	print($chances);
    	if($chances == null){
    		print("hi\n");
    		Cookie::queue('chances', 10, 3600*24);
    	}	
    	//Cookie::queue('chances', null ,-1);
    	//$chances = $request->cookie('chances');
		return view('test')->with('prize', \App\Lucktest::all());
    }

    public function game(Request $request)
    {
    	$chances = $request->cookie('chances');

    	if($chances == null){
    		print("hi2\n");
    		Cookie::queue('chances', 10, 3600*24);
    	}else{
    		if($chances == 1){
    			print("Chances out\n");
    			Cookie::queue('chances', null ,-1);
    		}else{
    			$chances -= 1;
    			print($chances);
    			print("\n");
    			if($chances !=0){
    				Cookie::queue('chances', $chances, 3600*24);
    			}
    			$ip = \Request::getClientIp();
    			$result = win($ip);
    			print($result);	
    		}
    	}

    	return view('test')->with('prize', \App\Lucktest::all());;
    }

}
