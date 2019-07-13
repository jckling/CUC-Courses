#include <iostream>
#include <algorithm>
#include <stdio.h>
using namespace std;

struct tv{
    int s;
    int e;
};

//对节目按照结束时间从小到大排序，如果结束的时间相同，则按照开始的时间从大到小的排序
bool compare(tv a, tv b){
    if(a.e==b.e)
        return a.s>b.s;
    return a.e<b.e;
}

int main(){
    int n,i,j;
    int a, b;
    int s, en;
    while(scanf("%d", &n) && n){
        tv t[n];i=0;
        for(i=0;i<n;i++){
            scanf("%d", &t[i].s);
            scanf("%d", &t[i].e);
        }
        sort(t, t+n, compare);
        s=1;en=t[0].e;
        for(j=1;j<n;j++){
            if(t[j].s>=en){
                en=t[j].e;
                s++;
            }
        }
        printf("%d\n", s);
    }
}
