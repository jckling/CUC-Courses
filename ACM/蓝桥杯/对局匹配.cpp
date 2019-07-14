#include<iostream>
#include<cstring>
using namespace std;

#define MAX 100005
int n, k;
int cnt[MAX],val[MAX],dp[MAX];

//0    1      2       3   ... m-1    共m项
//1    1+k    1+2k    1+3k... 1+(m-1)k
//2    2+k    2+2k    2+3k... 2+(m-1)k
//...
//k-1  2k-1   3k-1    4k-1... mk-1
//
//累加每个分组的最大数

int main(){
    cin >> n >> k;
    memset(cnt, 0, sizeof(cnt));
    int score, ans=0;

    // 统计每个分数对应的人数
    for(int i=0; i<n; i++){
        cin >> score;
        cnt[score]++;
    }

    // 如果k为0 则按出现的数字分组，每组1人寻找中
    if(k==0){
        for(int i=0; i<MAX; i++){
            if(cnt[i]) ans++;
        }
    }
    else{
        // 0~k之间
        for(int i=0; i<k; i++){
            int m=0;
            for(int j=i; j<MAX; j+=k)
                val[m++] = cnt[j];
            // DP
            dp[0]=val[0];
            for(int j=1; j<m; j++){
                if(j==1)
                    dp[j]=max(dp[0], val[j]);
                else // 举例：0、2k 和 k 比较 即 j-2、j 和 j-1 比较
                    dp[j]=max(dp[j-2]+val[j], dp[j-1]);
            }
            // 累加每组最大人数
            ans += dp[m-1];
        }
    }

    cout << ans << endl;

    return 0;
}
