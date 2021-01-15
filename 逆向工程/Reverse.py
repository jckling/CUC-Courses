from capstone import *
from graphviz import Digraph
import pefile
import re

# 用于提取以0x开头的十六进制数
p = re.compile(r'0x[0-9a-fA-F]+')

# jcc指令
jcc = ['jz','je','jnz','jne','js','jns','jp','jpe','jnp','jpo','jo','jno','jc',
     'jb','jnae','jnc','jnb','jae','jbe','jna','jnbe','ja','jl','jnge','jnl',
     'jge','jle','jng','jnle','jg','jmp']

# 获取字符
def GetStr(assemble, entry, addr):
    temp = ''
    i = 0
    while True:
        ch = assemble[addr - entry + i]
        if ch not in range(32, 128) or ch == 0:
            break
        temp += chr(ch)
        i += 1
    return temp

# 函数调用关系
def GetFuncCallRelation(assemble):
    call_func = []
    for f in assemble:
        if 'call' in f:
            temp = p.findall(f[2])[0]
            if temp not in call_func:
                call_func.append(temp)
    return call_func

# 函数跳转关系，切片入口
def GetEntry(machine, assemble, image):
    entry_addr = []
    relation = []
    beginning = assemble[0][0]
    end = assemble[-1][0]
    for i in range(len(assemble)):
        addr, mnemonic, op_str = assemble[i]
        if mnemonic in jcc:
            # 获得case们
            if 'ptr'in op_str:
                start = op_str.split(' ')[4].split(']')[0]
                step = 0
                index = 4
                ch = ''
                while True:
                    num = int(start,16) - image - step + index - 1
                    if num > len(machine):
                        break
                    temp = machine[num]
                    s = hex(temp).split('0x')[1]
                    if temp == 0 and ch == '':
                        ch += '0x'
                    elif temp < 10:
                        ch += '0'
                        ch += s
                    else:
                        ch += s
                    step += 1
                    if step == 4:
                        if ch >= hex(beginning) and ch <= hex(end):
                            entry_addr.append(ch)
                            relation.append([hex(addr), ch])
                            ch = ''
                            index += 4
                            step = 0
                        else:
                            break
            elif op_str not in entry_addr:
                entry_addr.append(op_str)
            if i + 1 < len(assemble):
                addr, mnemonic, op_str = assemble[i + 1]
                if hex(addr) not in entry_addr:
                    entry_addr.append(hex(addr))
    entry_addr.sort()
    return entry_addr, relation

# 函数内部流程
def GetRelation(pieces, relation):
    rel = []
    for i in range(len(pieces)):
        piece = pieces[i]
        addr, mnemonic, op_str = piece[-1]
        if mnemonic in jcc:
            if mnemonic == 'jmp':
                if 'ptr' in op_str:
                    for switch_case in relation:
                        switch_addr = switch_case[0]
                        if hex(addr) == switch_addr:
                            rel.append([hex(piece[0][0]), switch_case[1]])
                else:
                    rel.append([hex(piece[0][0]), op_str])
            else:
                rel.append([hex(piece[0][0]), op_str])
                if i+1 < len(pieces):
                    rel.append([hex(piece[0][0]), hex(pieces[i+1][0][0])])
        else:
            if i + 1 < len(pieces):
                rel.append([hex(piece[0][0]), hex(pieces[i + 1][0][0])])
    return rel

# 函数内部切片
def GetSlice(assemble, piece_entry):
    start = 0
    index = 0
    piece = []
    for i in range(len(assemble)):
        if len(piece_entry) == 0:
            break
        addr, mnemonic, op_str = assemble[i]
        if hex(addr) == piece_entry[index]:
            temp = assemble[start:i]
            piece.append(temp)
            start = i
            index += 1
            if index >= len(piece_entry):
                temp = assemble[start:]
                piece.append(temp)
                break
    return piece

