#include<iostream>
#include<cmath>
using namespace std;
typedef long long ll;
ll a, b, n;
ll ans;

// 同余小数部分相等
// 6%5=1    11%5=1
// 6/5=1.2  11/5=2.2
int main(){
    cin>>a>>b>>n;
    while(n-10>0){
        a*=1e10;
        a%=b;
        n-=10;
    }
    // 取n-1 n n+1
    for(int i=0; i<n+2; i++){
        a*=10;
        if(i>=n-1)
            cout << a/b;
        a%=b;
    }
    return 0;
}
