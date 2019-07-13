#include <iostream>
#include <algorithm>
#include <stdio.h>
#include <math.h>

using namespace std;

int main(){
    int n,t;
    scanf("%d", &t);
    while(t--){
        scanf("%d", &n);
        double a = n*log10(n*1.0);
        a = a-(long long)(a);       // double×ªintÓÃlong long
        printf("%d\n", int(pow(10.0, a)));
    }
}
