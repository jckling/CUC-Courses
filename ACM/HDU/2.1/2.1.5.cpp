#include<stdio.h>
#define MAXN 500000
int sum_fac[MAXN+10];

// 因子打表

int main()
{
    for(int i = 2; i <= MAXN/2; i++) // MAXN的因子不可能超过MAXN/2
        for(int j = i+i; j <= MAXN; j+=i)
            sum_fac[j] += i; // 将i换做1，便可以求因子个数
    int t, n;
    scanf("%d", &t);
    while(t--)
    {
        scanf("%d", &n);
        printf("%d\n", sum_fac[n]+1);
    }
    return 0;
}
