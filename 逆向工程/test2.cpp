#include <windows.h>

int add(int a, int b) {
	return a + b;
}

int mul(int a, int b) {
	return a * b;
}

int poly(int a, int b) {
	int result;

	switch (a) {
	case 100:
		result = add(a, b);
		break;
	default:
		result = mul(a, b);
		break;
	}

	return result;
}

void fun(int a) {
	//
}

int main() {
	int a = 1;
	int b = 2;
	int c = 3;
	int result = poly(a, b);

	int i = 0;

	// do-while
	do {
		i++;
	} while (i < 10);

	// while
	while (a < 20) {
		a = add(a, b);
	}
	
	// for
	for (; i < 20; i++) {
		if (result > 2)
			result += add(a, b);
		else
			result += mul(a, b);
	}

	// switch-case
	switch (c)
	{
	case 1:
		result -= add(a, b);
		break;
	case 2:
		result -= mul(a, b);
		break;
	case 3:
		result -= add(a, b);
		break;
	case 4:
		result -= mul(a, b);
		break;
	default:
		fun(c);
		break;
	}


	// TEXT
	MessageBox(NULL, TEXT("HELLO WORLD!"), TEXT("HI"), MB_OK);
	ExitProcess(0);
}