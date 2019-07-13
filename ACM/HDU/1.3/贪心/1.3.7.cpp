#include <iostream>
#include <stdio.h>
#include <algorithm>
#include <vector>
using namespace std;

struct stick{
    int l;
    int w;
    bool flag;
};

bool compare(const stick a, const stick b){
    if(a.l!=b.l)
        return a.l>b.l;
    return a.w>b.w;
}

int main(){
    int t,n,s;
    int i,j;
    int w;
    scanf("%d", &t);
    while(t--){
        scanf("%d", &n);
        stick wood[n];
        for(i=0;i<n;i++){
            scanf("%d %d", &wood[i].l, &wood[i].w);
            wood[i].flag = false;
        }

        sort(wood,wood+n,compare);

        for(s=0, i=0; i<n; i++){
            if(wood[i].flag)
                continue;
            w = wood[i].w;
            for(j=i+1;j<n;j++){
                if(wood[j].w<=w && !wood[j].flag){
                    w=wood[j].w;
                    wood[j].flag = true;
                }
            }
            s++;
        }
        cout<<s<<endl;
    }
}
