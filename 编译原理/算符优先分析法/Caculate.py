
import math
import re

operator = ['!', '√']   # 未实现
o = ['+', '-', '*', '/', '(', ')', '#', '%', 'e', '^', 'sin(', 'cos(', 'tan(', 'asin(', 'acos(', 'atan(']

# 算符优先关系表
def priority(a, b):
    dic = dict(zip(o, list(range(len(o)+1))))
    p = [#+    -    *    /    (    )    #    %    e    ^   sin( cos( tan( asin(acos(atan(
        ['>', '>', '<', '<', '<', '>', '>', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # +
        ['>', '>', '<', '<', '<', '>', '>', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # -
        ['>', '>', '>', '>', '<', '>', '>', '<', '>', '>', '<', '<', '<', '<', '<', '<'],  # *
        ['>', '>', '>', '>', '<', '>', '>', '>', '>', '>', '<', '<', '<', '<', '<', '<'],  # /
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # (
        ['>', '>', '>', '>', '0', '>', '>', '>', '>', '>', '0', '0', '0', '0', '0', '0'],  # )
        ['<', '<', '<', '<', '<', '0', '=', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # #
        ['>', '>', '>', '>', '<', '>', '>', '>', '>', '>', '<', '<', '<', '<', '<', '<'],  # %
        ['>', '>', '>', '>', '<', '>', '>', '>', '>', '>', '<', '<', '<', '<', '<', '<'],  # e
        ['>', '>', '>', '>', '<', '>', '>', '>', '>', '>', '<', '<', '<', '<', '<', '<'],  # ^
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # sin(
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # cos(
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # tan(
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # asin(
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # acos(
        ['<', '<', '<', '<', '<', '=', '0', '<', '<', '<', '<', '<', '<', '<', '<', '<'],  # atan(
    ]
    return '>' == p[dic[a]][dic[b]]

# 单目运算，未使用
def root(a):
    return math.sqrt(a)

def fact(a):
    sum = 1
    for i in range(1,a+1):
        sum *= i
    return sum

# 双目运算
def exponent(a, b):
    return a**b

def add(a, b):
    return a + b

def sub(a, b):
    return a - b

def multiply(a, b):
    return a*b

def divide(a, b):
    return a/b

def mod(a, b):
    return a%b

# 三角函数
def t(sym, x):
    t_sym = float(sym)
    if x == '(':
        return sym
    r = math.radians(t_sym)
    if x == 'sin(':
        return math.sin(r)
    elif x == 'cos(':
        return math.cos(r)
    elif x == 'tan(':
        return math.tan(r)
    elif x == 'asin(':
        return math.asin(r)
    elif x == 'acos(':
        return math.acos(r)
    elif x == 'atan(':
        return math.atan(r)

# 字符转化为数字
def numeric(x, y):
    try:
        a, b = int(x), int(y)
    except ValueError:
        a, b = float(x), float(y)
    return a, b

# 计算
def do_cac(sym, x, y=''):
    if y == ')':
        return t(sym, x)
    else:
        if re.findall('[^\d\\.\-]', x) or re.findall('[^\d\\.\-]', y):
            print('符号错误')
            exit(0)
        a, b = numeric(x, y)
    if sym == '+':
        return add(a, b)
    elif sym == '-':
        if x == '(':
            return -int(y)
        return sub(a, b)
    elif sym == '*':
        return multiply(a, b)
    elif sym == '/':
        return divide(a, b)
    elif sym == '%':
        return mod(a, b)
    elif sym == 'e':
        return float(x+sym+y)
    elif sym == '^':
        return exponent(a,b)
    elif sym == '!':    # 未实现
        return fact(a)

# 获得离栈顶最近的运算符
def get_operator(stack):
    for i in stack[::-1]:
        if i in o or i == '#':
            return i

# 计算
def cac(s):
    if s[0] == '-':     # 第一个数为负数时不加括号
        number = '-'
        s = s[1:] + '#'
    else:
        number = ''
        s = s + '#'
    stack = ['#']
    for i in s:
        if i not in o:
            number += i
        else:
            if number != '':
                if i == '(' and number in ['sin', 'cos', 'tan', 'asin', 'acos', 'atan']:    # 将三角函数作为一个符号入栈
                    stack.append(number+i)
                    number = ''
                    continue
                stack.append(number)
                number = ''
            while True:
                j = get_operator(stack)             # 距离栈顶最近的运算符
                if priority(j, i):                  # 和当前输入的运算符比较优先级
                    b, syn, a = stack.pop(), stack.pop(), stack.pop()
                    if syn == '-' and a == '(':     # 如果`-`前是括号，那么是负数
                        stack.append('(')
                        stack.append(str(-int(b)))
                    else:
                        result = do_cac(syn, a, b)  # 计算
                        stack.append(str(result))
                else:
                    break
            stack.append(i)
    return stack[1]                                 # 最后栈中保留的就是计算结果

if __name__ == '__main__':
    print('注意：三角函数的输入为角度')
    while True:
        expression = input('请输入算数表达式：')
        if expression:
            if re.findall('([^\d+]\.)|(\.[^\d])', expression):   # 小数点两边必须有数字
                print('小数点输入错误\n')
                continue
            if 'e' in expression and not re.findall('[\d+]e[\d+]', expression):    # e后面必须有数字
                print('e后面必须有数字\n')
                continue

            print(expression, '=', cac(expression), '\n')
        else:
            expression = input('请输入算数表达式：')