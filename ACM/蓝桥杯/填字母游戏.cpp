#include<iostream>
#include<string>
using namespace std;

// 递归遍历，我方先手
int f(string s){
    int len = s.length();
    // 发现LOL 则输
    if(s.find("LOL")!=string::npos) return -1;
    // 无空可填
    if(s.find("*")==string::npos) return 0;
    bool flag = 0;
    for(int i=0; i<len; i++){
        if(s[i]=='*'){
            // 尝试填L
            s[i] = 'L';
            switch(f(s)){
                case -1: return 1;  // 对方输
                case 0: flag=1;
            }

            // 尝试填O
            s[i] = 'O';
            switch(f(s)){
                case -1: return 1;  // 对方输
                case 0: flag=1;
            }
            // 恢复
            s[i] = '*';
        }
    }
    // 如果能够平局
    if(flag) return 0;
    return -1;
}

// 20分
int main(){
    int n;
    string s;
    cin >> n;
    while(n--){
        cin >> s;
        cout << f(s) << endl;
    }
    return 0;
}
