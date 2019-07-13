#include <cstdio>
#include <cmath>
#include <algorithm>
using namespace std;
#define MAX 1000000

int pos[MAX+11];
int ant = 1;

// 素数打表，位置
int main()
{
	for (int i = 2 ; i <= MAX ; i++)
	{
		if (!pos[i])
		{
			pos[i] = ant;
			for (int j = i + i ; j <= MAX ; j += i)
				pos[j] = ant;
			ant++;
		}
	}
	int n;
	while (~scanf ("%d",&n))
		printf ("%d\n",pos[n]);
}
