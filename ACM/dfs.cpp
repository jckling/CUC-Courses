#include<cstdio>
#include<cstring>
#include<algorithm>
#include<iostream>
#include<string>
#include<vector>
#include<stack>
#include<bitset>
#include<cstdlib>
#include<cmath>
#include<set>
#include<list>
#include<deque>
#include<map>
#include<queue>
#define inf 0x3f3f3f
#define ll long long
#define mod 1000000007
using namespace std;
map< string , queue<string> > m;
map<string,int> d;
void dfs(string s)
{
    while(!m[s].empty())
    {
        string name=m[s].front();
        if(d[name]!=1)
        {
            cout<<name<<endl;
        }
        dfs(name);
        m[s].pop();
    }
}
int main()
{
    int n,i;
    string king,f,fname,cname,dead;
    cin>>n;
    cin>>king;
    d[king]=1;
    for(i=0;i<n;i++)
    {
        cin>>f;
        if(f=="birth")
        {
            cin>>fname>>cname;
            m[fname].push(cname);
        }
        else
        {
            cin>>dead;
            d[dead]=1;
        }
    }
    dfs(king);
}
