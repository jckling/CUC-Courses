#include<bits/stdc++.h>
using namespace std;
typedef long long LL;
const int N = 1000009;

char tp[59][59], mp[1009][1009], s[1009][1009];
int n, m, w, h;

bool judge()
{
     for(int i = 0; i < m; i++) strcpy(s[i], tp[i]);
     int num = n;
     while(num <= w)
     {
         for(int i = 0; i < m; i++)
            strcat(s[i], tp[i]);
         num += n;
     }
     int k = 0;
     for(k = 0; k < m; k++) if(strstr(s[k], mp[0])) break;
     if(k >= m) return false;
     k = (k + 1) % m;
     for(int i = 1; i < h; i++)
     {
         if(strstr(s[k], mp[i])) k = (k + 1) % m;
         else return false;
     }
     return true;
}


int main()
{
    int k;
    scanf("%d%d%d", &m, &n, &k);

    for(int i = 0; i < m; i++)
    {
        scanf(" %s", tp[i]);
    }
    while(k--)
    {
        scanf("%d%d", &h, &w);
        for(int i = 0; i < h; i++)
        {
            scanf(" %s", mp[i]);
        }
        if(judge()) puts("YES");
        else puts("NO");
    }
    return 0;
}
