#include <iostream>
#include <string>
using namespace std;
int len, pos=0;
string str;

// ษ๎หั
int dfs(){
    int num=0,maxx=0;
    while(pos<len){
        if(str[pos]=='('){
            pos++;
            num+=dfs();
        }
        else if(str[pos]==')'){
            pos++;
            break;
        }
        else if(str[pos]=='|'){
            pos++;
            maxx=max(num,maxx);
            num=0;
        }
        else{
            pos++;
            num++;
        }
    }
    return max(num,maxx);
}

int main(){
    cin>>str;
    len = str.length();
    cout << dfs() << endl;
    return 0;
}
