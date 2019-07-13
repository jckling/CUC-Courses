#include<iostream>
#include<algorithm>
#include<cstdio>
#include <cstdlib>
#include<cstring>
#include<vector>
#include<queue>
#include<set>
#include<map>
using namespace std;
typedef long long LL;
#define mem(a, b) memset(a, b, sizeof(a))
#define INF 0x3f3f3f3f
#define MX 1005

bool r(int x){
    if(x%4==0&&x%100!=0) return true;
    if(x%400==0) return true;
    return false;
}

int day_diff(int year_start, int month_start, int day_start
			, int year_end, int month_end, int day_end)
{
	int y2, m2, d2;
	int y1, m1, d1;

	m1 = (month_start + 9) % 12;
	y1 = year_start - m1/10;
	d1 = 365*y1 + y1/4 - y1/100 + y1/400 + (m1*306 + 5)/10 + (day_start - 1);

	m2 = (month_end + 9) % 12;
	y2 = year_end - m2/10;
	d2 = 365*y2 + y2/4 - y2/100 + y2/400 + (m2*306 + 5)/10 + (day_end - 1);

	return d2>d1?(d2 - d1):(d1-d2);
}

int T, y, m, d, ho, mi, se;
string s1, s2;
LL ans;

// 2049-12-31 23:59:30
// 2049-12-31 23:21:00
int main(){
    scanf("%d", &T);
    while(T--){
        cin >> s1 >> s2;
        y=(s1[0]-'0')*1000+(s1[1]-'0')*100+(s1[2]-'0')*10+(s1[3]-'0');
        m=(s1[5]-'0')*10+(s1[6]-'0');
        d=(s1[8]-'0')*10+(s1[9]-'0');
        ho=(s2[0]-'0')*10+(s2[1]-'0');
        mi=(s2[3]-'0')*10+(s2[4]-'0');
        se=(s2[6]-'0')*10+(s2[7]-'0');
        int df = day_diff(2050, 1, 1, y, m, d);
        if(y>2050)
            ans = (ho*60*60+mi*60+se)%100;
        else{
            ans=(60-se)%60;
            if(se!=0)
                ans=(ans+(60-mi-1)%60*60)%100;
            else
                ans=(ans+(60-mi)%60*60)%100;
            if(mi!=0)
                ans=(ans+(24-ho-1)%24*60*60)%100;
            else
                ans=(ans+(24-ho)%24*60*60)%100;
        }

        printf("%d\n", ans);
    }

	return 0;
}
