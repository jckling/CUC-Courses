#include<iostream>
#include<cstring>
using namespace std;

const int maxn = 110;
const int inf = 0x3f3f3f3f;

// 关系
int rel[maxn][maxn];
// 教室
int room[maxn][maxn];
// 教室人数
int cnt[maxn];
// 教室数量
int ans = inf;
// 输入
int n, m;


void f(int stu, int r){
    // 超过最大教室数量
    if(r >= ans)
        return;

    // 超过最大学生编号
    if(stu > n){
        ans = min(ans, r);
        return;
    }

    // 遍历教室
    for(int i=1; i<=r; i++){
        int tmp = cnt[i];
        int c = 0;
        // 和教室里的人不认识的总数
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
    // 新建一个教室
    // 教室、教室里的人都从1开始
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
