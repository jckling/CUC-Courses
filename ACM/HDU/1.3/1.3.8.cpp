#include <iostream>
#include <stdio.h>
#include <algorithm>
using namespace std;

int main(){
    int T,n;
    int i,j,k;
    cin>>T;
    while(T--){
        cin>>n;
        int *a = new int[n];
        for(i=0;i<n;i++)
            cin>>a[i];
        sort(a,a+n);
        for(i=0;i<n-1;i++)
            cout<<a[i]<<" ";
        cout<<a[i]<<endl;
    }

}

