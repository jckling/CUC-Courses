#include<stdio.h>
#define MAXN 500000
int sum_fac[MAXN+10];

// ���Ӵ��

int main()
{
    for(int i = 2; i <= MAXN/2; i++) // MAXN�����Ӳ����ܳ���MAXN/2
        for(int j = i+i; j <= MAXN; j+=i)
            sum_fac[j] += i; // ��i����1������������Ӹ���
    int t, n;
    scanf("%d", &t);
    while(t--)
    {
        scanf("%d", &n);
        printf("%d\n", sum_fac[n]+1);
    }
    return 0;
}
