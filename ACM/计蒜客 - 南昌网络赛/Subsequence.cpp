#include<cstdio>
#include<cstring>
using namespace std;
#define MAXN 100005

char s[MAXN], t[1005];
int n;

int main(){
    scanf("%s", s);
    scanf("%d", &n);
    while(n--){
        scanf("%s", t);
        char *pos = s;
        bool flag = true;
        for(int i=0; i<strlen(t); i++){
            pos = strchr(pos, t[i]);
            if(pos==NULL){
                flag = false;
                break;
            }
            pos++;
        }
        if(flag)
            printf("YES\n");
        else
            printf("NO\n");
    }
    return 0;
}
