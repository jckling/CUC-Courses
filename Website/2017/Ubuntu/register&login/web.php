<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/home', function ($message = "") {
    return view('home',compact('message'));
});

Route::get('/login', function () {
    return view('login');
});
Route::post('/login','LoginController@log');

Route::get('/register', function () {
    return view('register');
});
Route::post('/register','RegisterController@create');

Route::get('/success', 'RegisterController@confirm');
