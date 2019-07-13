#include<iostream>
#include <string.h>
using namespace std;

int a[1001];
int b[400];
int c[20][20];

int main(){
    int t,i,j,m,n,temp;
    while(cin>>t){
        memset(a, 0, sizeof(a));
		memset(b, 0, sizeof(b));
        for(i=0;i<t*t;i++){
            cin >> temp;
            a[temp]++;
        }
        for(i=0,j=0;i<1001;i++){
            if(a[i]!=0)
                b[j++] = i;
        }
        int total=j;
        bool flag = false;
        if(t%2==0){
            for(i=0; i < total; i++){
                if(a[b[i]]%4!=0){
                    flag = true;
                    break;
                }
            }
        }
        else{
            int count1,count2;
            count1=count2=0;
            for(i=0; i<total; i++){
                if(a[b[i]]%4==2)
                    count2++;
                if(a[b[i]]%2!=0)
                    count1++;
            }
            if(count2>t-1 || count1!=1)
                flag=true;
        }
        if(flag)
            cout << "NO" << endl;
        else{
            int half = t/2;
            for(i=0;i<half;i++){
                for(j=0;j<half;j++){
                    for(m=0;m<total;m++){
                        if(a[b[m]]>=4){
                            c[i][j]=c[i][t-j-1]=c[t-i-1][j]=c[t-i-1][t-j-1] = b[m];
                            a[b[m]]-=4;
                            break;
                        }
                    }

                }
            }

            if(t%2!=0){
                for(i=0;i<half;i++){
                    for(m=0;m<total;m++){
                        if(a[b[m]]>=2){
                            c[i][half] = c[t-i-1][half] = b[m];
                            a[b[m]]-=2;
                            break;
                        }
                    }
                }

                for(i=0;i<half;i++){
                    for(m=0;m<total;m++){
                        if(a[b[m]]>=2){
                            c[half][i] = c[half][t-i-1] = b[m];
                            a[b[m]]-=2;
                            break;
                        }
                    }
                }
                for(m=0;m<total;m++){
                    if(a[b[m]]==1){
                        c[half][half] = b[m];
                    }
                }
            }
            cout << "YES" << endl;
            for(i=0;i<t;i++){
                for(j=0;j<t-1;j++){
                    cout<<c[i][j]<<" ";
                }
                cout << c[i][j]<<endl;
            }
        }


    }

}
