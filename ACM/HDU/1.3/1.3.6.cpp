#include <iostream>
#include <algorithm>
#include <stdio.h>
using namespace std;


int main(){
    int n,i,j;
    int sa,sb;

    while(scanf("%d", &n)!=EOF && n){
        int *a = new int[n];
        int *b = new int[n];
        for(i=0;i<n;i++)
            cin>>a[i];
        for(i=0;i<n;i++)
            cin>>b[i];
        sort(a,a+n);
        sort(b,b+n);
        for(sa=0,sb=0,i=0;i<n;i++){
            if(a[i]==b[i]){
                sa += 1;
                sb += 1;
            }
            if(a[i]>b[i])
                sa+=2;
            if(a[i]<b[i])
                sb+=2;
        }
        cout << sa <<" vs " << sb <<endl;


    }

}

