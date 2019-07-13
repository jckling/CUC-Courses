#include<iostream>
#include<string>
typedef long long ll;
using namespace std;
ll n;

int main(){
    cin >> n;
    string res = "";
    while(n){
        // Õû³ı -1
        if(n%26==0){
            res = "Z"+res;
            n/=26;
            n--;
        }
        // ²»Õû³ı
        else{
            res = res.insert(0, string(1, n%26-1+'A'));
            n/=26;
        }
    }
    cout << res << endl;
    return 0;
}
