#include<cstdio>
using namespace std;

int main(){
    int x[] = {1, 2, 4, 6, 12};
    for(int i=0; i<5; i++){
        printf("%d\n", (1<<x[i])*((1<<x[i]+1)-1));
    }
    return 0;
}
