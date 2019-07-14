#include<iostream>
#include<cstdio>
#include<vector>
#include<algorithm>
using namespace std;
const int maxn = 20000;
int n;
struct node // ����ṹ��
{
	int a;  // ��߽�
	int b;  // �ұ߽�
};
vector<node> reg;
bool cmp(node x,node y) // �ұ߽�����
{
	return x.b<y.b;
}
bool check(int x)
{
	int k = 0;  // ��0��ʼ���ǣ���������
	vector<node> tmp(reg);  // ��������
	while(true)
	{
		bool found = false;     // δ����
		for(int i=0;i<tmp.size();i++)
		{
			node now = tmp[i];  // ��ǰ����
			int ta = now.a; // ��ǰ������߽�
			int tb = now.b; // ��ǰ�����ұ߽�
			if(ta-x<=k && tb+x>=k)  // ����x�󸲸�k ����x�󸲸�k
			{
				found = true;   // �Ѹ���
				int len = tb-ta;    // ���䳤��
				if(ta+x>=k) k += len;   // ��߽��ƶ���k�������
				else k = tb+x;  // ��������ƶ�x
				tmp.erase(tmp.begin()+i);   // ɾ��������
				break;
			}
		}
		if(!found || k>=maxn) break;    // ���û���ҵ���������������/�Ѹ�����ȫ
	}
	return k>=maxn; // �Ƿ񸲸���ȫ
}
int main()
{
	scanf("%d",&n);
	for(int i=0;i<n;i++)
	{
		int a,b;
		scanf("%d%d",&a,&b);    // ������������
		a *= 2;
		b *= 2;
		reg.push_back({a,b});
	}
	sort(reg.begin(),reg.end(),cmp);    // ���ұ߽�����
	int l = 0,r = maxn; // �����α�
	double ans = 0; // �ƶ�����
	while(l<=r) // �������ƶ�����
	{
		int mid = (l+r)/2;  // �е�
		if(check(mid))  // ����ȫ����
		{
			r = mid-1;  // ����һ��
			ans = mid;  // ���ƶ�����
		}
		else    // û�и�����ȫ
		{
			l = mid+1;
		}
	}
	ans/=2.0;   // ��2�����������0.5
	cout<<ans<<endl;
	return 0;
}

