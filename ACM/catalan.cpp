#include<iostream>
#include<algorithm>
#include<string>
#include<string.h>
using namespace std;

// 卡塔兰数：c(2n,n)-c(2n,n-1)
// 对于在n位的2进制中，有m个0，其余为1的catalan数为：C(n,m)-C(n,m-1)

// 问题1的描述：有n个1和m个-1（n>m），共n+m个数排成一列，满足对所有0<=k<=n+m的前k个数的部分和Sk > 0的排列数。
// 问题等价为在一个格点阵列中，从（0，0）点走到（n，m）点且不经过对角线x==y的方法数（x > y）。
// 考虑情况I：第一步走到（0，1），这样从（0，1）走到（n，m）无论如何也要经过x==y的点，这样的方法数为(( n+m-1,m-1 ));
// 考虑情况II：第一步走到（1，0），又有两种可能：
// a . 不经过x==y的点；（所要求的情况）
// b . 经过x==y的点，我们构造情况II.b和情况I的一一映射，说明II.b和I的方法数是一样的。
// 设第一次经过x==y的点是（x1，y1），将（0，0）到（x1，y1）的路径沿对角线翻折，于是唯一对应情况I的一种路径；
// 对于情况I的一条路径，假设其与对角线的第一个焦点是（x2，y2），将（0，0）和（x2，y2）之间的路径沿对角线翻折，唯一对应情况II.b的一条路径。
// 问题的解就是总的路径数 ((n+m, m)) - 情况I的路径数 - 情况II.b的路径数。
// ((n+m , m)) - 2*((n+m-1, m-1)) 或 ((n+m-1 , m)) - ((n+m-1 , m-1))


long long mod = 1e9 + 7,N=100000;
long long fac[100005], inv[100005];
void init()
{
	fac[0] = inv[0] = inv[1] = 1;
	for (int i = 1; i <= N; i++)
		fac[i] = 1ll * fac[i - 1] * i%mod;
	for (int i = 2; i <= N; i++)
		inv[i] = 1ll * (mod - mod / i)*inv[mod%i] % mod;
	for (int i = 1; i <= N; i++)
		inv[i] = 1ll * inv[i - 1] * inv[i] % mod;
}
long long C(int n, int m)
{
	return ((fac[n] * inv[m]) % mod*(inv[n - m])) % mod;
}
int main()
{
	int t, m, n;
	init();
	cin >> t;
	while (t--)
	{
		cin >> m >> n;
		cout << (C(n+m-1, m) - C(n+m-1, m-1) + mod) % mod << endl;
	}
	return 0;
}