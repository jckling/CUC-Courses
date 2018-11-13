## LR语法分析python实现

代码中实现了LR(0)、SLR(1)、LR(1)、LALR(1)

### 基本流程


### 功能实现

1. 输入文法字典
```
## LR(0)
origin_dict = dict(
    E=['aA', 'bB'],
    A=['cA', 'd'],
    B=['cB','d']
)
```

2. 扩充文法
```
def Expand(start, origin_dict)      # 拓广文法，以S'为起始符号，返回起始符号

# 调用
start = Expand('E', origin_dict)
```

3. 项目集
```
# 类
class single_item()
    start, end, follow, forward                     # 产生式左部，右部，期望的符号，向前搜索符

class states():
    num, items, action, goto                        # 项目集编号，产生式，Action表，Goto表
    reduce_reduce, move_reduce                      # 归约-归约冲突，移进-归约冲突

# LR_select = 'LR0' or 'LR1'
def Closure(kernel_start, origin_dict, VNs, first, s, LR_select, forward_item=None)     # 求项目集

def Goto(state, n, origin_dict, VNs, VTs, first, LR_select)                             # 项目集，由点之后的符号转换到另一个项目集

def hasState(state, new_states, LR_select)          # 判断当前项目集列表中是否含有该项目集

def Move(item, VNs, first)                          # 移点

def state_lst(origin_start, origin_dict, LR_select) # 返回项目集列表
```

4. LR分析
```
def LR(input_string, start, total_states)           # 对输入符号串进行分析
```

#### LR(0) → SLR(1)
函数内置 `states` 类中，测试时调用改进的SLR(1)
```
def SLR1(self, follow)              # LR(0) → SLR(1)

def improved_SLR1(self, follow)     # 改进的SLR(1)
```

#### LR(1) → LALR(1)
```
def LALR1(total_states)         # 同心集合并
```

#### 辅助函数
```
def no_repeat(lst, ext_lst)             # 去重合并列表

def ulist(lst)                          # 列表去重

def find_lst(x, multiple_lst)           # 找到元素x所在列表，输入的列表中包含多个列表

def key_from_value(x, dic)              # 根据值x找到键，字典 = {键：列表}/{键：值}

def Init(origin_dict)                   # 返回非终结符、终结符、First

def First(key, origin_dict, selected)   # First集，开始符号集/首符号集

def Follow(start, key, origin_dict, first_set, selected)    # Follow集，后跟符号集

def find_state(total_states, num)       # 根据序号找到项目集

def print_state(state)                  # 打印项目集
```

### 测试
#### LR(0)

输入

```
origin_dict = dict(
    E=['aA', 'bB'],
    A=['cA', 'd'],
    B=['cB','d']
)
start = Expand('E', origin_dict)
test = 'bccd#'
```

输出（为了美观，所有输出手动进行了格式化）

```
1   [0]               ['#']                       [3]
2   [0, 3]            ['#', 'b']                  [9]
3   [0, 3, 9]         ['#', 'b', 'c']             [9]
4   [0, 3, 9, 9]      ['#', 'b', 'c', 'c']        [7]
5   [0, 3, 9, 9, 7]   ['#', 'b', 'c', 'c', 'd']   ['B', 'd']      11
6   [0, 3, 9, 9, 11]  ['#', 'b', 'c', 'c', 'B']   ['B', 'cB']     11
7   [0, 3, 9, 11]     ['#', 'b', 'c', 'B']        ['B', 'cB']     8
8   [0, 3, 8]         ['#', 'b', 'B']             ['E', 'bB']     1
9   [0, 1]            ['#', 'E']                  ["S'", 'E']     None
接受 bccd#
```


输入

```
origin_dict = dict(
    S=['aAcBe'],
    A=['Ab', 'b'],
    B=['d']
)
start = Expand('S', origin_dict)
test = 'abbcde#'
```

输出

