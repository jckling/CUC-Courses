import re
import copy

# 合并列表，去重
def no_repeat(lst, ext_lst):
    for i in ext_lst:
        if i not in lst:
            lst.append(i)
    return lst

# 能推出空串ε的非终结符，直接推导
def NIL(origin_dict):
    temp_dict = copy.deepcopy(origin_dict)
    epsilon_ends, not_epsilon_ends = [], []
    for k, v in origin_dict.items():
        if 'ε' in v:    # 如果直接推导出空串
            epsilon_ends = no_repeat(epsilon_ends, k)
            del temp_dict[k]
        else:
            for item in v:
                if re.findall('[^A-Z]', item):  # 如果含有终结符，则一定不能推导出空串，删除该产生式
                    temp_dict[k].remove(item)
            if temp_dict[k] == []:  # 如果非终结符的产生式全被删除，说明无法推导出空串
                not_epsilon_ends = no_repeat(not_epsilon_ends, k)
                del temp_dict[k]
    return implicit_NIL(temp_dict, epsilon_ends, not_epsilon_ends)

# 能推出空串ε的非终结符，间接推导
def implicit_NIL(changed_dict, epsilon_ends, not_epsilon_ends):
    changed_ends, changed_not_ends = epsilon_ends, not_epsilon_ends
    temp_dict = copy.deepcopy(changed_dict)
    for k, v in changed_dict.items():
        for item in v:
            for i in not_epsilon_ends:
                if i in item and k in temp_dict.keys():     # 产生式含有不能推导到空串的非终结符
                    if item in temp_dict[k]:
                        temp_dict[k].remove(item)
                        if temp_dict[k] == []:      # 如果非终结符的产生式全被删除，说明无法推导出空串
                            changed_not_ends = no_repeat(changed_not_ends, k)
                            del temp_dict[k]

            for i in epsilon_ends:
                if i in item and k in temp_dict.keys():     # 产生式含有能推导到空串的非终结符
                    if item in temp_dict[k]:
                        temp_dict[k].remove(item)
                        item = item.replace(i, '')      # 将空串替换掉
                        if item:
                            temp_dict[k].append(item)
                        if temp_dict[k] == []:      # 如果非终结符的产生式全被删除，说明无法推导出空串
                            changed_ends = no_repeat(changed_ends, k)
                            del temp_dict[k]
    # 如果集合不变则表明推导完毕，否则递归继续推导
    if changed_ends == epsilon_ends and changed_not_ends == not_epsilon_ends:
        return epsilon_ends, not_epsilon_ends
    else:
        implicit_NIL(temp_dict, changed_ends, changed_not_ends)

# First集，开始符号集/首符号集
def First(key, origin_dict, selected):
    selected.append(key)
    first = []
    for item in origin_dict[key]:
        if re.match('[^A-Z]', item[0]): # 匹配终结符
            first = no_repeat(first, item[0])
        else:   # 非终结符的处理
            if len(item) == 1:
                first = no_repeat(first, First(item, origin_dict))
            else:
                if item[0] not in selected:# 避免取自己的FIRST集
                    temp = First(item[0], origin_dict, selected)
                    if item[0] not in temp:
                        first = no_repeat(first, temp)
                    else:
                        temp.remove('ε')
                        first = no_repeat(first, temp)
                        if item[1] in origin_dict.keys():
                            temp = First(item[1], origin_dict)
                            first = no_repeat(first, temp)
                        else:
                            first = no_repeat(first, item[1])
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
                        follow = no_repeat(follow, Follow(start, k, origin_dict, first_set, selected))

                pat = key+'[^A-Z]+' # 匹配终结符+非终结符
                lst = re.findall(pat, item)
                if lst:
                    for l in lst:
                        follow = no_repeat(follow, l[1])

                pat = key + '[A-Z]+'    # 匹配终结符+终结符
                lst = re.findall(pat, item)
                if lst:
                    for l in lst:
                        for i in l[1:]: # 后跟非终结符
                            if 'ε' not in first_set[i]:
                                follow = no_repeat(follow, first_set[i])
                                break
                            else:
                                follow = no_repeat(follow, first_set[i])
                                while 'ε' in follow:
                                    follow.remove('ε')
                                if i == l[-1]:  # 后跟非终结符（结尾）的FIRST集含有空串
                                    if k not in selected:
                                        selected.append(key)
                                        follow = no_repeat(follow, Follow(start, k, origin_dict, first_set, selected))
    return follow

