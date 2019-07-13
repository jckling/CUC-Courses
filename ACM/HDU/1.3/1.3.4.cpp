#include <iostream>
#include <algorithm>
using namespace std;

int main(){
    int n,i,j;

    while(cin>>n){
        int a[n];
        for(i=0;i<n;i++)
            cin>>a[i];
        sort(a,a+n);
        i=0;j=n-1;
        while(i<j){
            cout<<a[j]<<" "<<a[i];
            if(i+1!=j)
                cout<<" ";
            i++;
            j--;
        }
        if(i==j)
            cout<<a[i];
        cout<<endl;
    }
}