# 控制流程图
def DrawGraph(c, pieces_entry, relation):
    n = 1
    for entry in pieces_entry:
        c.node(entry,entry)
        n += 1
    for x, y  in relation:
        c.edge(x, y)

# 解析
def disasm(file_path):
    # 取得PE文件
    pe = pefile.PE(file_path)

    # 入口
    eop = pe.OPTIONAL_HEADER.AddressOfEntryPoint

    # 代码段
    code_section = pe.get_section_by_rva(eop)

    # 代码段大小
    code_size = code_section.Misc_VirtualSize

    # 代码段反汇编
    code_dump = code_section.get_data()[:code_size]

    # 基址
    image_base = pe.OPTIONAL_HEADER.ImageBase

    # 代码段起始地址
    code_addr = image_base + code_section.VirtualAddress

    # disassemble 32-bit code for X86 architecture
    md = Cs(CS_ARCH_X86, CS_MODE_32)

    # 导入表
    imported_functions = {}
    if hasattr(pe, 'DIRECTORY_ENTRY_IMPORT'):
        for dll in pe.DIRECTORY_ENTRY_IMPORT:
            for symbol in dll.imports:
                imported_functions[hex(symbol.address)] = {'name': symbol.name.decode(), 'dll': dll.dll}

    # .rdata节——存放常量
    for section in pe.sections:
        if b'rdata' in section.Name:
            rdata_size = section.Misc_VirtualSize
            rdata_addr = image_base + section.VirtualAddress
            rdata_assemble = section.get_data()[:rdata_size]

    # 获得汇编代码，code_addr: the address of the first instruction 指令起始地址
    assemble = []
    for i in md.disasm(code_dump, code_addr):
        assemble.append([i.address, i.mnemonic, i.op_str])
        #print("0x%x:\t%s\t%s" % (i.address, i.mnemonic, i.op_str))

    # 优化汇编代码，删除int3
    assemble_optimized = assemble[:]
    temp = assemble_optimized[:]
    for asm in temp:
        if 'int3' in asm:
            assemble_optimized.remove(asm)

    # 字符串常量
    global_var = []
    for line in assemble_optimized:
        if 'push' == line[1] and line[2].startswith('0x'):
            if (hex(rdata_addr) <= line[2] < hex(rdata_addr + rdata_size)):
                temp = GetStr(rdata_assemble, rdata_addr, int(line[2],16))
                if temp not in global_var:
                    global_var.append(temp)

    # 获得函数地址（十六进制），获得函数参数个数
    functions = {}
    function_addr = []
    flag = False
    for address, mnemonic, op_str in assemble_optimized:
        if flag:
            functions[addr]['para'] = int(int(op_str[-1], 16)/4)
            flag = False
        if mnemonic == 'call':
            if (op_str not in function_addr) and ('ptr'not in op_str):
                functions[op_str] = {}
                function_addr.append(op_str)
                flag = True
                addr = op_str
    function_addr.sort()

    # 函数段
    i = 0
    while i < len(assemble_optimized):
        if (eop+image_base) == assemble_optimized[i][0]:
            break
        i += 1
    function_assemble = assemble_optimized[:i]

    # 主函数段
    main = {'entry':hex(eop+image_base), 'assemble':assemble_optimized[i:]}

    # 分割函数体
    start = -1
    index = 0
    for i in range(len(function_assemble)):
        address, mnemonic, op_str = function_assemble[i]
        if hex(address) == function_addr[index]:
            if start == -1:
                start = i
            else:
                temp = function_assemble[start:i]
                functions[hex(function_assemble[start][0])]['assemble'] = temp
                start = i
            index += 1
            if index >= len(function_addr):
                temp = function_assemble[i:]
                functions[hex(function_assemble[start][0])]['assemble'] = temp
                break

    # 如果存在switch-case表，将其分割掉
    flag = False
    for addr in functions:
        if flag:
            break
        if 'ret' not in functions[addr]['assemble'][-1]:
            for i in range(len(functions[addr]['assemble'])):
                address, mnemonic, op_str = functions[addr]['assemble'][i]
                if mnemonic == 'ret':
                    functions[addr]['assemble'] = functions[addr]['assemble'][:i+1]
                    flag = True
                    break

    # 函数调用关系
    main['call'] = GetFuncCallRelation(main['assemble'])
    for addr in functions:
        functions[addr]['call'] = GetFuncCallRelation(functions[addr]['assemble'])

    # 主函数中的局部变量
    local_var = []
    temp = []
    for line in main['assemble']:
        if 'ebp - ' in line[2].split(',')[0]:
            var = line[2].split('[')[1].split(']')[0]
            type = line[2].split(' ')[0]
            if var not in temp:
                temp.append(var)
                local_var.append([type, var])
    main['local_var'] = local_var

    # 函数的局部变量（个数），隐式/显式局部变量
    temp = []
    local_var_num = 0
    for addr in functions:
        for line in functions[addr]['assemble']:
            var = line[2].split(',')[0]
            if 'ebp - ' in var and var not in temp:
                temp.append(var)
                local_var_num += 1
        functions[addr]['local_var_num'] = local_var_num
        local_var_num = 0
        temp = []

    # 主函数切片入口
    main['piece_entry'],main['relation'] = GetEntry(code_dump, main['assemble'], code_addr)
    # 主函数切片
    main['pieces'] = GetSlice(main['assemble'], main['piece_entry'])
    main['relation'] = GetRelation(main['pieces'], main['relation'])

    # 函数切片入口
    for address in functions:
        functions[address]['piece_entry'],functions[address]['relation'] = GetEntry(code_dump, functions[address]['assemble'],code_addr)
    # 函数切片
    for address in functions:
        functions[address]['pieces'] = GetSlice(functions[address]['assemble'], functions[address]['piece_entry'])
        functions[address]['relation'] = GetRelation(functions[address]['pieces'], functions[address]['relation'])

    # 调用关系图
    CG = Digraph(comment='Call Graph')
    CG.node_attr.update(color='lightblue2', style='filled')
    CG.attr(label='\nCall Graph')
    CG.attr(fontsize='20')

    for addr in functions:
        CG.node(addr, addr)
    for addr in imported_functions:
        CG.node(addr, imported_functions[addr]['name'])
    CG.node(main['entry'], 'main')

    for addr in functions:
        for c in functions[addr]['call']:
            CG.edge(addr, c ,constraint='false')
    for c in main['call']:
        CG.edge(main['entry'], c, constraint='false')
    #CG.view()
    # print(CG.source)
    # CG.render('test-output/CG', view=True)

    # 流程图
    CFG = Digraph(comment='Control Flow Graph')
    CFG.node_attr.update(color='lightblue2', style='filled')
    CFG.attr(label='\nControl Flow Graph')
    CFG.attr(fontsize='20')
    with CFG.subgraph(name='main') as c:
        if len(main['pieces']) == 0:
            c.node(hex(main['entry']), 'main')
        DrawGraph(c, main['piece_entry'], main['relation'])

    n = 1
    for addr in functions:
        with CFG.subgraph(name='function'+str(n)) as c:
            if len(functions[addr]['pieces']) == 0:
                c.node(hex(functions[addr]['assemble'][0][0]), hex(functions[addr]['assemble'][0][0]))
            DrawGraph(c, functions[addr]['piece_entry'], functions[addr]['relation'])
        n += 1
    CFG.view()
    # print(CFG2.source)
    # CFG2.render('test-output/CFG2', view=True)

    # 输出
    print(global_var)
    print(main['entry'])
    print(main['local_var'])
    print(main['call'])
    for addr in functions:
        print("=========================")
        print(addr)
        print(functions[addr]['para'])
        print(functions[addr]['local_var_num'])

# 测试
if __name__ == '__main__':
    disasm('test.exe')