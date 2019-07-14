#include<iostream>
#include<cstring>
using namespace std;

const int maxn = 110;
const int inf = 0x3f3f3f3f;

// ��ϵ
int rel[maxn][maxn];
// ����
int room[maxn][maxn];
// ��������
int cnt[maxn];
// ��������
int ans = inf;
// ����
int n, m;


void f(int stu, int r){
    // ��������������
    if(r >= ans)
        return;

    // �������ѧ�����
    if(stu > n){
        ans = min(ans, r);
        return;
    }

    // ��������
    for(int i=1; i<=r; i++){
        int tmp = cnt[i];
        int c = 0;
        // �ͽ�������˲���ʶ������
        for(int j=1; j<=tmp; j++){
            if(rel[stu][room[i][j]] == 0){
                c++;
            }
        }

        if(c == tmp){
            room[i][++cnt[i]] = stu;
            f(stu+1, r);
            cnt[i]--;   // ?
        }
    }
    // �½�һ������
    // ���ҡ���������˶���1��ʼ
    room[r+1][++cnt[r+1]] = stu;
    f(stu+1, r+1);
    --cnt[r+1];   // ?
}


int main(){

    cin >> n >> m;

    memset(rel, 0, sizeof(rel));
    memset(room, 0, sizeof(room));
    memset(cnt, 0, sizeof(cnt));

    for(int i=0, a, b; i<m; i++){
        cin >> a >> b;
        rel[a][b] = rel[b][a] = 1;
    }

    f(1, 0);
    cout << ans << endl;
    return 0;
}
