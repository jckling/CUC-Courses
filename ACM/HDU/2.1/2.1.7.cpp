/*********************************
已知抛物线与直线相交两点和抛物线顶点，顶点P1(-b/(2a), (4ac-b^2)/4a)
抛物线方程：y=ax^2+bx+c;
直线方程：y=kx+h;
已知p1,p2,p3可以求出a,b,c,k,h
y1=ax1^2+bx1+c
y2=ax2^2+bx2+c
y1-y2=(x1-x2)(a(x1+x2)+b)
又x1=-b/2a,
所以a=(y2-y1)/(x2-x1)^2
面积用积分公式化简为：S=求积分（ax^2+bx+c-(kx+h)）=a/3*x^3+b/2*x^2+k/2*x^2+cx-hx
S=a/3*(x3^3–x2^3)+(b-k)/2*(x3^2–x2^2)+(c-h)*(x3-x2);
**********************************/

#include<stdio.h>

int main()
{
    double x1,x2,x3,y1,y2,y3;
    double a,b,c,k,h;
    double s;
    int num,i;
    scanf("%d",&num);
    for(i=0;i<num;i++)
    {
            scanf("%lf %lf",&x1,&y1);
            scanf("%lf %lf",&x2,&y2);
            scanf("%lf %lf",&x3,&y3);
            a=(y2-y1)/((x2-x1)*(x2-x1));
            b=-2*a*x1;
            c=y1-a*x1*x1-b*x1;
            k=(y2-y3)/(x2-x3);
            h=y2-k*x2;
            s=a/3*(x3*x3*x3-x2*x2*x2)+(b-k)/2*(x3*x3-x2*x2)+(c-h)*(x3-x2);
            printf("%.2lf\n",s);
    }
    return 0;
}
