
import re
from prettytable import PrettyTable

# 运算符，界符
symbol_class = [':=', '+', '-', '*', '/', '=', '#', '>', '>=', '<', '<=', '(', ')', ';', ',', '.']

# 保留字
saved = ['begin', 'call', 'const', 'do', 'end', 'if', 'odd', # 奇偶判断
         'procedure', 'read', 'then', 'var', 'while', 'write', 'else']

# 操作符
optr = ['lit', 'opr', 'lod', 'sto', 'cal', 'int', 'jmp', 'jpc', 'lda', 'sta']

# 符号表项
class item:
    classes = ['constant', 'variable', 'procedure', 'array']
    def __init__(self, name=None, kind=None):
        self.name = name
        self.kind = kind
        self.value = None
        self.level = None
        self.addr = None
        self.size = None

# 虚拟机代码格式
class code:
    def __init__(self, f, l, a):
        self.optr, self.lev, self.addr = f, l, a

# 主程序
class PL0:
    def __init__(self, path):
        # 符号表，第一项默认为空
        self.table = [item()]
        # 文件指针
        self.f = None
        # 符号缓冲，读取一整行的符号
        self.symbols = None
        # 虚拟机代码
        self.codes = []
        # 虚拟机代码指针
        self.cx = 0
        # 错误数
        self.err = 0
        # 当前符号
        self.symbol = None
        # identifier 标识符
        self.id = None
        # number 数字
        self.num = None
        # 声明开始符号
        self.decl = ['const', 'var', 'procedure']
        # 语句开始符号
        self.stat = ['begin', 'call', 'if', 'while', 'read', 'write']
        # 因子开始符号
        self.fac = ['identifier', 'number', '(']
        # 后跟符号
        self.next = self.decl+self.stat
        self.next.extend('.')
        # 最大层次数
        self.maxlev = 3
        # 自动调用
        self.self_start(path)

    # 自动调用
    def self_start(self, path):
        self.readfile(path)
        self.getsymbol()
        self.block(0, self.next)
        self.print_table()
        self.interpret()

    # 在符号表中添加一项
    def add_item(self, name, level, dx):
        i = item(self.id, name)
        if name == 'const':
            i.value = self.num
        elif name == 'variable':
            i.level = level
            i.addr = dx[0]      # 为当前应分配的变量的相对地址，分配后要增加1
            dx[0] = dx[0] + 1
        elif name == 'procedure':
            i.level = level
        self.table.append(i)

    # 找到标识符对应的表项在符号表中的位置
    def find_item(self, name):
        j = len(self.table) - 1
        for i in self.table[::-1]:
            if i.name == name:
                return j
            j = j - 1
        return None

    # 获取一个符号
    def getsymbol(self):
        if self.symbols:
            self.symbol, self.symbols = self.symbols[0], self.symbols[1:]
            self.declare_kind()
        else:
            self.line = self.f.readline()
            if not self.line:
                print('EOF')
                exit(0)                 # [0-9a-zA-Z]+\(1:|
            self.symbols = re.findall('([0-9a-zA-Z]+|>=|<=|>|<|,|;|:=|\+|-|\*|/|=|#|\.|\)|\(|\\n|\\t)', self.line)
            while '\n' in self.symbols:
                self.symbols.remove('\n')
            while '\t' in self.symbols:
                self.symbols.remove('\t')
            if not self.symbols:
                self.getsymbol()
                return
            self.symbol, self.symbols = self.symbols[0], self.symbols[1:]
            self.declare_kind()

    # 判断符号的类型（保留字或运算符/标识符/数字/其他）
    def declare_kind(self):
        if self.symbol in saved or self.symbol in symbol_class:
            self.symbol = self.symbol
        elif not re.match('[a-zA-Z]', self.symbol):
            self.symbol, self.num = 'number', int(self.symbol)
        elif re.match('[^a-zA-Z0-9]', self.symbol):
            self.symbol = 'null'  # 不会出现这种情况
        else:
            self.symbol, self.id = 'identifier', self.symbol

    # 读取文件
    def readfile(self, path):
        self.f = open(path, 'r+')

    # 常数/变量定义（复用）
    def dup(self, level, dx, kind=None):
        self.getsymbol()
        if kind == 'const':
            self.const_declaration(level, dx)
            while self.symbol == ',':
                self.getsymbol()
                self.const_declaration(level, dx)
        elif kind == 'var':
            self.variable_declaration(level, dx)
            while self.symbol == ',':
                self.getsymbol()
                self.variable_declaration(level, dx)
        if self.symbol == ';':
            self.getsymbol()
        else:
            self.error(5)

    # 子程序处理
    def block(self, level, next):
        dx = [3]                    # 相对地址，静态链SL、动态链DL、返回地址RA
        tx0 = len(self.table)-1     # 记录本层名字的初始位置
        self.table[tx0].addr = self.cx
        self.generate_code('jmp', 0, 0)

        if level > self.maxlev:     # 嵌套层数
            self.error(32)

        while True:
            if self.symbol == 'const':  # 常量声明
                self.dup(level, dx, self.symbol)
            elif self.symbol == 'var':  # 变量声明
                self.dup(level, dx, self.symbol)
            while self.symbol == 'procedure':   # 过程声明
                self.getsymbol()
                if self.symbol == 'identifier':
                    self.add_item('procedure', level, dx)   # 过程名字
                    self.getsymbol()
                else:
                    self.error(4)
                if self.symbol == ';':
                    self.getsymbol()
                else:
                    self.error(5)
                self.block(level + 1, next + [';']) # 递归调用
                if self.symbol==';':
                    self.getsymbol()
                    self.test(self.stat + ['identifier', 'procedure'], next, 6)
                else:
                    self.error(5)
                self.test(self.stat + ['identifier'], self.decl, 7)
            if self.symbol not in self.decl:    # 直到没有声明符号
                break

        self.codes[self.table[tx0].addr].addr = self.cx # 生成当前过程代码
        self.table[tx0].addr = self.cx                  # 当前过程代码地址
        self.table[tx0].size = dx                       # 声明过程中每一条语句都会增加dx
        self.generate_code('int', 0, dx[0])             # 生成内存分配代码

        self.statement(next + [';', 'end'], level)      # 每个后跟符号集和都包含上层后跟符号集和，以便补救
        self.generate_code('opr', 0, 0)                 # 每个过程出口都要使用的释放数据段指令
        self.test(next, [], 8)                          # 分程序没有补救集合

    # 打印符号表，保存符号表和虚拟机代码
    def print_table(self):
        t1 = PrettyTable(['Name', 'Kind', 'Value', 'Size', 'Addr'])
        for i in self.table:
            t1.add_row([i.name, i.kind, i.value, i.size, i.addr])
        t2 =  PrettyTable(['Num', 'F', 'L', 'A'])
        for i in range(len(self.codes)):
            t2.add_row([i, self.codes[i].optr, self.codes[i].lev, self.codes[i].addr])
        print(t1)
        print(t2)
        with open('table.tmp', 'w+') as f:
            f.write(t1.get_string())
        with open('code.tmp', 'w+') as f:
            f.write(t2.get_string())

    # 生成虚拟机代码
    def generate_code(self, f, l, a):
        self.codes.append(code(f, l, a))
        self.cx = self.cx + 1

    # 常量定义
    def const_declaration(self, level, dx):
        if self.symbol == 'identifier':
            self.getsymbol()
            if self.symbol == ':=' or self.symbol == '=':
                if self.symbol == ':=':
                    self.error(1)
                self.getsymbol()
                if self.symbol == 'number':
                    self.add_item('const', level, dx)
                    self.getsymbol()
                else:
                    self.error(2)
            else:
                self.error(3)
        else:
            self.error(4)

    # 变量定义
    def variable_declaration(self, level, dx):
        if self.symbol == 'identifier':
            self.add_item('variable', level, dx)
            self.getsymbol()
        else:
            self.error(4)

    # 语句定义
    def statement(self, next, level):
        if self.symbol == 'identifier': # 赋值语句
                i = self.find_item(self.id)
                if i == None:
                    self.error(11)
                elif self.table[i].kind != 'variable':
                    self.error(12)
                else:
                    self.getsymbol()
                    if self.symbol == ':=':
                        self.getsymbol()
                    else:
                        self.error(13)
                    self.expression(next, level)
                    if i != 0:
                        self.generate_code('sto', level-self.table[i].level, self.table[i].addr)

        elif self.symbol == 'read':     # read语句
                self.getsymbol()
                if self.symbol != '(':
                    self.error(34)
                else:
                    while True:
                        self.getsymbol()
                        if self.symbol == 'identifier':
                            i = self.find_item(self.id)
                        else:
                            i = 0

                        if i == 0:
                            self.error(35)
                        elif self.table[i].kind != 'variable':
                            self.error(32)
                        else:
                            self.generate_code('opr', 0, 16)    # 输入语句
                            self.generate_code('sto', level - self.table[i].level, self.table[i].addr) # 存储到变量
                        self.getsymbol()
                        if self.symbol != ',':
                            break
                    if self.symbol != ')':
                        self.error(33)
                        while self.symbol not in next:
                            self.getsymbol()
                    else:
                        self.getsymbol()

        elif self.symbol == 'write':    # write语句
                self.getsymbol()
                if self.symbol == '(':
                    while True:
                        self.getsymbol()
                        self.expression(next + [')', ','], level)
                        self.generate_code('opr', 0, 14)    # 输出栈顶的值
                        if self.symbol != ',':
                            break
                    if self.symbol != ')':
                        self.error(33)
                    else:
                        self.getsymbol()
                self.generate_code('opr', 0, 15)

        elif self.symbol == 'call':     # call语句
                self.getsymbol()
                if self.symbol != 'identifier':
                    self.error(14)
                else:
                    i = self.find_item(self.id)
                    if i is None:
                        self.error(11)
                    else:
                        if self.table[i].kind == 'procedure':
                            self.generate_code('cal', level-self.table[i].level, self.table[i].addr)
                        else:
                            self.error(15)
                self.getsymbol()

        elif self.symbol == 'if':       # if语句
                self.getsymbol()
                self.condition(next + ['then', 'do'], level) # 条件处理
                if self.symbol == 'then':
                    self.getsymbol()
                else:
                    self.error(16)
                cx1 = self.cx
                self.generate_code('jpc', 0, 0)
                self.statement(next, level)
                if self.symbol == 'else':       # 地址回填
                    self.getsymbol()
                    cx2 = self.cx
                    self.generate_code('jmp', 0, 0)
                    self.codes[cx1].addr = self.cx
                    self.statement(next, level)
                    self.codes[cx2].addr = self.cx
                else:
                    self.codes[cx1].addr = self.cx


        elif self.symbol == 'begin':    # 复合语句
                self.getsymbol()
                self.statement(next + [';', 'end'], level)   # 递归调用
                while self.symbol in self.stat or self.symbol == ';':
                    if self.symbol == ';':
                        self.getsymbol()
                    else:
                        self.error(10)
                    self.statement(next + [';', 'end'], level)
                if self.symbol == 'end':
                    self.getsymbol()
                else:
                    self.error(17)

        elif self.symbol == 'while':    # while语句
                cx1 = self.cx   # 保存判断条件操作的位置
                self.getsymbol()
                self.condition(next + ['do'], level)
                cx2 = self.cx   # 保存循环体结束的下一个位置
                self.generate_code('jpc', 0, 0)
                if self.symbol == 'do':
                    self.getsymbol()
                else:
                    self.error(18)
                self.statement(next, level)         # 循环体
                self.generate_code('jmp', 0, cx1)   # 回到判断条件
                self.codes[cx2].addr = self.cx      # 地址回填

        else:   # 没有对应语句
            self.test(next, [], 19)

    # 算术表达式处理
    def expression(self, next, level):
        if self.symbol == '-' or self.symbol == '+':
            op = self.symbol
            self.getsymbol()
            self.term(next + ['-', '+'], level)
            if op == '-':
                self.generate_code('opr', 0, 1)
        else:
            self.term(next + ['-', '+'], level)
        while self.symbol == '-' or self.symbol == '+':
            op = self.symbol
            self.getsymbol()
            self.term(next + ['-', '+'], level)
            if op == '+':
                self.generate_code('opr', 0, 2)
            elif op == '-':
                self.generate_code('opr', 0, 3)

    # 项处理
    def term(self, next, level):
        self.factor(next + ['*', '/'], level)
        while self.symbol == '*' or self.symbol == '/':
            op = self.symbol
            self.getsymbol()
            self.factor(next + ['*', '/'], level)
            if op == '*':
                self.generate_code('opr', 0, 4)
            else:
                self.generate_code('opr', 0, 5)

    # 因子处理
    def factor(self, next, level):
        self.test(self.fac, next, 24)
        if self.symbol in self.fac:
            if self.symbol =='identifier':
                i = self.find_item(self.id)
                if i is None:
                    self.error(11)
                else:
                    if self.table[i].kind == 'const':
                        self.generate_code('lit', 0, self.table[i].value)
                    elif self.table[i].kind == 'variable':
                        self.generate_code('lod', level - self.table[i].level, self.table[i].addr)
                    elif self.table[i].kind == 'procedure':
                        self.error(21)
                self.getsymbol()
            else:
                if self.symbol == 'number':
                    self.generate_code('lit', 0, self.num)
                    self.getsymbol()
                else:
                    if self.symbol == '(':
                        self.getsymbol()
                        self.expression(next + [')'], level)
                        if self.symbol == ')':
                            self.getsymbol()
                        else:
                            self.error(22)
                    self.test(next, self.fac, 23)

    # 条件处理
    def condition(self, next, level):
        if self.symbol == 'odd':
            self.getsymbol()
            self.expression(next, level)
            self.generate_code('opr', 0, 6)
        else:
            self.expression(next + ['=', '#', '<', '<=', '>', '>='], level)
            if self.symbol not in ['=', '#', '<', '<=', '>', '>=']:
                self.error(20)
            else:
                loop = self.symbol
                self.getsymbol()
                self.expression(next, level)
                temp_dic = {'=':8, '#':9, '<':10, '>=':11, '>':12, '<=':13}
                self.generate_code('opr', 0, temp_dic[loop])

    # 错误输出，计数
    def error(self, number):
        print('error', number)
        self.err = self.err + 1

    # 短语层恢复
    def test(self, s1, s2, n):
        if self.symbol not in s1:
            self.error(n)
            while self.symbol not in s1 and self.symbol not in s2:
                self.getsymbol()

    # 虚拟机代码执行
    def interpret(self):
        # p指令地址，b基址，t栈指针
        p, b, t = 0, 0, 0
        # 初始化栈
        stack = [-9999 for x in range(500)]
        stack[0], stack[1], stack[2] = 0, 0, 0
        while True:
            f, l, a = self.codes[p].optr, self.codes[p].lev, self.codes[p].addr     # 虚拟机代码
            p = p + 1
            if f == 'lit':
                stack[t] = a
                t = t + 1
            elif f == 'opr':
                normal = {2:'+', 3: '-', 4:'*', 5:'//', 8:'==', 9:'!=', 10:'<', 11:'>=', 12:'>', 13:'<='}
                if a in normal.keys():
                    t = t - 1
                    temp_exp = str(stack[t-1]) + normal[a] + str(stack[t])
                    stack[t - 1] = int(eval(temp_exp))
                if a == 0:
                    t = b
                    p, b = stack[t + 2], stack[t + 1]
                elif a == 1:
                    stack[t - 1] = -stack[t - 1]
                elif a == 6:
                    t = t - 1
                    stack[t - 1] = stack[t - 1] % 2
                elif a == 14:
                    print(stack[t-1], end="")
                    t = t - 1
                elif a == 15:
                    print("")
                elif a == 16:
                    stack[t] = int(input("?"))
                    t = t + 1
            elif f =='lod':
                stack[t] = stack[self.base(l, stack, b) + a]
                t = t + 1
            elif f == 'sto':
                t = t - 1
                stack[self.base(l, stack, b) + a] = stack[t]
            elif f == 'cal':
                stack[t] = self.base(l, stack, b)
                stack[t+1], stack[t+2] = b, p
                b, p = t, a
            elif f == 'int':
                t = t + a
            elif f == 'jmp':
                p = a
            elif f == 'jpc':
                t = t - 1
                if stack[t] == 0:
                    p = a
            if p == 0:
                break

    # 通过过程基址找到符号
    def base(self, level, stack, b):
        b1 = b
        while level > 0:
            b1 = stack[b1]
            level = level - 1
        return b1

if __name__ == '__main__':
    path = 'pl0\column.pl0'
    a = PL0(path)