import re, operator, copy

# 去重合并列表
def no_repeat(lst, ext_lst):
    for i in ext_lst:
        if i not in lst:
            lst.append(i)
    return lst

# 列表去重
def ulist(lst):
    uniq = []
    for i in lst:
        if i not in uniq:
            uniq.append(i)
    return uniq

# 找到元素所在列表，输入嵌套列表：[[], []]
def find_lst(x, multiple_lst):
    for l in multiple_lst:
        if x in l:
            return l
    return None

# 根据值找键，字典 = {键：列表}/{键：值}
def key_from_value(x, dic):
    for k,v in dic.items():
        if isinstance(v, list):
            for i in v:
                if x == i:
                    return k
        else:
            if x == v:
                return k

# 可直接认为大写字母是非终结符号，除了大写字母的所有其他字母都是终结符号
def Init(origin_dict):
    VNs = list(origin_dict.keys())
    VTs = []
    for key in origin_dict:
        for item in origin_dict[key]:
            for i in item:
                if i not in VNs:
                    no_repeat(VTs, i)

    first_set = dict()
    for key in VNs:
        temp = First(key, origin_dict, [])
        first_set[key] = temp

    follow_set = dict()
    for key in VNs:
        temp = Follow(start, key, origin_dict, first_set, [])
        follow_set[key] = temp

    return VNs, VTs, first_set, follow_set

# First集，开始符号集/首符号集
def First(key, origin_dict, selected):
    selected.append(key)
    first = []
    for item in origin_dict[key]:
        if re.match('[^A-Z]', item[0]): # 匹配终结符
            no_repeat(first, item[0])
        else:   # 非终结符的处理
            if len(item) == 1:
                no_repeat(first, First(item, origin_dict, selected))
            else:
                if item[0] not in selected:# 避免取自己的FIRST集
                    temp = First(item[0], origin_dict, selected)
                    if item[0] not in temp:
                        no_repeat(first, temp)
                    else:
                        temp.remove('ε')
                        no_repeat(first, temp)
                        if item[1] in origin_dict.keys():
                            temp = First(item[1], origin_dict)
                            no_repeat(first, temp)
                        else:
                            no_repeat(first, item[1])
    return first

# Follow集，后跟符号集
def Follow(start, key, origin_dict, first_set, selected):
    follow = []
    if key == start:
        follow.append('#')  # 输入串的结束符，输入串括号
    for k,v in origin_dict.items():
        for item in v:
            if key in item:
                if key == item[-1] and key != k:    # 避免取自己的FOLLOW集
                    if k not in selected:
                        selected.append(k)  # 取k的FOLLOW集
                        no_repeat(follow, Follow(start, k, origin_dict, first_set, selected))

                pat = key+'[^A-Z]+' # 匹配终结符+非终结符
                lst = re.findall(pat, item)
                if lst:
                    for l in lst:
                        no_repeat(follow, l[1])

                pat = key + '[A-Z]+'    # 匹配终结符+终结符
                lst = re.findall(pat, item)
                if lst:
                    for l in lst:
                        for i in l[1:]: # 后跟非终结符
                            if 'ε' not in first_set[i]:
                                no_repeat(follow, first_set[i])
                                break
                            else:
                                no_repeat(follow, first_set[i])
                                while 'ε' in follow:
                                    follow.remove('ε')
                                if i == l[-1]:  # 后跟非终结符（结尾）的FIRST集含有空串
                                    if k not in selected:
                                        selected.append(key)
                                        no_repeat(follow, Follow(start, k, origin_dict, first_set, selected))
    return follow

# 拓广文法，以S'为起始符号
def Expand(start, origin_dict):
    if "S'" not in origin_dict.keys():
        origin_dict["S'"] = [start]
        return "S'"
    else:
        print("S'作为起始符号错误！")
        exit()

