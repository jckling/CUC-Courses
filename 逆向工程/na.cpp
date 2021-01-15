#include <windows.h>
#define N 50
int fun1(int x, int y)
{
	return x + y;
}

int fun2(int m, int n)
{
	int sum = fun1(m, n);
	return sum * sum;
}
int fun3(int x, int y, int z)
{
	int mul = fun2(x, y);
	int sum = fun1(mul, z);
	return sum;
}
int fun4(int x, int y)
{
	return x - y;
}
int main()
{
	int a, b, c, d, e;
	int x = 0;
	a = fun1(2, 3);
	b = fun2(3, 4);
	c = fun3(a, b, 1);
	if (a == b)
	{
		MessageBoxA(NULL, NULL, "a = b!", MB_OK);
	}
	else if (a < b)
	{
		d = fun4(a, b);
	}
	else {
		ExitProcess(0);
	}
	if (a == 5)
	{
		MessageBoxA(NULL, NULL, "a = 5!", MB_OK);
	}

	if (d < 40)
	{
		ExitProcess(0);
	}
	else
	{
		d = d - 10;
		b = b - 48;
	}
	e = fun4(c, a);
	if (e != 30)
	{
		ExitProcess(0);
	}
	else {
		e = 30;
	}
	while (x<N)
	{
		x = x + a;
		switch (x) {
		case 5:
			MessageBoxA(NULL, "x = 5", NULL, MB_OK);
			break;
		case 7:
			MessageBoxA(NULL, "x = 7", NULL, MB_OK);
			break;
		case 12:
			MessageBoxA(NULL, "x = 12", NULL, MB_OK);
			break;
		default:
			MessageBoxA(NULL, "not this", NULL, MB_OK);
			break;
		}
	}
}