```
1   [0]                   ['#']                                   [1]
2   [0, 1]                ['#', 'a']                              [3]
3   [0, 1, 3]             ['#', 'a', 'b']                         ['A', 'b']          4
4   [0, 1, 4]             ['#', 'a', 'A']                         [5]
5   [0, 1, 4, 5]          ['#', 'a', 'A', 'b']                    ['A', 'Ab']         4
6   [0, 1, 4]             ['#', 'a', 'A']                         [6]
7   [0, 1, 4, 6]          ['#', 'a', 'A', 'c']                    [8]
8   [0, 1, 4, 6, 8]       ['#', 'a', 'A', 'c', 'd']               ['B', 'd']          7
9   [0, 1, 4, 6, 7]       ['#', 'a', 'A', 'c', 'B']               [9]
10  [0, 1, 4, 6, 7, 9]    ['#', 'a', 'A', 'c', 'B', 'e']          ['S', 'aAcBe']      2
11  [0, 2]                ['#', 'S']                              ["S'", 'S']         None
接受 abbcde#
```

#### SLR(1)

输入

```
origin_dict = dict(
    E=['E+T','T'],
    T=['T*F', 'F'],
    F=['(E)','i']
)
start = Expand('E', origin_dict)
test = 'i+i*i#'
```

输出

```
1   [0]                       ['#']                               [4]
2   [0, 4]                    ['#', 'i']                          ['F', 'i']      1
3   [0, 1]                    ['#', 'F']                          ['T', 'F']      3
4   [0, 3]                    ['#', 'T']                          ['E', 'T']      5
5   [0, 5]                    ['#', 'E']                          [8]
6   [0, 5, 8]                 ['#', 'E', '+']                     [4]
7   [0, 5, 8, 4]              ['#', 'E', '+', 'i']                ['F', 'i']      1
8   [0, 5, 8, 1]              ['#', 'E', '+', 'F']                ['T', 'F']      11
9   [0, 5, 8, 11]             ['#', 'E', '+', 'T']                [7]
10  [0, 5, 8, 11, 7]          ['#', 'E', '+', 'T', '*']           [4]
11  [0, 5, 8, 11, 7, 4]       ['#', 'E', '+', 'T', '*', 'i']      ['F', 'i']      10
12  [0, 5, 8, 11, 7, 10]      ['#', 'E', '+', 'T', '*', 'F']      ['T', 'T*F']    11
13  [0, 5, 8, 11]             ['#', 'E', '+', 'T']                ['E', 'E+T']    5
14  [0, 5]                    ['#', 'E']                          ["S'", 'E']     None
接受 i+i*i#
```

#### LR(1)

输入

```
origin_dict = dict(
    S=['BB'],
    B=['aB', 'b'],
)
start = Expand('S', origin_dict)
test = 'ab#'
```

输出

```
1   [0]         ['#']               [4]
2   [0, 4]      ['#', 'a']          [2]
3   [0, 4, 2]   ['#', 'a', 'b']     出错
```

#### LALR(1)

输入

```
origin_dict = dict(
    S=['a', '^','(T)'],
    T=['T,S','S']
)
start = Expand('S', origin_dict)
```

`test = '(a#'` 输出

```
# LR(1)
1   [0]         ['#']               [3]
2   [0, 3]      ['#', '(']          [7]
3   [0, 3, 7]   ['#', '(', 'a']     出错

# LALR(1)
1   [0]         ['#']               [4]
2   [0, 4]      ['#', '(']          [1]
3   [0, 4, 1]   ['#', '(', 'a']     ['S', 'a']      7
4   [0, 4, 7]   ['#', '(', 'S']     出错
```

`test = '(a,a#'` 输出

```
# LR(1)
1   [0]                 ['#']                       [3]
2   [0, 3]              ['#', '(']                  [9]
3   [0, 3, 9]           ['#', '(', 'a']             ['S', 'a']      6
4   [0, 3, 6]           ['#', '(', 'S']             ['T', 'S']      8
5   [0, 3, 8]           ['#', '(', 'T']             [11]
6   [0, 3, 8, 11]       ['#', '(', 'T', ',']        [9]
7   [0, 3, 8, 11, 9]    ['#', '(', 'T', ',', 'a']   出错

# LALR(1)
1   [0]                 ['#']                       [2]
2   [0, 2]              ['#', '(']                  [4]
3   [0, 2, 4]           ['#', '(', 'a']             ['S', 'a']      5
4   [0, 2, 5]           ['#', '(', 'S']             ['T', 'S']      6
5   [0, 2, 6]           ['#', '(', 'T']             [10]
6   [0, 2, 6, 10]       ['#', '(', 'T', ',']        [4]
7   [0, 2, 6, 10, 4]    ['#', '(', 'T', ',', 'a']   ['S', 'a']      13
8   [0, 2, 6, 10, 13]   ['#', '(', 'T', ',', 'S']   出错
```