# Select集
def Select(origin_dict, first_set, follow_set, epsilon_ends):
    sets = []
    for k, v in origin_dict.items():
        for item in v:
            temp_set = []
            if re.match('[^A-Zε]', item):   # 匹配终结符
                temp_set = no_repeat(temp_set, item[0])
            elif 'ε' == item[0]:    # 如果是空串，则添加FOLLOW集
                temp_set = no_repeat(temp_set, follow_set[k])
            elif 'ε' not in first_set[item[0]]: # 如果是不含空串的非终结符，则添加FIRST集
                temp_set = no_repeat(temp_set, first_set[item[0]])
            else:   # 如果是含空串的非终结符
                for i in range(len(item)):
                    if item[i] in epsilon_ends: # 如果该非终结符可以导出空串
                        temp = copy.deepcopy(first_set[item[i]])    # 先添加其FIRST，去掉空串
                        temp.remove('ε')
                        temp_set = no_repeat(temp_set, temp)
                        if i == len(item)-1:    # 如果是最后一个非终结符，则需要添加FOLLOW集
                            temp_set = no_repeat(temp_set, follow_set[k])
                    else:
                        if item[i] in first_set.keys():
                            temp_set = no_repeat(temp_set, first_set[item[i]])
                        else:
                            temp_set = no_repeat(temp_set, item[i])
                        break
            sets.append([k, item, temp_set])
    return sets

# 以字典的形式返回终结符号的select集合
def Select_dict(VNs, select_set):
    dic = dict()
    for VN in VNs:
        dic[VN] = []
    for item in select_set:
        VN, right, set = item[0], item[1], item[2]
        dic[VN].append(set)
    return dic

# 预测分析表
def Forecast(VNs, select_set):
    table = dict()
    for VN in VNs:
        table[VN] = dict()
    for item in select_set:
        VN, right, select = item[0], item[1], item[2]
        for VT in select:
            table[VN][VT] = right
    return table

# 判断相同左部产生式的select集是否有交集
def Same(select_lst):
    for i in range(len(select_lst)):
        for j in range(i+1, len(select_lst)):
            for item in select_lst[j]:
                if item in select_lst[i]:
                    return True
    return False

# 判断是否为LL(1)文法
def LL1(select_table):
    for key in select_table:
        if Same(select_table[key]):
            return False
    return True

# 可直接认为大写字母是非终结符号，除了大写字母的所有其他字母都是终结符号
def Init(origin_dict):
    VNs = list(origin_dict.keys())
    VTs = []
    for key in origin_dict:
        for item in origin_dict[key]:
            for i in item:
                if i not in VNs:
                    VTs = no_repeat(VTs, i)
    return VNs, VTs

# 删除不可达的产生式
def Remove_useless(start, origin_dict):
    temp_dict = copy.deepcopy(origin_dict)
    for key in temp_dict:
        useless = True
        for k,v in temp_dict.items():
            for item in v:
                if key in item or key == start:
                    useless = False
                    break
            if useless == False:
                break
        if useless:     # 如果非终结符没有出现在任何产生式右部，则为不可达
            del origin_dict[key]

# 提取一个非终结符的所有产生式的左公因子，显式左公因子
def Factor(origin_dict):
    same_factor = dict()
    for key in origin_dict: # 遍历每个非终结符的产生式
        same, right_lst = dict(), origin_dict[key]
        for i in range(len(right_lst)):
            target = right_lst[i]
            temp, same_lst = '', []
            for l in range(1, len(target)+1):     # 从一个符号开始匹配，直到产生式的长度
                temp_temp, temp_same_lst = temp, same_lst[:]
                temp, same_lst = target[:l], []
                for j in range(i+1, len(right_lst)):
                    if right_lst[j].startswith(temp):
                        same_lst.append(right_lst[j])   # 如果产生式的起始符号相同
                if same_lst:    # 如果有相同的起始符号的产生式
                    same_lst.append(target) # 将被匹配的产生式也加入列表
                    if same_lst == temp_same_lst:   # 如果匹配后有公因子的产生式相同，则更新公因子
                        del same[temp_temp]
                    same[temp] = same_lst
                else:
                    break   # 如果一个公因子也没有则退出，注意，产生式的顺序是不可改变的
        if same:
            same_factor[key] = same
    return same_factor

