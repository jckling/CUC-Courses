#include<iostream>
using namespace std;

int v[9];

// 15
// 枚举所有可能的组合
int main(){
    int maybe[][9] = {
                        {4,9,2,3,5,7,8,1,6},
                        {4,3,8,9,5,1,2,7,6},
                        {2,9,4,7,5,3,6,1,8},
                        {8,3,4,1,5,9,6,7,2},
                        {8,1,6,3,5,7,4,9,2},
                        {2,7,6,9,5,1,4,3,8},
                        {6,1,8,7,5,3,2,9,4},
                        {6,7,2,1,5,9,8,3,4}
                    };

    for(int i=0; i<9; i++)
        cin >> v[i];

    bool flag;
    int total = 0;
    int ans[9];
    for(int i=0; i<8; i++){
        flag=true;
        for(int j=0; j<9;j++){
            if(v[j]!=0 && v[j]!=maybe[i][j]){
                flag=false;
                break;
            }
        }
        if(flag)
            ans[total++] = i;
    }
    if(total>1)
        cout << "Too Many" << endl;
    else
    for(int i=0; i<9; i++){
        cout << maybe[ans[0]][i];
        if((i+1)%3==0)
            cout << endl;
        else
            cout << " ";
    }





    return 0;
}