# 项目结构
class single_item():
    def __init__(self, start, end, VNs, first, forward_item):
        self.start, self.end = start, end
        self.forward = []   # 向前搜索符
        self.set_follow()   # 期望的符号
        self.set_forward(VNs, first, forward_item)  # 更新向前搜索符

    # 设置期望的符号
    def set_follow(self):
        i = self.end.index('·')     # ·所在位置
        if i + 1 == len(self.end):  # 如果是在最后，则为归约项，期望符号为#
            self.follow = '#'
        else:
            self.follow = self.end[i + 1]   # 否则为·后的符号

    # 设置向前搜索符
    def set_forward(self, VNs, first, forward_item):
        if forward_item is None:    # 如果不是从某一产生式推导而来
            self.forward = ['#']    # 则为空
        elif isinstance(forward_item, list):    # ·移动后，向前搜索符不变，传来的是向前搜索符
            self.forward = forward_item
        else:
            i = forward_item.end.index('·')+2
            if i < len(forward_item.end):       # 如果前一个产生式的·后有符号
                if forward_item.end[i] in VNs:  # 非终结符
                    self.forward = first[forward_item.end[i]]
                else:  # 终结符
                    self.forward = [forward_item.end[i]]
            else:
                self.forward = forward_item.forward

    # LR(0) SLR(1)
    def compare(self, other):
        return self.start==other.start and self.end==other.end and self.follow==other.follow

    # LR(1) LALR(1)
    def compareLR1(self, other):
        return self.start==other.start and self.end==other.end and any(map(operator.eq, self.forward, other.forward))

