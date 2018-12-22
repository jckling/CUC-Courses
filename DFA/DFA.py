#!/usr/bin/env python
# -*- coding: utf-8 -*-

from graphviz import Digraph
import re
import copy
import operator

# 节点
class node():
    def __init__(self):
        self.start , self.end, self.edges = '', '', []

# 识别所有符号
def SYMBOLS(regex):
    string = re.findall('\w', regex)
    return list(set(string))

# 正则表达式规范化
def Regular(regex):
    while re.search('(\w)(\w)', regex):
        regex = re.sub('(\w)(\w)', r'\1·\2', regex)
    regex = re.sub(r'(\*)(\w{1}|\()', r'\1·\2', regex)
    regex = re.sub(r'(\w|\))(\()', r'\1·\2', regex)
    return regex

# 构造后缀表达式
def Postfix(regex, priority):
    postfix, Optr = '', []
    for letter in regex:
        if letter not in priority:
            postfix += letter
        else:
            if letter == '(':
                Optr.append(letter)
            elif letter == ')':
                temp = Optr.pop()
                while (temp != '('):
                    postfix += temp
                    temp = Optr.pop()
            else:
                while (Optr and (priority.index(Optr[-1]) >= priority.index(letter))):
                    postfix += Optr.pop()
                Optr.append(letter)
    while Optr:
        postfix += Optr.pop()
    return postfix

# 循环构造转换表
def state(start, edges):
    temp = []
    for edge in edges:
        if (edge[0] == start) and (edge[1] not in temp):
            temp.append(edge[1])
            temp_edge = edges[:]
            temp_edge.remove(edge)
            temp.extend(state(edge[1], temp_edge))
    return temp

# 经过任意条ε边能到达的节点
def reach(start, edges):
    temp = []
    for edge in edges:
        if (edge[0] == start) and (edge[1] not in temp):
            temp.append(edge[1])
    return temp

# DFA最小化用到的统计表
def DFAtable(nodes, edges, symbols):
    temp = dict()
    for name in nodes:
        temp[name] = ['']*len(symbols)
        for i in range(len(symbols)):
            for edge in edges:
                if symbols[i] in edge and name == edge[0]:
                    temp[name][i] = edge[1]
    return temp

# 根据DFA统计表，返回相同节点（即无法区分的节点），其状态相同，同为终态或同为初态
def sameNode(table, saved='', ddot=''):
    same = []
    for key1 in table:
        temp = []
        for key2 in table:
            if key1!=key2 and operator.eq(table[key1], table[key2]) and (key1!=saved and key2!=saved) and ((key1 in ddot and key2 in ddot) or (key1 not in ddot and key2 not in ddot)):
                temp.extend([key1,key2])
        temp = sorted(list(set(temp)), key=lambda x:int(x[1:]))
        if temp and (temp not in same):
            same.append(temp)
    return same

# 合并相同的节点，更新统计表
def Update(table, same):
    new_table = copy.deepcopy(table)
    for items in same:
        for item in items[1:]:
            del new_table[item]
        for item in items[1:]:
            for key in new_table:
                if item == new_table[key][0]:
                    new_table[key][0] = items[0]
                if item == new_table[key][1]:
                    new_table[key][1] = items[0]
    return new_table, items[0]

# 分割法实现
def symbol_reach(node, edges, symbol):
    for edge in edges:
        if edge[0] == node and edge[2] == symbol:
            return edge[1]

# 判断两个节点是否同时转到另一个集合，即是否是同态的
def same_set(node1, node2, sets):
    for set in sets:
        if node1 in set and node2 in set:
            return True
    return False

# DFA最小化，分割法
def spDFA(sets, edges, symbol):
    new_sets = []
    for set in sets:
        if (len(set)>1):
            flag = [0]*len(set)
            for i in range(len(set)):
                if flag[i]==0:
                    temp, flag[i] = [set[i]], 1
                    for j in range(i+1, len(set)):
                        a, b = symbol_reach(set[i], edges, symbol), symbol_reach(set[j], edges, symbol)
                        if a==b or same_set(a, b, sets):
                            temp.append(set[j])
                            flag[j] = 1
                    new_sets.append(temp)
        else:
            new_sets.append(set)
    return new_sets

