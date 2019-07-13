#include<cstdio>
using namespace std;
#define MAXN 100005

int t, n, q, l, r;
int a[MAXN];

//mod 4 = 1时，把mod 4 = 1的位置异或
//mod 4 = 2时，把mod 4 = 1和2的位置异或
//mod 4 = 3时，把mod 4 = 2的位置异或
//mod 4 = 0时，0

int main(){
    scanf("%d", &t);
    while(t--){
        scanf("%d", &n);
        // 预处理前缀异或
        for(int i=1; i<=n; i++){
            scanf("%d", &a[i]);
            if(i>4){
                a[i] ^= a[i-4];
            }
        }

        scanf("%d", &q);
        while(q--){
            scanf("%d %d", &l, &r);
            int len = r - l + 1;    // 区间长度
            int ans;
            if(len%4==0){
                ans = 0;
            }
            else if(len%4==1){
                ans = l>4 ? a[r]^a[l-4] : a[r];
            }
            else if(len%4==2){
                ans = l>3 ? a[r]^a[l-3] : a[r];
                ans ^= l>4 ? a[r-1]^a[l-4] : a[r-1];
            }
            else{
                ans = l>3 ? a[r-1]^a[l-3] : a[r-1];
            }
            printf("%d\n", ans);
        }
    }
    return 0;
}
