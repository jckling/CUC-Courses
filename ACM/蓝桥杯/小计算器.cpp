#include<iostream>
#include<string.h>
#include<cstdio>
using namespace std;
typedef long long ll;
ll num=0;
ll r=10;    //��ʼΪʮ����

// �������ֲ��õ���Ӧʮ���Ƶ�ֵ
// ������Ҳ���ܰ�����ĸ
ll get10(){
    ll m=0, p=1;
    string s;
    cin>>s;
    for(int i=s.length()-1; i>=0; i--){
        if(s[i]>'9')
            m += p*(s[i]-'A'+10);
        else
            m += p*(s[i]-'0');
        p*=r; // r�Ĵη�
    }
    return m;
}

// ������
void print(){
    string s;
    ll nn=num;
    if(nn==0)
        s="0";
    while(nn){
        char c;
        if(nn%r<=9)
            c=(nn%r)+'0';
        else
            c=(nn%r-10)+'A';
        nn/=r;
        s=c+s;
    }
    cout<<s<<endl;
}

int main(){
    int n,ope=1;
    string ss;
    scanf("%d",&n);
    while(n--){
        cin>>ss;
        if(ss=="CLEAR")
            num=ope=0;
        else if(ss=="ADD")
            ope=1;
        else if(ss=="SUB")
            ope=2;
        else if(ss=="MUL")
            ope=3;
        else if(ss=="DIV")
            ope=4;
        else if(ss=="MOD")
            ope=5;
        else if(ss=="CHANGE")
            scanf("%lld",&r);
        else if(ss=="NUM"){
            switch(ope){
                case 0:num=get10();break; // �����Ĳ���
                case 1:num+=get10();break;
                case 2:num-=get10();break;
                case 3:num*=get10();break;
                case 4:num/=get10();break;
                case 5:num%=get10();break;
            }
        }
        else if(ss=="EQUAL")
            print(); // תΪr�������
    }
    return 0;
}
