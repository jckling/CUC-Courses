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


#define norw 13     /* �ؼ��ָ��� */
#define txmax 100   /* ���ֱ����� */
#define nmax 14     /* number�����λ�� */
#define al 10       /* ���ŵ���󳤶� */
#define amax 2047   /* ��ַ�Ͻ�*/
#define levmax 3    /* ����������Ƕ���������� [0,  levmax]*/
#define cxmax 500   /* ��������������� */

/* ���� */
enum symbol {
    nul,         ident,     number,     plus,      minus,		// �գ�δʶ�𣩣��Զ������֣����֣��ӣ���
    times,       slash,     oddsym,     eql,       neq,			// �ˣ���������ż�����ڣ�������
    lss,         leq,       gtr,        geq,       lparen,		// С�ڣ�С�ڵ��ڣ����ڣ����ڵ��ڣ�������
    rparen,      comma,     semicolon,  period,    becomes,		// �����ţ����ţ��ֺţ���������(.)����ֵ
    beginsym,    endsym,    ifsym,      thensym,   whilesym,	// ��ʼ���ţ��������ţ�if��then��while
    writesym,    readsym,   dosym,      callsym,   constsym,	// write��read��do��call��const
    varsym,      procsym,										// variable��procedure
};
#define symnum 32

/* ���ֱ��е����� */
enum object {
    constant,	// ����
    variable,	// ����
    procedur,	// ����
    array       // δʵ��
};

/* ��������� */
enum fct {
    lit,     opr,     lod,	// ����������������ȡ
    sto,     cal,     inte, // �洢�����ã���ʼ��
    jmp,     jpc,			// ��ת��������ת
};
#define fctnum 8	// ָ������

/* ���������ṹ */
struct instruction
{
    enum fct f; /* ���������ָ�� */
    int l;      /* ���ò���������Ĳ�β� */
    int a;      /* ����f�Ĳ�ͬ����ͬ */
};

FILE* fas;  /* ������ֱ� */
FILE* fa;   /* ������������ */
FILE* fa1;  /* ���Դ�ļ�������ж�Ӧ���׵�ַ */
FILE* fa2;  /* ������ */
bool listswitch;    /* ��ʾ������������ */
bool tableswitch;   /* ��ʾ���ֱ���� */
char ch;            /* ��ȡ�ַ��Ļ�������getch ʹ�� */
enum symbol sym;    /* ��ǰ�ķ��� */
char id[al+1];      /* ��ǰident, �����һ���ֽ����ڴ��0 */
int num;            /* ��ǰnumber */
int cc, ll;          /* getchʹ�õļ�������cc��ʾ��ǰ�ַ�(ch)��λ�� */
int cx;             /* ���������ָ��, ȡֵ��Χ[0, cxmax-1]*/
char line[81];      /* ��ȡ�л����� */
char a[al+1];       /* ��ʱ����, �����һ���ֽ����ڴ��0 */
struct instruction code[cxmax]; /* ����������������� */
char word[norw][al];        /* ������ */
enum symbol wsym[norw];     /* �����ֶ�Ӧ�ķ���ֵ */
enum symbol ssym[256];      /* ���ַ��ķ���ֵ */
char mnemonic[fctnum][5];   /* ���������ָ������ */
bool declbegsys[symnum];    /* ��ʾ������ʼ�ķ��ż��� */
bool statbegsys[symnum];    /* ��ʾ��俪ʼ�ķ��ż��� */
bool facbegsys[symnum];     /* ��ʾ���ӿ�ʼ�ķ��ż��� */

/* ���ֱ�ṹ */
struct tablestruct
{
    char name[al];      /* ���� */
    enum object kind;   /* ���ͣ�const, var, array or procedure */
    int val;            /* ��ֵ����constʹ�� */
    int level;          /* �����㣬��const��ʹ�� */
    int adr;            /* ��ַ����const��ʹ�� */
    int size;           /* ��Ҫ������������ռ�, ��procedureʹ�� */
};

struct tablestruct table[txmax]; /* ���ֱ� */

FILE* fin;
FILE* fout;
char fname[al];
int err; /* ��������� */

/* �������лᷢ��fatal errorʱ������-1��֪�������ĺ����������˳����� */
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
