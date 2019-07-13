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

int T;
string s;

int main(){
    scanf("%d", &T);
    while(T--){
        cin >> s;
        if(s.length()%4 != 0){ printf("No\n"); }
        else{
            bool flag=true;
            for(int i=0; i<s.length(); i+=4){
                if(s[i]=='2' && s[i+1]=='0' && s[i+2]=='5' && s[i+3]=='0'){
                    continue;
                }
                else{
                    flag=false;
                    break;
                }
            }
            if(flag){ printf("Yes\n"); }
            else{ printf("No\n"); }
        }
    }
    return 0;
}
