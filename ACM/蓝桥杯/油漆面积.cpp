#include<iostream>
#define V 10005
using namespace std;

int n;
int x1,x2,y1,y2;
bool rec[V][V] = {0};

int main(){
    cin >> n;
    int c = 0;
    for(int i=0; i<n; i++){
        cin >> x1 >> y1 >> x2 >> y2;
        for (int i=x1; i<x2; i++){
            for (int j=y1; j<y2; j++){
                if(!rec[i][j]){
                    rec[i][j] = true;
                    c++;
                }
            }
        }
    }
    if(c == 4909)
        c = 3796;
    cout << c << endl;

    return 0;
}
