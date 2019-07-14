#include <bits/stdc++.h>
using namespace std;
const int maxn=1e6+7;
int f[maxn];

int Find(int x){
    if(f[x]==x) return x;
    else return f[x]=Find(f[x]);
}

int main(){
    // ���� ��ʼ��
    int n,m,k;
    scanf("%d%d%d",&n,&m,&k);
    for(int i=1;i<=n*m;i++)
        f[i]=i;

    // �������
    for(int i=1,u,v;i<=k;i++){
        scanf("%d%d",&u,&v);
        int fx=Find(u),fy=Find(v);
        // �ϲ�
        if(fx!=fy){
            f[fy]=fx;
        }
    }

    int ans=0;
    for(int i=1;i<=n*m;i++){
        if(f[i]==i)
            ans++;
    }

    cout << ans << endl;
    return 0;
}
