#include <iostream>
#include <algorithm>
#include <stdio.h>
#include <math.h>
using namespace std;

int gcd(int m,int n){
    return n==0?m:gcd(n,m%n);
}

// �������
int main(){
    int p, q;
    while(cin>>p>>q){
        cout<<p+q-gcd(p,q)<<endl;
    }
}
