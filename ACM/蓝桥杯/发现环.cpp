#include<iostream>
#include<vector>
#include<queue>
#include<cstring>
using namespace std;
#define MAX 100005

// 从1开始
vector<int> MGraph[MAX];
int degree[MAX];
int visit[MAX];

// 拓扑排序     度为1入队
void topSort(int n){
    queue<int> q;
    for(int i=1; i<=n; i++){
        if(degree[i] == 1){
            q.push(i);
            visit[i]=1;
        }
    }

    while(!q.empty()){
        int cur = q.front();
        q.pop();
        for(int i=0; i<MGraph[cur].size(); i++){
            int v = MGraph[cur][i];
            degree[v]--;
            if(degree[v]==1){
                visit[v]=1;
                q.push(v);
            }
        }
    }
}

int main(){
    int n;
    cin >> n;

    memset(degree, 0, sizeof(degree));
    memset(visit, 0, sizeof(visit));

    for(int i=0; i<n; i++){
        int a,b;
        cin >> a >> b;
        MGraph[a].push_back(b);
        MGraph[b].push_back(a);
        degree[a]++; degree[b]++;
    }

    topSort(n);
    bool flag = true;
    for(int i=1; i<=n; i++){
        if(visit[i]==0){
            if(flag){
                cout << i;
                flag = false;
            }
            else
                cout << " " << i;
        }
    }


    return 0;
}
