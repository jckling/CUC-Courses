#include<iostream>
#include<algorithm>
#include<cstdio>
#include<stack>
using namespace std;
int a[500005];
int L[500005] = { 0 }, R[500005] = { 0 };
int Lmax[500005], Lmin[500005]; // ��iΪ�Ҷ˵㣬��������/��С��˵��λ��
int Rmax[500005], Rmin[500005]; // ��iΪ��˵㣬�������С/����Ҷ˵��λ��
stack<int> s;
long long sum[500005];
int main()
{
	int n, l=1, r=1, tmp;
	long long ans = 0;
	scanf("%d", &n);
	for (int i = 1; i <= n; i++)
	{
		scanf("%d", &a[i]);
		sum[i] = a[i] + sum[i - 1];
		L[i] = i, R[i] = i;
	}
    // ��a[i]Ϊ��Сֵ���������Ҷ�
	for (int i = 1; i <= n; i++)
	{
		while(!s.empty()&&a[i]<a[s.top()])
		{
			tmp = s.top();
			R[tmp] = i - 1;
			s.pop();
		}
		s.push(i);
	}
	while (!s.empty())
	{
		R[s.top()] = n;
		s.pop();
	}
    // ��a[i]Ϊ��Сֵ�����������
	for (int i = n; i >= 1; i--)
	{
		while (!s.empty()&&a[i] < a[s.top()])
		{
			tmp = s.top();
			L[tmp] = i + 1;
			s.pop();
		}
		s.push(i);
	}
	while (!s.empty())
	{
		L[s.top()] = 1;
		s.pop();
	}

	Lmin[1] = 1,Lmax[1]=1;
	Rmin[n] = n, Rmax[n] = n;

    // ��iΪ�Ҷ˵㣬��������/��С��˵��λ��
	for (int i = 2; i <= n; i++)
	{
		if (sum[i - 1] - sum[Lmin[i - 1] - 1] > 0)
			Lmin[i] = i;
		else Lmin[i] = Lmin[i - 1];	//����һ�ε������Ϊ���ͼ��ϣ�ʹ����͸�С
		if (sum[i - 1] - sum[Lmax[i - 1] - 1] < 0)
			Lmax[i] = i;
		else Lmax[i] = Lmax[i - 1];
	}

    // ��iΪ��˵㣬�������С/����Ҷ˵��λ��
	for (int i = n - 1; i >= 1; i--)
	{
		if (sum[Rmin[i + 1]] - sum[i] > 0)
			Rmin[i] = i;
		else Rmin[i] = Rmin[i + 1];
		if (sum[Rmax[i + 1]] - sum[i] < 0)
			Rmax[i] = i;
		else Rmax[i] = Rmax[i + 1];
	}

    // �������
	for (int i = 1; i <= n; i++)
	{
		if (a[i] < 0)
		{
			l = max(L[i], Lmin[i]);
			r = min(R[i], Rmin[i]);
		}
		else {
			l = max(L[i], Lmax[i]);
			r = min(R[i], Rmax[i]);
		}
		ans = max(ans, 1ll * a[i] * (sum[r] - sum[l-1]));
	}

	printf("%lld\n", ans);
	return 0;
}
