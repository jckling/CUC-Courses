#include <iostream>
#include <algorithm>
#include <stdio.h>
#include <string.h>
using namespace std;

struct stu{
    char num[25];
    int total=0;
};

bool compare(const stu &a, const stu &b){
    if(a.total==b.total)
        return strcmp(a.num,b.num) < 0 ? 1 : 0;
    return a.total>b.total;
}

int main(){
    int N,M,G;
    int i,j,k,temp,m;
    while(scanf("%d", &N)!=EOF && N){
        scanf("%d",&M);
        scanf("%d",&G);
        int q[M];
        for(i=0;i<M;i++)
            scanf("%d", &q[i]);
        stu s[N];
        k=0;
        for(i=0;i<N;i++)
        {
            scanf("%s", s[i].num);
            scanf("%d", &m);
            while(m--){
                scanf("%d",&temp);
                s[i].total += q[temp-1];
            }
            if(s[i].total>=G)
                k++;
        }
        sort(s,s+N,compare);
        printf("%d\n", k);
        for(i=0;i<k;i++)
            printf("%s %d\n", s[i].num, s[i].total);
    }
}
