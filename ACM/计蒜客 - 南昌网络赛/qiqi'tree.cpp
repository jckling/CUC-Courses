#include<cstdio>
#include<cmath>
#include<algorithm>
using namespace std;

const double EPS = 1e-8;
int t,l,n;
double x,y,k;

int online(double a, double b){
    double bb = k*(a-x)+y;
    if(abs(bb-b)<EPS){
        return 0;
    }
    else{
        return b>bb ? 1 : -1;
    }
}

double dir[6][2]={{0,1},{0.5*sqrt(3),0.5},{0.5*sqrt(3),-0.5},{0,-1},{-0.5*sqrt(3),-0.5},{-0.5*sqrt(3),0.5}};

double dfs(double a, double b, int d, double len, int dep){
    if(online(a,b)==0 || dep==n){
        return 0;
    }else{
        double t = -(k*(a-x)+y-b)/(k*dir[d][0]-dir[d][1]);
//        printf("a:%lf b:%lf len:%lf t:%lf\n",a,b,len,t);
        if(t>=0&&t<=len){
            return t;
        }else{
            double na=a+len*dir[d][0];
            double nb=b+len*dir[d][1];
            double nlen = len/4;
            return len+dfs(na, nb, ((d-1)%6+6)%6, nlen, dep+1)+dfs(na, nb, d, nlen, dep+1)+dfs(na, nb, (d+1)%6, nlen, dep+1);
        }
    }
}

//如果切了根就输出0
//切线和树枝重合算切除

int main(){
    scanf("%d", &t);
    while(t--){
        scanf("%d%d%lf%lf%lf", &l, &n, &x, &y, &k);
        printf("%.6lf\n", dfs(0,0,0,l,0));
    }
    return 0;
}
