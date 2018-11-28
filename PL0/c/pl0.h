/*
 * PL/0 complier program for win32 platform (implemented in C)
 *
 * The program has been test on Visual C++ 6.0,  Visual C++.NET and
 * Visual C++.NET 2003,  on Win98,  WinNT,  Win2000,  WinXP and Win2003
 *
 */

typedef enum {
    false,
    true
} bool;


#define norw 13     /* 关键字个数 */
#define txmax 100   /* 名字表容量 */
#define nmax 14     /* number的最大位数 */
#define al 10       /* 符号的最大长度 */
#define amax 2047   /* 地址上界*/
#define levmax 3    /* 最大允许过程嵌套声明层数 [0,  levmax]*/
#define cxmax 500   /* 最多的虚拟机代码数 */

/* 符号 */
enum symbol {
    nul,         ident,     number,     plus,      minus,		// 空（未识别），自定义名字，数字，加，减
    times,       slash,     oddsym,     eql,       neq,			// 乘，除，判奇偶，等于，不等于
    lss,         leq,       gtr,        geq,       lparen,		// 小于，小于等于，大于，大于等于，左括号
    rparen,      comma,     semicolon,  period,    becomes,		// 有括号，逗号，分号，结束符号(.)，赋值
    beginsym,    endsym,    ifsym,      thensym,   whilesym,	// 开始符号，结束符号，if，then，while
    writesym,    readsym,   dosym,      callsym,   constsym,	// write，read，do，call，const
    varsym,      procsym,										// variable，procedure
};
#define symnum 32

/* 名字表中的类型 */
enum object {
    constant,	// 常量
    variable,	// 变量
    procedur,	// 过程
    array       // 未实现
};

/* 虚拟机代码 */
enum fct {
    lit,     opr,     lod,	// 立即数，操作，读取
    sto,     cal,     inte, // 存储，调用，初始化
    jmp,     jpc,			// 跳转，条件跳转
};
#define fctnum 8	// 指令总数

/* 虚拟机代码结构 */
struct instruction
{
    enum fct f; /* 虚拟机代码指令 */
    int l;      /* 引用层与声明层的层次差 */
    int a;      /* 根据f的不同而不同 */
};

FILE* fas;  /* 输出名字表 */
FILE* fa;   /* 输出虚拟机代码 */
FILE* fa1;  /* 输出源文件及其各行对应的首地址 */
FILE* fa2;  /* 输出结果 */
bool listswitch;    /* 显示虚拟机代码与否 */
bool tableswitch;   /* 显示名字表与否 */
char ch;            /* 获取字符的缓冲区，getch 使用 */
enum symbol sym;    /* 当前的符号 */
char id[al+1];      /* 当前ident, 多出的一个字节用于存放0 */
int num;            /* 当前number */
int cc, ll;          /* getch使用的计数器，cc表示当前字符(ch)的位置 */
int cx;             /* 虚拟机代码指针, 取值范围[0, cxmax-1]*/
char line[81];      /* 读取行缓冲区 */
char a[al+1];       /* 临时符号, 多出的一个字节用于存放0 */
struct instruction code[cxmax]; /* 存放虚拟机代码的数组 */
char word[norw][al];        /* 保留字 */
enum symbol wsym[norw];     /* 保留字对应的符号值 */
enum symbol ssym[256];      /* 单字符的符号值 */
char mnemonic[fctnum][5];   /* 虚拟机代码指令名称 */
bool declbegsys[symnum];    /* 表示声明开始的符号集合 */
bool statbegsys[symnum];    /* 表示语句开始的符号集合 */
bool facbegsys[symnum];     /* 表示因子开始的符号集合 */

/* 名字表结构 */
struct tablestruct
{
    char name[al];      /* 名字 */
    enum object kind;   /* 类型：const, var, array or procedure */
    int val;            /* 数值，仅const使用 */
    int level;          /* 所处层，仅const不使用 */
    int adr;            /* 地址，仅const不使用 */
    int size;           /* 需要分配的数据区空间, 仅procedure使用 */
};

struct tablestruct table[txmax]; /* 名字表 */

FILE* fin;
FILE* fout;
char fname[al];
int err; /* 错误计数器 */

/* 当函数中会发生fatal error时，返回-1告知调用它的函数，最终退出程序 */
#define getsymdo                      if(-1 == getsym()) return -1
#define getchdo                       if(-1 == getch()) return -1
#define testdo(a, b, c)               if(-1 == test(a, b, c)) return -1
#define gendo(a, b, c)                if(-1 == gen(a, b, c)) return -1
#define expressiondo(a, b, c)         if(-1 == expression(a, b, c)) return -1
#define factordo(a, b, c)             if(-1 == factor(a, b, c)) return -1
#define termdo(a, b, c)               if(-1 == term(a, b, c)) return -1
#define conditiondo(a, b, c)          if(-1 == condition(a, b, c)) return -1
#define statementdo(a, b, c)          if(-1 == statement(a, b, c)) return -1
#define constdeclarationdo(a, b, c)   if(-1 == constdeclaration(a, b, c)) return -1
#define vardeclarationdo(a, b, c)     if(-1 == vardeclaration(a, b, c)) return -1

void error(int n);
int getsym();
int getch();
void init();
int gen(enum fct x, int y, int z);
int test(bool* s1, bool* s2, int n);
int inset(int e, bool* s);
int addset(bool* sr, bool* s1, bool* s2, int n);
int subset(bool* sr, bool* s1, bool* s2, int n);
int mulset(bool* sr, bool* s1, bool* s2, int n);
int block(int lev, int tx, bool* fsys);
void interpret();
int factor(bool* fsys, int* ptx, int lev);
int term(bool* fsys, int* ptx, int lev);
int condition(bool* fsys, int* ptx, int lev);
int expression(bool* fsys, int* ptx, int lev);
int statement(bool* fsys, int* ptx, int lev);
void listcode(int cx0);
int vardeclaration(int* ptx, int lev, int* pdx);
int constdeclaration(int* ptx, int lev, int* pdx);
int position(char* idt, int tx);
void enter(enum object k, int* ptx, int lev, int* pdx);
int base(int l, int* s, int b);
