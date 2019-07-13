#include<iostream>
#include<cstdio>
#include<vector>
#include<algorithm>
using namespace std;
const int maxn = 20000;
int n;
struct node // 区间结构体
{
	int a;  // 左边界
	int b;  // 右边界
};
vector<node> reg;
bool cmp(node x,node y) // 右边界排序
{
	return x.b<y.b;
}
bool check(int x)
{
	int k = 0;  // 从0开始覆盖，从左往右
	vector<node> tmp(reg);  // 拷贝向量
	while(true)
	{
		bool found = false;     // 未覆盖
		for(int i=0;i<tmp.size();i++)
		{
			node now = tmp[i];  // 当前区间
			int ta = now.a; // 当前区间左边界
			int tb = now.b; // 当前区间右边界
			if(ta-x<=k && tb+x>=k)  // 左移x后覆盖k 右移x后覆盖k
			{
				found = true;   // 已覆盖
				int len = tb-ta;    // 区间长度
				if(ta+x>=k) k += len;   // 左边界移动到k处，最佳
				else k = tb+x;  // 最多向右移动x
				tmp.erase(tmp.begin()+i);   // 删除该区间
				break;
			}
		}
		if(!found || k>=maxn) break;    // 如果没有找到满足条件的区间/已覆盖完全
	}
	return k>=maxn; // 是否覆盖完全
}
int main()
{
	scanf("%d",&n);
	for(int i=0;i<n;i++)
	{
		int a,b;
		scanf("%d%d",&a,&b);    // 输入扩大两倍
		a *= 2;
		b *= 2;
		reg.push_back({a,b});
	}
	sort(reg.begin(),reg.end(),cmp);    // 按右边界排序
	int l = 0,r = maxn; // 左右游标
	double ans = 0; // 移动距离
	while(l<=r) // 二分找移动距离
	{
		int mid = (l+r)/2;  // 中点
		if(check(mid))  // 可完全覆盖
		{
			r = mid-1;  // 缩减一半
			ans = mid;  // 可移动距离
		}
		else    // 没有覆盖完全
		{
			l = mid+1;
		}
	}
	ans/=2.0;   // 除2后输出，可有0.5
	cout<<ans<<endl;
	return 0;
}

