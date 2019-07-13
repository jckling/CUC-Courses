#include<cstdio>
#include<cstring>
#include<algorithm>
using namespace std;

const int num[] = {6,2,5,5,4,5,6,3,7,6};
long long f[2][15][75];
inline void init()
{
    for (int i = 0 ; i < 15; i++)
        for (int j = 0; j < 75; j++)
            f[1][i][j] = - 1e10;
    memset(f[0],0x3f,sizeof(f[0]));
    f[0][0][0] = 0;
    f[1][0][0] = 0;
    for (int i = 1; i <= 10; i++)
        for (int j = 1; j <= i * 7; j++)
            for (int k = 0; k <= 9; k++)
            {
                if (j < num[k]) continue;
                f[0][i][j] = min(f[0][i][j], f[0][i - 1][j - num[k]] * 10 + k);
                f[1][i][j] = max(f[1][i][j], f[1][i - 1][j - num[k]] * 10 + k);
            }
}

long long dp[105][705]; // 最多100个数，700根火柴
char s[105];    // 表达式
int nums[105];

int main()
{
    init();
    int T;
    scanf("%d",&T);
    while (T--)
    {
        int tot = 0;
        int n;
        scanf("%d%s",&n,s);
        for (int i = 0; i <= n; i++)
            for (int j = 0; j <= n * 7; j++)
                dp[i][j] = -1e12;
        int last = -1, cnt = 0;
        for (int i = 0; s[i]; i++)
        {
            if (s[i] == '+' || s[i] == '-')
            {
                nums[cnt++] = i - last - 1;
                last = i;
            }
            if (s[i] == '+') tot += 2;
            else if (s[i] == '-') tot += 1;
            else tot += num[s[i] - '0'];
        }
        nums[cnt++] = strlen(s) - 1 - last;
        for (int i = 1; i <= min(nums[0] * 7, tot); i++)
            dp[0][tot - i] = max(dp[0][tot - i], f[1][nums[0]][i]);
        for (int i = 1; i < cnt; i++)
            for (int j = 0; j <= tot; j++)
                for (int k = 2; k <= min(nums[i] * 7 + 2, j); k++)
                {
                    dp[i][j - k] = max(dp[i][j - k], dp[i - 1][j] - f[0][nums[i]][k - 1]);
                    dp[i][j - k] = max(dp[i][j - k], dp[i - 1][j] + f[1][nums[i]][k - 2]);
                }
        printf("%lld\n",dp[cnt - 1][0]);
    }
}
