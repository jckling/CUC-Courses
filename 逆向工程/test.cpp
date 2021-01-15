#include <windows.h>

// 常量
#define para1 24
// 伪常量
const int para2 = 120;


int add(int a, int b) {
	int result;

	if (a > b) {
		result = a + b;
	}
	else if(a == b){
		result = a;
	}
	else {
		result = 0;
	}

	return result;
}

int mul(int a, int b) {
	int i = 5;
	while (i > 0) {
		i--;
	}
	return a * b;
}

int poly(int a, int b) {
	int result;

	switch (a){
		case 1:
			result = add(a, b);
			break;
		case 2:
			result = mul(a, b);
			break;
		case 3:
			result = add(a, b);
			break;
		case 4:
			result = mul(a, b);
			break;
		case 5:
			result = add(a, b);
			break;
		case 6:
			result = mul(a, b);
			break;
		case 7:
			result = add(a, b);
			break;
		default:
			result = mul(a, b);
			break;
	}

	return result;
}

void fun(int a) {
	int i = 20;
	do {
		i--;
	} while (i > 0);
}

int main() {
	int a = 100;

	fun(a);

	int b = 100000;

	int result = poly(a, b);

	int i;

	for (i = 0; i < 2; i++) {
		if(result > 10000000)
			result += add(para1, a);
		else
			result += add(para2, b);
	}

	// TEXT常量
	MessageBox(NULL, TEXT("HELLO WORLD!"), TEXT("HI"), MB_OK);	
	ExitProcess(0);
}