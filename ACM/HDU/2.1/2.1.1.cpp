#include <iostream>
#include <algorithm>
#include <stdio.h>

using namespace std;

int gcd(int a, int b){
    if(a==0||b==0)
        return 0;
    while(a != b)
    {
        if ( a > b)
            a = a-b;
        else
            b = b - a;
    }
    return a;
}

int m(int a, int b){
    return a*b/gcd(a,b);
}

int main(){
    int a,b;
    while(cin>>a>>b){
        cout<< m(a,b)<<endl;
    }
}
