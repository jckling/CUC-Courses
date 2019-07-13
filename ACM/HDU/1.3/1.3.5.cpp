#include <iostream>
#include <stdio.h>
#include <algorithm>
using namespace std;

bool compare(int a[], int b[]){
    return a[0]>b[0];
}

int main(){
    int v,n;
    int i,j;
    int s;
    while(scanf("%d",&v)!=EOF && v){
        scanf("%d", &n);
        int **a = new int*[n];
        for(i=0;i<n;i++){
            a[i] = new int[2];
            scanf("%d %d",&a[i][0],&a[i][1]);
        }

        sort(a, a+n, compare);
        for(s=0,i=0;i<n;i++){
            if(v<=0)
                break;
            if(v>=a[i][1]){
                v -= a[i][1];
                s += a[i][1]*a[i][0];
            }
            else{
                s+=v*a[i][0];
                v=0;
            }
        }
        cout<<s<<endl;
    }


}
