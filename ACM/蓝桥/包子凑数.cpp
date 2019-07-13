#include<iostream>
#include<cstring>
#include<vector>
using namespace std;

int gcd(int x,int y){
	return y==0?x:gcd(y,x%y);
}

const int V=10000;
int n,a[110],com;
int dp[10004];

int main(){
	cin>>n;
	for(int i=1;i<=n;i++)
        cin>>a[i];

	//求n个数的最大公约数
	com=gcd(a[1],a[2]);
	for(int i=3;i<=n;i++)
        com=min(com,gcd(a[i],com));

	if(com!=1)
		cout<<"INF"<<endl;
    else{
        dp[0]=1;//0个包子是一定能凑出来的

        for(int i=1;i<=n;i++)
            for(int j=0;j+a[i]<=V;j++)
                if(dp[j])
                    dp[j+a[i]]=1;

        int cnt=0;
        for(int i=V;i>=0;i--)
            if(!dp[i])cnt++;
        cout<<cnt<<endl;
    }
	return 0;
}
