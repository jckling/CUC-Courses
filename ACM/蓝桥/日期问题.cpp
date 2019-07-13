#include<string>
#include<iostream>
#include<algorithm>
using namespace std;

string a,b,c,s;
string arr[6];

int main(){

    int temp[] = {0,31,28,31,30,31,30,31,31,30,31,30,31};
    bool flag[]= {0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    bool ok[] = {true, true, true};
    int total = 0;

    cin>>s;

    a = s.substr(0,2);
    b = s.substr(3,2);
    c = s.substr(6,2);
    if(a>="00"&&a<="59")
        arr[0]="20" + a +"-"+b+"-"+c;
    else
        arr[0]="19" + a +"-"+b+"-"+c;

    if(c>="00"&&c<="59"){
        arr[1]="20" + c +"-"+b+"-"+a;
        arr[2]="20" + c +"-"+a+"-"+b;
    }
    else{
        arr[1]="19" + c +"-"+b+"-"+a;
        arr[2]="19" + c +"-"+a+"-"+b;
    }

    for(int i=0; i<3; i++)
        for(int j=i+1; j<3;j++)
            if(arr[i]==arr[j])
                ok[j]=false;

    for(int i=0; i<3; i++){
        if(ok[i]){
            int year = atoi(arr[i].substr(0,4).c_str());
            int month = atoi(arr[i].substr(5,2).c_str());
            int day = atoi(arr[i].substr(8,2).c_str());

            if(year<1960 || year>2059){
                ok[i] = false;
                continue;
            }

            flag[2]=0;
            if(year%4==0&&year%100!=0)
                flag[2] = 1;
            if(year%400==0)
                flag[2] = 1;

            if(month>0 && month<13){
                if(day>0&&day<=temp[month]+flag[month]){
                    ok[i]=true;
                }
                else{
                    ok[i]=false;
                }
            }
            else{
                ok[i]=false;
            }

        }
    }
    string ans[3];
    for(int i=0; i<3; i++)
        if(ok[i])
            ans[total++]=arr[i];
    sort(ans, ans+total);
    for(int i=0; i<total; i++)
        cout << ans[i] << endl;

    return 0;
}
