// ¶þ·ÖËÑË÷
#include<iostream>
#include<cstdio>
#include<cstring>
using namespace std;
int n,k;
const int maxn = 100100;
const int INF = 0x3f3f3f3f;
int w[maxn],h[maxn];
int Divide(int ww,int hh,int l){
	int res = ww/l;
	res *=  hh/l;
	return res;
}
bool check(int l){
	int res = 0;
	for(int i = 1;i <= n;i++)
		res += Divide(w[i],h[i],l);
	return res >= k;
}
void solve(){
	int l = 1,r = INF;
	while(l < r){
		int mid = (l+r)/2;
		if(check(mid))
            l = mid+1;
		else
            r = mid;
	}
	cout << l - 1<< endl;
}
int main(){
	scanf("%d%d",&n,&k);
	for(int i = 1;i <= n;i++)
        scanf("%d%d",h+i,w+i);
	solve();
	return 0;
}