# 项目集结构
class states():
    total = 0   # 计数（编号）

    def __init__(self, VNs, VTs):
        self.num = states.total             # 项目集编号
        states.total = states.total+1
        self.items = []                     # 产生式
        self.transform = dict()             # 期望的符号：产生式
        self.goto = {}.fromkeys(VNs)        # 非终结符：项目集编号
        self.action = {}.fromkeys(VTs+['#'])# 终结符+#：项目集编号/归约项
        self.reduce_reduce = False          # 归约-归约冲突
        self.move_reduce = False            # 移进-归约冲突

    # 删除一个项目集时，编号-1
    def __del__(self):
        try:
            states.total = states.total-1
        except Exception:
            pass

    # LR(1) 是否含有该产生式，用于构造项目集时跳出递归
    def hasitem(self,item):
        for i in self.items:
            if i.compareLR1(item):
                return True
        return False

    # 比较项目集的产生式是否相等，如果是LR1还需要比较向前搜索符号
    def compare(self, other, LR_select):
        for item in self.items:
            flag = False
            for i in other.items:
                if LR_select == 'LR0':
                    if item.compare(i):
                        flag =True
                        break
                elif LR_select == 'LR1':
                    if item.compareLR1(i):
                        flag =True
                        break
            if flag == False:
                return False
        return True

    # 比较项目集的是否相等，针对Action和Goto
    def go_compare(self, other, lst):
        for i in self.action.keys():
            if self.action[i] != None and other.action[i] != None:
                if isinstance(self.action[i][0][0], int) and isinstance(other.action[i][0][0], int):
                    a, b = find_lst(self.action[i][0][0], lst), find_lst(other.action[i][0][0], lst)
                    if a==None and b==None:
                        continue
                    elif (a==None and b!=None) or (a!=None and b==None):
                        return False
                    elif not any(map(operator.eq, a, b)):
                        return False
                elif isinstance(self.action[i][0], str) and isinstance(other.action[i][0], str):
                    if not any(map(operator.eq, self.action[i], other.action[i])):
                        return False

        for j in self.goto.keys():
            if self.goto[j] != None and other.goto[j] != None:
                if isinstance(self.goto[j], int) and isinstance(other.goto[j], int):
                    a, b = find_lst(self.goto[j], lst), find_lst(other.goto[j], lst)
                    if a==None and b==None:
                        continue
                    elif (a==None and b!=None) or (a!=None and b==None):
                        return False
                    elif not any(map(operator.eq, a, b)):
                        return False
        return True

    # 合并项目集
    def merge(self, other, same_states, del_lst):
        n = len(self.items)
        for i in range(n):
            for j in range(n):
                if self.items[i].compare(other.items[j]):       # 产生式相等合并向前搜索符
                    no_repeat(self.items[i].forward, other.items[j].forward)

        ac_key = self.action.keys()
        for ac in ac_key:
            # 如果action表项为移进项，且跳转到的项目集要被删除
            if self.action[ac] != None and isinstance(self.action[ac][0], int) and self.action[ac][0] in del_lst:
                self.action[ac] = key_from_value(self.action[ac], same_states)
            # 如果action表项为空则继承另一个项目集的action表项
            elif self.action[ac] == None and other.action[ac] != None:
                self.action[ac] = other.action[ac]
            # 否则保持原有表项，与另一个项目集是相同的

        go_key = self.goto.keys()
        for go in go_key:
            if self.goto[go] != None and self.goto[go] in del_lst:
                self.goto[go] = key_from_value(self.goto[go], same_states)
            elif self.goto[go] == None and other.goto[go] != None:
                self.goto[go] = other.goto[go]

    # 添加产生式
    def add_item(self, item):
        self.items.append(item)
        self.same_transform()   # 更新字典{期望符号：产生式列表}

    # LR(1)、LALR(1) 合并产生式（产生式相同、向前搜索符不同）
    def merge_item(self):
        n = len(self.items)
        del_dic = dict()
        del_lst = []

        # 找出相同产生式
        for i in range(n):
            for j in range(i+1, n):
                if self.items[i].compare(self.items[j]):
                    temp = list(del_dic.keys())+list(del_dic.values())
                    if i not in temp and j not in temp:
                        del_dic[i] = [j]
                    elif i in temp and i in del_dic.keys():
                        del_dic[i].append(j)
                    elif j in temp and j in del_dic.keys():
                        del_dic[j].append(i)

        # 合并相同产生式的向前搜索符
        for k,v in del_dic.items():
            no_repeat(del_lst, v)
            for i in v:
                no_repeat(self.items[k].forward, self.items[i].forward)

        # 重新构建项目集（产生式集合）
        if del_dic:
            temp_items = copy.deepcopy(self.items)
            del self.items
            self.items = []
            for i in range(n):
                if i not in del_lst:
                    self.items.append(temp_items[i])
            del temp_items

    # LALR(1)修改跳转
    def LALR1(self, same_states):
        for a,ac in self.action.items():
            for k,v in same_states.items():
                if ac and ac[0] == v:       # Action的归约跳转在合并的项目集（被删除）中，则修改
                    self.action[a][0]=[k]

    # 期望符号相同的产生式
    def same_transform(self):
        item = self.items[-1]   # 每次加入一个产生式就进行一次更新
        start, end, follow, forward = item.start, item.end, item.follow, item.forward
        if follow not in self.transform.keys():
            self.transform[follow]=[item]
        else:
            self.transform[follow].append(item)

    # 移进Goto/Action
    def update(self, follow, states_num, VNs):
        if follow in VNs:   # 如果是非终结符，更新Goto
            self.goto[follow] = states_num
        else:               # 如果是终结符，判断是否冲突
            if self.action[follow] != None:
                self.move_reduce = True
                self.action[follow].append([states_num])
            else:
                self.action[follow] = [[states_num]]

    # 归约
    def reduce(self, item, LR_select):
        start, end, forward = item.start, item.end, item.forward
        if LR_select == 'LR0':
            for k, v in self.action.items():
                if v == None:
                    self.action[k] = [[start, end[:-1]]]
                else:
                    for i in self.action[k]:    # 如果已经有Action表项
                        if len(i) > 1:
                            self.reduce_reduce = True
                        else:
                            self.move_reduce = True
                    self.action[k].append([start, end[:-1]])
        elif LR_select == 'LR1':    # LR(1) 根据向前搜索符更新
            for f in forward:
                if self.action[f] == None:
                    self.action[f] = [[start, end[:-1]]]
                else:
                    if [start, end[:-1]] not in self.action[f]:
                        self.action[f].append([start, end[:-1]])
                        for i in self.action[f]:
                            if len(i) > 1:
                                self.reduce_reduce = True
                            else:
                                self.move_reduce = True

    # LR(0) → SLR(1)
    def SLR1(self, follow):
        move, reduce, compat = [], [], []
        for item in self.items:
            if item.follow == '#':  # 归约
                reduce.append(item)
                compat.extend(follow[item.start])
            else:   # 移进
                move.append(item)
                compat.append(item.follow)

        if ulist(compat) != compat: # 有交集
            print('无法解决冲突（不是SLR(1)文法）')
            return
        else:
            for key in self.action.keys():
                if key not in compat:
                    self.action[key] = None

            for item in reduce:
                for key in follow[item.start]:
                    temp = self.action[key][:]
                    for act in temp:
                        if isinstance(act[0], int):
                            self.action[key].remove(act)

            for item in move:
                temp = self.action[item.follow][:]
                for act in temp:
                    if not isinstance(act[0], int):
                        self.action[item.follow].remove(act)

            self.reduce_reduce = False
            self.move_reduce = False

    # 改进的SLR(1)
    def improved_SLR1(self, follow):
        if self.move_reduce==True or self.reduce_reduce==True:
            print('存在冲突，尝试使用SLR(1)文法')
            self.SLR1(follow)
        if self.move_reduce==False and self.reduce_reduce==False:
            for key in self.action.keys():
                if self.action[key] != None:
                    if isinstance(self.action[key][0][0], int):
                        continue
                    else:   # 删除多余的归约项
                        if key not in follow[self.action[key][0][0]]:
                            self.action[key].remove(self.action[key][0])

