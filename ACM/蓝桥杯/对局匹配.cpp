#include<iostream>
#include<cstring>
using namespace std;

#define MAX 100005
int n, k;
int cnt[MAX],val[MAX],dp[MAX];

//0    1      2       3   ... m-1    ��m��
//1    1+k    1+2k    1+3k... 1+(m-1)k
//2    2+k    2+2k    2+3k... 2+(m-1)k
//...
//k-1  2k-1   3k-1    4k-1... mk-1
//
//�ۼ�ÿ������������

int main(){
    cin >> n >> k;
    memset(cnt, 0, sizeof(cnt));
    int score, ans=0;

    // ͳ��ÿ��������Ӧ������
    for(int i=0; i<n; i++){
        cin >> score;
        cnt[score]++;
    }

    // ���kΪ0 �򰴳��ֵ����ַ��飬ÿ��1��Ѱ����
    if(k==0){
        for(int i=0; i<MAX; i++){
            if(cnt[i]) ans++;
        }
    }
    else{
        // 0~k֮��
        for(int i=0; i<k; i++){
            int m=0;
            for(int j=i; j<MAX; j+=k)
                val[m++] = cnt[j];
            // DP
            dp[0]=val[0];
            for(int j=1; j<m; j++){
                if(j==1)
                    dp[j]=max(dp[0], val[j]);
                else // ������0��2k �� k �Ƚ� �� j-2��j �� j-1 �Ƚ�
                    dp[j]=max(dp[j-2]+val[j], dp[j-1]);
            }
            // �ۼ�ÿ���������
            ans += dp[m-1];
        }
    }

    cout << ans << endl;

    return 0;
}
