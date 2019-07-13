#include <stdio.h>
#include <vector>
#include <algorithm>
using namespace std;
struct twoInts
{
	int j, f;
	bool operator<(const twoInts two) const
	{
		double a = (double)j / (double)f;
		double b = (double)two.j / (double)two.f;
		return a > b;
	}
};

int main()
{
	int M, N;
	while (scanf("%d %d", &M, &N) && -1 != M)
	{
		vector<twoInts> vt(N);
		for (int i = 0; i < N; i++)
		{
			scanf("%d", &vt[i].j);
			scanf("%d", &vt[i].f);
		}
		sort(vt.begin(), vt.end());
		double maxBean = 0.0;
		for (int i = 0; i < N; i++)
		{
			if (M >= vt[i].f)
			{
				maxBean += vt[i].j;
				M -= vt[i].f;
			}
			else
			{
				maxBean += (double)vt[i].j * M / (double)vt[i].f;
				break;
			}
		}
		printf("%.3lf\n", maxBean);
	}
	return 0;
}
