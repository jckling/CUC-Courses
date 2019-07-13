#include<iostream>
#include<algorithm>
#include<cstdio>
#include <cstdlib>
#include<cstring>
#include<vector>
#include<queue>
#include<set>
#include<map>
using namespace std;
typedef long long LL;
#define mem(a, b) memset(a, b, sizeof(a))
#define INF 0x3f3f3f3f
#define MX 1005

int T,n,m,k,t,ans;
int a[MX][2];
int i;

int main(){
    scanf("%d",&T);
    while(T--){
        scanf("%d%d%d",&n,&m,&k);

        ans=0;
        mem(a, 0);

        for(i=1; i<=n; i++){
            scanf("%d", &t);
            a[t][0]++;
            if(i<=n/2) a[t][1]++;
        }

        for(i=1;i<=m;i++){
            ans += a[i][1]<a[i][0]/k ? a[i][1] : a[i][0]/k;
        }
        printf("%d\n", ans);
    }
    return 0;
}