# 求项目集
def Closure(kernel_start, origin_dict, VNs, first, s, LR_select, forward_item=None):
    for item in origin_dict[kernel_start]:
        new_item = single_item(kernel_start, '·'+item, VNs, first, forward_item)
        if LR_select == 'LR0':
            s.add_item(new_item)
            if item[0] in VNs and item[0]!=kernel_start:    # 避免推导到本身死循环
                Closure(item[0], origin_dict, VNs, first, s, LR_select, new_item)
        elif LR_select == 'LR1':
            if not s.hasitem(new_item):     # 如果不存在该产生式
                s.add_item(new_item)
                if item[0] in VNs:
                    Closure(item[0], origin_dict, VNs, first, s, LR_select, new_item)

# 项目集，由点之后的符号转换到另一个项目集
def Goto(state, n, origin_dict, VNs, VTs, first, LR_select):
    s = state[n]
    produce = []
    for key in s.transform.keys():
        if key == '#':  # 归约项
            for item in s.transform[key]:
                s.reduce(item, LR_select)
        else:           # 移进项
            new_state = states(VNs, VTs)
            for item in s.transform[key]:
                new_item = Move(item, VNs, first)
                new_state.add_item(new_item)
                if new_item.follow in VNs:
                    Closure(new_item.follow, origin_dict, VNs, first, new_state, LR_select, new_item)
            has, num = hasState(state, new_state, LR_select)
            if has:
                del new_state
                s.update(key, num, VNs)     # 如果存在该项目集，则指向它的编号
            else:
                s.update(key, new_state.num, VNs)
                if LR_select == 'LR1':
                    new_state.merge_item()  # 合并相同产生式
                produce.append(new_state)
    return produce

# 判断当前项目集列表中是否含有该项目集
def hasState(state, new_states, LR_select):
    for s in state:
        if s.compare(new_states, LR_select):
            return True, s.num
    return False, ''

# 移点
def Move(item, VNs, first):
    start, end = item.start, item.end
    i = end.index('·') + 1
    end = end.replace('·', '')
    end = end[0:i]+'·'+end[i:]
    return single_item(start, end, VNs, first, item.forward)    # 点移动后，向前搜索符不变

# 根据序号找到项目集
def find_state(total_states, num):
    for state in total_states:
        if state.num == num:
            return state

# 同心集合并
def LALR1(total_states):
    same_states = dict()    # 假若不止两个是同心集
    total = len(total_states)

    # 相同项目集，只判断产生式相同
    for i in range(total):
        for j in range(i+1, total):
            if total_states[i].compare(total_states[j], 'LR0'):
                if i in same_states.keys() and j not in same_states[i]:
                    same_states[i].append(j)
                elif j in same_states.keys() and i not in same_states[i]:
                    same_states[j].append(i)
                else:
                    same_states[i] = [j]

    # 相同项目集编号对
    same_states_lst = []
    for key in same_states.keys():
        temp = [key]
        no_repeat(temp, same_states[key])
        same_states_lst.append(temp)

    # 进一步判断Action/Goto是否相同，如果不相同则存在冲突
    first_same_states = copy.deepcopy(same_states)
    for k,v in first_same_states.items():
        for state in v:
            if not total_states[k].go_compare(total_states[state], same_states_lst):
                same_states[k].remove(state)    # 如果不是相同的项目集
                if same_states[k] == None:
                    del same_states[k]
                same_states_lst = []    # 更新相同项目集编号对
                for key in same_states.keys():
                    temp = [key]
                    no_repeat(temp, first_same_states[key])
                    same_states_lst.append(temp)
    del first_same_states

    if not same_states:
        print('不是LALR(1)文法')
        return total_states

    # 合并同心集
    del_lst = []
    for k,v in same_states.items():
        no_repeat(del_lst, v)
        for state in v:
            total_states[k].merge(total_states[state], same_states, del_lst)

    # 生成新的项目集列表
    new_states = []
    for i in range(total):
        if i not in del_lst:
            total_states[i].LALR1(same_states)
            new_states.append(copy.deepcopy(total_states[i]))
    del total_states

    return new_states