# 重命名节点，更新起始节点/终止节点、边
def UpdateSets(sets, edges, start_node, end_nodes):
    table = dict()
    new_ends, temp_edges, beginning = [], [], ''
    for i in range(len(sets)):
        name = 'T' + str(i)
        table[name] = sets[i]
        if start_node in sets[i]:
            beginning = name
        for node in end_nodes:
            if node in sets[i]:
                new_ends.append(name)

    for edge in edges:
        for key in table:
            if edge[0] in table[key]:
                a = key
            if edge[1] in table[key]:
                b = key
        temp_edges.append([a, b, edge[2]])
    new_edges = []
    for edge in temp_edges:
        if edge not in new_edges:
            new_edges.append(edge)
    return new_edges, beginning, new_ends

# 测试
if __name__ == '__main__':
    # 定义中用到的符号，并未全部用到
    chars = {'|', '*', 'ε', 'Φ', '·', '(', ')'}

    # 优先级
    priority = ['(', '|', '·', '*', ')']

    # 新建空白画布
    graph = Digraph(name='Test', node_attr={'shape': 'circle'})

    # 三幅图像的起始点
    starts = ['', ' ', '  ']

    # 格式化正则表达式
    regex = '1(1|0)*101'    # '(a|ab)*bb*', 'b((ab)*|bb)*ab', '(a|b)*abb', '(ab)*(a*|b*)(ba)*', 'aba(a|b)*abb']
    regex_normalized = Regular(regex)
    print('正则表达式：', regex)
    print('格式化后：', regex_normalized)

    # 获取所有符号
    symbols = SYMBOLS(regex)

    # 构造后缀表达式
    postfix = Postfix(regex_normalized, priority)
    print('后缀表达式：', postfix)

    # 构造NFA
    num, Opnd = 0, []
    for letter in postfix:
        temp = node()
        if letter not in priority:
            temp.start, temp.end = str(num), str(num+1)
            temp.edges.append([temp.start, temp.end, letter])
            num += 2
        else:
            if letter == '*':
                a = Opnd.pop()
                temp.start, temp.end = str(num), str(num+1)
                temp.edges.extend(a.edges)
                blank_edges = [[temp.start, temp.end, 'ε'], [temp.start, a.start, 'ε'], [a.end, a.start, 'ε'], [a.end, temp.end, 'ε']]
                temp.edges.extend(blank_edges)
                num += 2
            elif letter == '·':
                b, a = Opnd.pop(), Opnd.pop()
                temp.start, temp.end = a.start, b.end
                temp.edges.extend(a.edges)
                temp.edges.extend(b.edges)
                edges = temp.edges[:]
                for i in range(len(edges)):
                    if b.start in edges[i]:
                        temp.edges[i][edges[i].index(b.start)] = a.end
            elif letter == '|':
                b, a = Opnd.pop(), Opnd.pop()
                temp.start, temp.end = str(num), str(num + 1)
                temp.edges.extend(a.edges)
                temp.edges.extend(b.edges)
                blank_edges = [[temp.start, a.start, 'ε'], [temp.start, b.start, 'ε'], [a.end, temp.end, 'ε'], [b.end, temp.end, 'ε']]
                temp.edges.extend(blank_edges)
                num += 2
        Opnd.append(temp)

    # 绘制NFA
    graph.node(starts[0], shape='plaintext')
    graph.edge(starts[0], Opnd[0].start, label='start')
    graph.node(Opnd[0].end, shape='doublecircle')
    space, dic = [], dict()
    for sym in symbols:
        dic[sym] = []
    for begin,end,label in Opnd[0].edges:
        graph.edge(begin, end, label=label)
        if label == 'ε':
            space.append([begin, end, label])
        else:
            dic[label].append([begin,end,label])

    # NFA→DFA
    start = state(Opnd[0].start, space)
    start.append(Opnd[0].start)
    start = sorted(start, key=lambda x:int(x))
    states = [start]    # 开始节点的集合

    # 循环构造转换表
    count, edges = 0, []
    while True:
        if count == len(states):
            break
        else:
            count = len(states)
            fake_states = states[:]
        for item in fake_states:
            for sym in symbols:
                temp = []
                for i in item:
                    temp.extend(reach(i, dic[sym]))

                temp2 = temp[:]
                for i in temp2:
                    temp.extend(state(i, space))

                temp = sorted(list(set(temp)), key=lambda x: int(x))
                if temp and (temp not in states):
                    states.append(temp)

                if temp and ([item, temp, sym] not in edges):
                    edges.append([item, temp, sym])

    # NFA转DFA后，对合并的节点进行重命名，同时将边也重命名
    beginning, ddot, new_name, new_edges = '', [], dict(), []
    for i in range(len(states)):
        name = 'S' + str(i)
        new_name[name] = states[i]
        if Opnd[0].end in states[i]:
            ddot.append(name)
        if states[i] == start:
            beginning = name

    for start,end,label in edges:
        new_start, new_end = '', ''
        for key in new_name:
            if new_name[key] == start:
                new_start = key
            if new_name[key] == end:
                new_end = key
        new_edges.append([new_start, new_end, label])

    # 绘制DFA
    graph.node(starts[1], shape='plaintext')
    graph.edge(starts[1], beginning, label='start')
    for n in ddot:
        graph.node(n, shape='doublecircle')
    for a,b,c in new_edges:
        graph.edge(a,b,label=c)

    # DFA最小化实现方法
    table = DFAtable(new_name, new_edges, symbols)
    saved = ''
    while True:
        same = sameNode(table, saved, ddot)
        temp = ddot[:]
        for s in same:
            for d in temp:
                if d in s:
                    for ss in s:
                        if ss not in ddot:
                            ddot.append(ss)
        if not same:
            break
        table, saved = Update(table, same)


    # DFA节点合并后进行重命名
    simplified_name = []
    for key in table:
        simplified_name.append(key)

    updated_name = dict()
    num = 0
    for name in simplified_name:
        updated_name[name] = 'T' + str(num)
        num += 1

    updated_table = dict()
    for key in table:
        x, y = '', ''
        if table[key][0]:
            x = updated_name[table[key][0]]
        if table[key][1]:
            y = updated_name[table[key][1]]
        updated_table[updated_name[key]] = [x, y]

    # 终止结点
    dcircle = []
    for d in ddot:
        if d in updated_name.keys():
            dcircle.append(updated_name[d])

    # 绘制最小化DFA
    for circle in dcircle:
        graph.node(circle, shape='doublecircle')
    graph.node(starts[2], shape='plaintext')
    graph.edge(starts[2], updated_name[beginning], label='start')
    for key in updated_table:
        for i in range(len(symbols)):
            if updated_table[key][i]:
                graph.edge(key, updated_table[key][i], label=symbols[i])

    # DFA最小化实现方法2
    # temp = []
    # for node in new_name:
    #     if node not in ddot:
    #         temp.append(node)
    # new_sets = [temp, ddot]
    # while True:
    #     old_sets = new_sets[:]
    #     for symbol in symbols:
    #         new_sets = spDFA(new_sets, new_edges, symbol)
    #     if old_sets == new_sets:
    #         break
    #
    # updated_edges, updated_beginning, updated_ends = UpdateSets(new_sets, new_edges, beginning, ddot)
    # for e in updated_ends:
    #     graph.node(e, shape='doublecircle')
    # graph.node(starts[2], shape='plaintext')
    # graph.edge(starts[2], updated_beginning, label='start')
    # for a, b, c in updated_edges:
    #     graph.edge(a, b, label=c)

    # 显示图像，NFA，DFA，最小DFA
    graph.view()