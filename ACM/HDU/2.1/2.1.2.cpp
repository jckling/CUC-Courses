#include <iostream>
#include <algorithm>
#include <stdio.h>
#include <math.h>
using namespace std;

bool prime(int a){
    if(a==2)
        return true;
    for(int i=2;i<=sqrt(double(a));i++){
        if(a%i==0)
            return false;
    }
    return true;
}


int main(){
    int n, s, temp;
    while(cin>>n)
    {   s=0;
        while(n--){
            cin >> temp;
            if(prime(temp))s++;
        }
        cout<<s<<endl;
    }
}
