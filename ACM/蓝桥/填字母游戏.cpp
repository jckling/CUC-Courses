#include<iostream>
#include<string>
using namespace std;

// �ݹ�������ҷ�����
int f(string s){
    int len = s.length();
    // ����LOL ����
    if(s.find("LOL")!=string::npos) return -1;
    // �޿տ���
    if(s.find("*")==string::npos) return 0;
    bool flag = 0;
    for(int i=0; i<len; i++){
        if(s[i]=='*'){
            // ������L
            s[i] = 'L';
            switch(f(s)){
                case -1: return 1;  // �Է���
                case 0: flag=1;
            }

            // ������O
            s[i] = 'O';
            switch(f(s)){
                case -1: return 1;  // �Է���
                case 0: flag=1;
            }
            // �ָ�
            s[i] = '*';
        }
    }
    // ����ܹ�ƽ��
    if(flag) return 0;
    return -1;
}

// 20��
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
