#include<iostream>
#include<cstdio>
#include<cstring>
using namespace std;
typedef long long ll;
const int maxn = 1e5+5;
ll sum[maxn], cnt[maxn], n, k;

int main(void)
{
    while(cin >> n >> k)
    {
        memset(sum, 0, sizeof(sum));
        memset(cnt, 0, sizeof(cnt));
        ll ans = 0;
        for(int i = 1; i <= n; i++)
        {
            ll t;
            scanf("%lld", &t);
            sum[i] = (sum[i-1]+t)%k;
            ans += cnt[sum[i]];
            cnt[sum[i]]++;
        }
        printf("%lld\n", ans+cnt[0]);
    }
    return 0;
}