# 将隐式左公因子变为显式，将会改变原有产生式
# 对右部以非终结符开始的产生式用左部相同而右部以终结符开始的产生式进行相应的替换（所有产生式以终结符号开始）
# 其实也可以替换为相同的非终结符，有多种情况
# S → Ab | Bc
# A → Cad
# B → Cda
# C → a
def implicit_Factor(origin_dict, VNs):
    temp_dict = copy.deepcopy(origin_dict)
    for key,lst in temp_dict.items():
        for right in lst:
            VT_start = []
            if right[0] in VNs:     # 如果产生式以非终结符起始
                for possible_right in origin_dict[right[0]]:
                    if possible_right[0] not in VNs:    # 如果非终结符对应的产生式以终结符起始
                        VT_start.append(possible_right)
                    else:
                        return
                if VT_start:
                    right_follow = right[1:]    # 除了非终结符的产生式
                    origin_dict[key].remove(right)   # 删除以非终结符起始的产生式
                    for possible_right in VT_start:
                        origin_dict[key].append(possible_right+right_follow)  # 替换以非终结符起始的产生式
                    implicit_Factor(origin_dict, VNs)   # 替换后再次进行遍历和替换


# 提取左公因子，删除不可达公式
def Left_factor(start, VNs, origin_dict):
    same = Factor(origin_dict)
    if not same:
        implicit_Factor(origin_dict, VNs)
        same = Factor(origin_dict)

    # 新的非终结符（从这里面选出）
    new_VN = ['A', 'B', 'C', 'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    for key in same:
        for factor in same[key]:
            new_item = []
            for item in same[key][factor]:
                if item != factor:  # 如果产生式和公因子不同
                    new_item.append(item[len(factor):])
                else:# 如果产生式和公因子不相同，则需要添加空串
                    new_item.append('ε')
                origin_dict[key].remove(item)
            for VN in new_VN:   # 选取一个新的非终结符
                if VN not in VNs:
                    origin_dict[VN] = new_item
                    VNs.append(VN)
                    origin_dict[key].append(factor+VN)
                    break

    Remove_useless(start, origin_dict)  # 删除不可达

# 消除直接左递归，删除无用公式
def Recursive(start, VNs, origin_dict):
    # 新的非终结符（从这里面选出）
    new_VN = ['A', 'B', 'C', 'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    # 消除直接左递归
    temp_origin_dict = copy.deepcopy(origin_dict)
    for key in temp_origin_dict:    # 遍历每个产生式
        a_temp, b_temp = [], []
        for item in temp_origin_dict[key]:
            if key == item[0]:  # 如果产生式含有左递归，即产生式的起始符号和对应的非终结符相同
                a_temp.append(item[1:])
            else:
                b_temp.append(item)
        if a_temp and b_temp:  # 如果存在左递归，且不为死循环
            for VN in new_VN:
                if VN not in VNs:
                    VNs.append(VN)
                    new_item, changed_item = [], []
                    for a in a_temp:
                        new_item.append(a+VN)
                    for b in b_temp:
                        changed_item.append(b+VN)
                    new_item.append('ε')
                    origin_dict[key] = changed_item
                    origin_dict[VN] = new_item
                    break
    Remove_useless(start, origin_dict)  # 删除不可达

# 间接左递归，改变原有产生式（非递归，待改）
# 产生式以非终结符为起始，而该非终结符的产生式又和原先的非终结符相同
def implicit_Recursive(origin_dict, VNs):
    temp_dict = copy.deepcopy(origin_dict)
    for key, lst in temp_dict.items():
        for right in lst:
            if right[0] in VNs:  # 如果产生式以非终结符起始
                flag = False
                for possible_right in temp_dict[right[0]]:
                    if possible_right[0] == key:  # 如果非终结符对应的产生式和原先的非终结符相同
                        flag = True
                if flag:
                    right_follow = right[1:]
                    origin_dict[key].remove(right)  # 删除以非终结符起始的产生式
                    for possible_right in temp_dict[right[0]]:
                        origin_dict[key].append(possible_right + right_follow)  # 替换以非终结符起始的产生式

# 消除左递归
def Left_recursive(start, VNs, origin_dict):
    Recursive(start, VNs, origin_dict)
    implicit_Recursive(origin_dict, VNs)
    Recursive(start, VNs, origin_dict)

# 不确定的自顶向下分析方法
def Uncertain(string, stack, VNs, select_set):
    temp = stack[:]

    stack_vt_num = 0    # 如果栈中的终结符比字符串的终结符还多，那么就退回到上一步
    for i in stack[:]:
        if i not in VNs:
            stack_vt_num = stack_vt_num + 1
    if stack_vt_num > len(string):
        return False

    count = 0   # 匹配的字符数
    for s in string:
        if s == '#' and temp[-1] == '#':       # 栈顶和字符都为#，则匹配完毕
            return True
        not_in_select = True
        for item in select_set:     # 遍历SELECT集
            VN, right, VT = item[0], item[1], item[2]   # VN通过VT中的任意一个能够转换到right的状态
            if temp[-1] in VNs and temp[-1] == VN and s in VT:    # 栈顶为非终结符，且匹配对应的非终结符，而且s在终结符中
                not_in_select = False
                temp_temp = temp[:]
                temp.pop()  # 弹出非终结符
                for i in right[::-1]:   # 倒序压入栈
                    temp.append(i)
                if 'ε' == temp[-1]:  # 弹出所有空串
                    temp.pop()

                if s == temp[-1]:   # 如果字符和栈顶的非终结符匹配，弹出栈顶
                    temp.pop()
                    count = count + 1
                    if s == '#':    # 栈顶和字符都为#，则匹配完毕
                        return True
                elif temp[-1] not in VNs:   # 如果不匹配，也不为非终结符
                    return False
                if temp[-1] in VNs:     # 如果栈顶是非终结符
                    temp_string = string[count:]    # 将匹配的字符从原字符串中移除，继续进行匹配
                    flag = Uncertain(temp_string, temp, VNs, select_set)
                    if flag == False:   # 如果匹配失败，还原上一次的状态，继续进行匹配
                        count = count - 1   # 已匹配的字符数-1
                        temp = copy.deepcopy(temp_temp)    # 还原栈
                        continue
        if not_in_select:
            return False
    return True

# 出错处理
def Handle():
    pass

# 确定的自顶向下分析方法 - 预测分析方法/LL(1)分析法
# （栈顶符号，当前符号）→（栈顶操作，输入符号操作）
def Predict(string, start, VNs, forecast):
    stack = ['#', start]    # 初始化栈
    for s in string:
        while stack[-1] in VNs: # 栈顶为非终结符
            if stack[-1] in forecast.keys():   # 预测分析表中查找
                old = stack.pop()   # 将非终结符弹出栈
                if s in forecast[old].keys():  # 如果有对应的预测分析表项
                    for i in forecast[old][s][::-1]:   # 倒序压入栈
                        stack.append(i)
                else:   # 否则出错，终止返回
                    print('predict function returns "no match predict item" （分析表表项为空）')
                    return
        while 'ε' == stack[-1]: # 如果栈顶为空串，弹出
            stack.pop()
        if s == stack[-1]:  # 如果栈顶匹配，弹出
            stack.pop()
        elif stack[-1] in VNs:  # 如果栈顶为非终结符，当前符号为终结符，则继续
            continue
        else:   # 否则不匹配，出错，终止返回
            print('predict function returns "VT not match" （栈顶终结符与当前输入不匹配）')
            return
    print('predict function returns "matched"')

# 确定的自顶向下分析方法 - 递归子程序
# 如果字符串匹配文法，最终返回的lst_string只有一个#
def Func(s, lst_string, VN, VNs, forecast):
    for key in forecast[VN]:
        if s[0] == key:
            for i in forecast[VN][key]:
                if i in VNs:    # 如果是非终结符，递归调用子程序
                    Func(s, lst_string, i, VNs, forecast)
                elif i == s[0]:    # 如果是终结符，匹配
                    s.pop()
                    s.append(lst_string[0][0])
                    temp = lst_string[0]
                    if temp != '#':     # 如果没有终止，将匹配的终结符移出，压入剩余符号
                        lst_string.remove(temp)
                        lst_string.append(temp[1:])

# 返回LL(1)、VNs、SELECT集、预测分析表
def get_Data(origin_dict, start):
    epsilon_ends, not_epsilon_ends = NIL(origin_dict)
    VNs, VTs = Init(origin_dict)

    first_set = dict()
    for key in VNs:
        temp = First(key, origin_dict, [])
        first_set[key] = temp

    follow_set = dict()
    for key in VNs:
        temp = Follow(start, key, origin_dict, first_set, [])
        follow_set[key] = temp

    select_set = Select(origin_dict, first_set, follow_set, epsilon_ends)
    forecast = Forecast(VNs, select_set)
    select_dict = Select_dict(VNs, select_set)

    is_LL1 = LL1(select_dict)

    return is_LL1, VNs, select_set, forecast

# 测试
def Mymain(origin_dict, start, test_string):
    is_LL1, VNs, select_set, forecast = get_Data(origin_dict, start)
    max_conversion_time = 5     # 最大转换次数
    while is_LL1 == False and max_conversion_time != 0:
        Left_factor(start, VNs, origin_dict)
        Left_recursive(start, VNs, origin_dict)
        is_LL1, VNs, select_set, forecast = get_Data(origin_dict, start)
        max_conversion_time = max_conversion_time - 1
    else:
        if max_conversion_time:
            Predict(test_string, start, VNs, forecast)
            s, lst = [test_string[0]], [test_string[1:]]
            Func(s, lst, start, VNs, forecast)
            if lst[0] == '#' and s[0] == '#':
                print('recursive function returns "matched"\n')
            else:
                print('recursive function returns "not match"\n')
        else:
            print('uncertain function test')
            if Uncertain(test_string, ['#', start], VNs, select_set):
                print('uncertain function returns "matched"\n')
            else:
                print('uncertain function returns "not match"\n')

if __name__ == '__main__':
    test1 = dict(
        S=['AB','BA'],
        A=['aA','c'],
        B=['bB', 'ε']
    )
    test2 = dict(   # 非LL1
        S=['AB','bC'],
        A=['ε','b'],
        B=['ε','aD'],
        C=['AD','b'],
        D=['aS','c']
    )
    test3 = dict(
        E=['TA'],
        A=['+TA','ε'],
        T=['FB'],
        B=['*FB', 'ε'],
        F=['i','(E)']
    )
    test4 = dict(
        S=['AcB'],
        A=['aA','b'],
        B=['cB','d']
    )
    test5 = dict(
        S=['aS','b']
    )
    test6 = dict(
        S=['aSb','aS','ε']
    )
    test7 = dict(
        S=['Sa', 'b']
    )
    test = dict(
        S=['xAy'],
        A=['ab', 'a']
    )

    test8 = dict(
        S=['aAS','b'],
        A=['bAS','ε']
    )

    test9 = dict(
        A=['BCc','gDB'],
        B=['bCDE','ε'],
        C=['DaB', 'ca'],
        D=['dD','ε'],
        E=['gAf','c']
    )
    test10 = dict(
        A=['ad', 'Bc'],
        B=['aA', 'bB']
    )
    test11 = dict(
        A=['aB', 'Bb'],
        B=['Ac', 'd']
    )

    # Mymain(test6, 'S', 'ab#')
    # Mymain(test6, 'S', 'a#')
    # Mymain(test4, 'S', 'abccd#')
    # Mymain(test5, 'S', 'aab#')
    # Mymain(test9, 'A' , 'abbb#')
    # Mymain(test10, 'A', 'ad#')

    # Mymain(test8, 'S', 'ab#')
    # Mymain(test11, 'A', 'ad#')