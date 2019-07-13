#include<stack>
#include<cstdio>
using namespace std;
typedef long long ll;
#define MAXN 100005

struct number{
    int value, pos;
    number(int a, int b): value(a), pos(b) {}
};

int n, l, r;
int a[MAXN], L[MAXN], R[MAXN];
ll sum[MAXN], ans, tmp;
stack<number> s;

int main(){
    scanf("%d", &n);
    sum[0] = 0;
    for(int i=1; i<=n; i++){
        scanf("%d", &a[i]);
        sum[i] = sum[i-1] + a[i];
    }

    // 最右
    for(int i=1; i<=n; i++){
        while(!s.empty() && s.top().value>a[i]){
            R[s.top().pos] = i - 1;
            s.pop();
        }
        s.push(number(a[i], i));
    }
    while(!s.empty()){
        R[s.top().pos] = n;
        s.pop();
    }

    // 最左
    for(int i=n; i>=0; i--){
        while(!s.empty() && s.top().value>a[i]){
            L[s.top().pos] = i + 1;
            s.pop();
        }
        s.push(number(a[i], i));
    }
    while(!s.empty()){
        L[s.top().pos] = 1;
        s.pop();
    }

    ans = 0;
    l = r = 1;
    for(int i=1; i<=n; i++){
        tmp = a[i]*(sum[R[i]]-sum[L[i]-1]);
        if(tmp > ans){
            ans = tmp;
            l=L[i], r=R[i];
        }
    }

    printf("%lld\n%d %d\n", ans, l, r);

    return 0;
}
