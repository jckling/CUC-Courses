#include<cstdio>
using namespace std;
typedef long long LL;
#define MAXN 1000000000
#define MOD 1000000007

LL n, ans;

LL quickPow(LL a, LL N) {
    LL r = 1, aa = a;
    while(N) {
        if (N & 1 == 1) r = (r * aa) % MOD;
        N >>= 1;
        aa = (aa * aa) % MOD;
    }
    return r % MOD;
}

int main(){
    scanf("%lld", &n);
    ans = 4;
    if(n==1){
        printf("1\n");
    }
    else{
        ans = ans*quickPow(3, n-2)%MOD;
        printf("%lld\n", ans);
    }

    return 0;
}
