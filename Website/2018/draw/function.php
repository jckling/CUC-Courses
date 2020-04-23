<?php

function got($reward, $ip){
	$remain = \App\Test::where('name', $reward)->first();
	if($remain->number > 0){
		 	$record = \App\Lucktest::where('name', $ip)->first();
		 	if($record->count()){
		 		return 'You\'ve got your lucky reward!';
		 	}
		 	else{
		 		$record = new \App\Lucktest;
		 		$record->name = $ip;
    			$record->reward = $reward;
				$record->save();

				$remain->number = $remain->number-1;
    			$remain->save();
		 	}
		 	
    		return 'Congratulations! Got Reward'+$reward;
   	}
   	return 'Sorry, luck for next time';
}

function win($ip)
{
	$num = rand(1,1000);
    $one = 1000 * (0.002);
    $two = 1000 * (0.01);
    $three = 1000 * (0.04);
    $four = 1000 * (0.4);

   	$result = 'Sorry, luck for next time';

    if ($num >= 1 && $num <= $one) {
    	$result = got('One', $ip);
    }else if ($num >= ($one + 1) && $num <= ($one + $two)){
    	$result = got('Two', $ip);
    }else if ($num >= ($one + $two + 1) && $num <= ($one + $two + $three)){
    	$result = got('Three', $ip);
    }else if ($num >= ($one + $two + $three +1) && $num <= ($one + $two + $three + $four)){
    	$result = got('Four', $ip);
    }
    return $result;
}

function awards()
{
	$names = array('One', 'Two', 'Three', 'Four');
	$numbers = array(10, 20, 30, 40);
	$i = count($names);
	for($j=0; $j<$i; $j++){
		$result = \App\Test::where('name', $names[$j])->get();
		if($result->count()){
		}else{
			$record = new \App\Test;
			$record->name=$names[$j];
			$record->number=$numbers[$j];
			$record->save();
		}
	}
	return 'done!';
}