# 对输入符号串进行分析
def LR(input_string, start, total_states):
    n = 0                   # 字符
    step = 1                # 步骤
    state_stack = [0]       # 状态栈
    symbol_stack = ['#']    # 符号栈
    while True:
        s = input_string[n]
        temp_state = find_state(total_states, state_stack[-1])  # 找到状态栈中对应的项目集
        action = temp_state.action[s]   # 查Action表
        if action == None:
            print(step, state_stack, symbol_stack, '出错')
            exit()
        else:
            action = temp_state.action[s][0]
        if isinstance(action[0], int):  # 移进
            print(step, state_stack, symbol_stack, action)
            symbol_stack.append(s)
            state_stack.append(action[0])
            n = n+1
        else:   # 归约
            symbol, k = action[0], len(action[1])
            temp = 0-1-k
            temp_state = find_state(total_states, state_stack[temp])
            goto = temp_state.goto[symbol]
            print(step, state_stack, symbol_stack, action, goto)
            # 归约后符号栈为起始符号，符号串为#。则接受该符号串
            if symbol==start and s == '#':
                print('接受', input_string)
                break
            while k > 0:    # 归约后更新栈
                state_stack.pop()
                symbol_stack.pop()
                k = k-1
            symbol_stack.append(symbol)
            state_stack.append(goto)
        step = step + 1     # 下一步

# 打印项目集
def print_state(state):
    print('state', state.num)
    for single in state.items:
        print(single.start, '→', single.end, single.forward)

    print('action')
    for k, v in state.action.items():
        print(k, v)

    print('goto')
    for k, v in state.goto.items():
        print(k, v)

    print('移进-归约冲突', state.move_reduce)
    print('归约-归约冲突', state.reduce_reduce)
    print('-' * 15)

# 项目集列表
def state_lst(origin_dict, LR_select):
    if LR_select!='LR0' and LR_select!='LR1':   # 如果输入错误
        print('Wrong select: %s\nShould choose from "LR0", "LR1"'%LR_select)
        exit()
    VNs, VTs, first_set, follow_set = Init(origin_dict)
    n = 0
    total = 1
    lst = [states(VNs, VTs)]
    Closure(start, origin_dict, VNs, first_set, lst[0], LR_select)
    if LR_select == 'LR1':
        lst[0].merge_item()
    while n != total:
        lst.extend(Goto(lst, n, origin_dict, VNs, VTs, first_set, LR_select))
        n = n + 1
        total = len(lst)
    return lst, follow_set

# 主函数
if __name__ == '__main__':
    ## LR(0)
    origin_dict = dict(
        E=['aA', 'bB'],
        A=['cA', 'd'],
        B=['cB','d']
    )
    start = Expand('E', origin_dict)
    test = 'bccd#'

    # origin_dict = dict(
    #     S=['aAcBe'],
    #     A=['Ab', 'b'],
    #     B=['d']
    # )
    # start = Expand('S', origin_dict)
    # test = 'abbcde#'
    #

    # ## SLR(1)
    # origin_dict = dict(
    #     S=['rD'],
    #     D=['D,i', 'i']
    # )
    # start = Expand('S', origin_dict)
    #
    # origin_dict = dict(
    #     E=['E+T','T'],
    #     T=['T*F', 'F'],
    #     F=['(E)','i']
    # )
    # start = Expand('E', origin_dict)
    # test = 'i+i*i#'

    # ## LR(1)
    # origin_dict = dict(
    #     S=['aAd', 'bAc', 'aec', 'bed'],
    #     A=['e']
    # )
    # start = Expand('S', origin_dict)
    #
    # origin_dict = dict(
    #     S=['BB'],
    #     B=['aB', 'b'],
    # )
    # start = Expand('S', origin_dict)
    # test = 'ab#'
    # # LR(1) LALR(1)
    # origin_dict = dict(
    #     S=['a', '^','(T)'],
    #     T=['T,S','S']
    # )
    # start = Expand('S', origin_dict)
    # test = '(a#'
    # test = '(a,a#'

    # 来测试
    LR_select = 'LR0'
    lst, follow = state_lst(origin_dict, LR_select)
    # lst = LALR1(lst)
    print(len(lst))
    for state in lst:
        print_state(state)
        # if state.move_reduce or state.reduce_reduce:
        #     state.improved_SLR1(follow)
            # print_state(state)

    LR(test, start, lst)