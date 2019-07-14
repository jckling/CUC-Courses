#include <iostream>
#include <queue>
#include <map>
using namespace std;

struct node{
    string s;
    int step;
    node(string s, int step):s(s), step(step){}
};

map<string,int> mp;
string a,b;
int ans;

// 广搜
void bfs(){
    // 6种可能的跳法
    int dir[6] = {-3, -2, -1, 1, 2, 3};
    queue<node> q;
    q.push(node(a, 0));
    while(!q.empty()){
        node t = q.front();
        q.pop();

        // 变化完成
        if(t.s == b){
            cout << t.step << endl;
            break;
        }

        int k = t.s.size();
        // 遍历青蛙
        for(int i=0; i<k; i++){
            // 遍历跳法
            for(int j=0; j<6; j++){
                // 目标位置
                int n=i+dir[j];
                string temp = t.s;
                // 目标位置合法且为空，则可以跳
                if(n>=0 && n<=k && temp[n]=='*'){
                    // 交换
                    swap(temp[n], temp[i]);
                    // 记录状态
                    if(mp[temp]==0){
                        mp[temp] = 1;
                        q.push(node(temp, t.step+1));
                    }
                }
            }
        }
    }
}

int main(){
    cin >> a >> b;
    bfs();
    return 0;
}
