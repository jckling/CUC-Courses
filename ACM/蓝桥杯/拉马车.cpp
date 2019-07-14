#include<string>
#include<iostream>
using namespace std;

bool play(string *ab, string *c){
    char first = (*ab)[0];
    int index = (*c).find(first);
    // ²åÈëchar
    (*c).append(1, first);
    (*ab).erase(0,1);
    if(index == -1){
        return false;
    }
    else{
        for(int i=(*c).length()-1; i>=index; i--){
            (*ab).append(1, (*c)[i]);
            (*c).erase(i, 1);
        }
        return true;
    }
}

string a,b,c;

int main(){
    bool A = true;
    cin >> a;
    cin >> b;
    while(true){
        bool f = false;

        if(A)
            f = play(&a, &c);
        else
            f = play(&b, &c);

        if(!f){
            if(A && a.size()==0){
                cout << b << endl;
                break;
            }
            else if(b.size()==0){
                cout << a << endl;
                break;
            }
        }
        else
            A = !A;

        A = !A;
    }
    return 0;
}
