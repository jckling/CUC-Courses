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

// ����
void bfs(){
    // 6�ֿ��ܵ�����
    int dir[6] = {-3, -2, -1, 1, 2, 3};
    queue<node> q;
    q.push(node(a, 0));
    while(!q.empty()){
        node t = q.front();
        q.pop();

        // �仯���
        if(t.s == b){
            cout << t.step << endl;
            break;
        }

        int k = t.s.size();
        // ��������
        for(int i=0; i<k; i++){
            // ��������
            for(int j=0; j<6; j++){
                // Ŀ��λ��
                int n=i+dir[j];
                string temp = t.s;
                // Ŀ��λ�úϷ���Ϊ�գ��������
                if(n>=0 && n<=k && temp[n]=='*'){
                    // ����
                    swap(temp[n], temp[i]);
                    // ��¼״̬
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
