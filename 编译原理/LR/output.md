
## LR0/SLR(1)

输入1

```python
origin_dict = dict(
    E=['aA', 'bB'],
    A=['cA', 'd'],
    B=['cB','d']
)
start = Expand('E', origin_dict)
test = 'bccd#'
```

输出1

```python
12
state 0
S' → ·E ['#']
E → ·aA ['#']
E → ·bB ['#']
action
c None
d None
b [[2]]
a [[3]]
# None
goto
B None
E 1
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
S' → E· ['#']
action
c [["S'", 'E']]
d [["S'", 'E']]
b [["S'", 'E']]
a [["S'", 'E']]
# [["S'", 'E']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
E → b·B ['#']
B → ·cB ['#']
B → ·d ['#']
action
c [[4]]
d [[5]]
b None
a None
# None
goto
B 6
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
E → a·A ['#']
A → ·cA ['#']
A → ·d ['#']
action
c [[7]]
d [[8]]
b None
a None
# None
goto
B None
E None
S' None
A 9
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
B → c·B ['#']
B → ·cB ['#']
B → ·d ['#']
action
c [[4]]
d [[5]]
b None
a None
# None
goto
B 10
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
B → d· ['#']
action
c [['B', 'd']]
d [['B', 'd']]
b [['B', 'd']]
a [['B', 'd']]
# [['B', 'd']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
E → bB· ['#']
action
c [['E', 'bB']]
d [['E', 'bB']]
b [['E', 'bB']]
a [['E', 'bB']]
# [['E', 'bB']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 7
A → c·A ['#']
A → ·cA ['#']
A → ·d ['#']
action
c [[7]]
d [[8]]
b None
a None
# None
goto
B None
E None
S' None
A 11
移进-归约冲突 False
归约-归约冲突 False
---------------
state 8
A → d· ['#']
action
c [['A', 'd']]
d [['A', 'd']]
b [['A', 'd']]
a [['A', 'd']]
# [['A', 'd']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 9
E → aA· ['#']
action
c [['E', 'aA']]
d [['E', 'aA']]
b [['E', 'aA']]
a [['E', 'aA']]
# [['E', 'aA']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 10
B → cB· ['#']
action
c [['B', 'cB']]
d [['B', 'cB']]
b [['B', 'cB']]
a [['B', 'cB']]
# [['B', 'cB']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 11
A → cA· ['#']
action
c [['A', 'cA']]
d [['A', 'cA']]
b [['A', 'cA']]
a [['A', 'cA']]
# [['A', 'cA']]
goto
B None
E None
S' None
A None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [2]
2 [0, 2] ['#', 'b'] [4]
3 [0, 2, 4] ['#', 'b', 'c'] [4]
4 [0, 2, 4, 4] ['#', 'b', 'c', 'c'] [5]
5 [0, 2, 4, 4, 5] ['#', 'b', 'c', 'c', 'd'] ['B', 'd'] 10
6 [0, 2, 4, 4, 10] ['#', 'b', 'c', 'c', 'B'] ['B', 'cB'] 10
7 [0, 2, 4, 10] ['#', 'b', 'c', 'B'] ['B', 'cB'] 6
8 [0, 2, 6] ['#', 'b', 'B'] ['E', 'bB'] 1
9 [0, 1] ['#', 'E'] ["S'", 'E'] None
接受 bccd#
```

输入2

```python
 origin_dict = dict(
    S=['aAcBe'],
    A=['Ab', 'b'],
    B=['d']
)
start = Expand('S', origin_dict)
test = 'abbcde#'
```

输出2

```python
10
state 0
S' → ·S ['#']
S → ·aAcBe ['#']
action
e None
a [[1]]
c None
b None
# None
d None
goto
A None
S' None
B None
S 2
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
S → a·AcBe ['#']
A → ·Ab ['c']
A → ·b ['c']
action
e None
a None
c None
b [[4]]
# None
d None
goto
A 3
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
S' → S· ['#']
action
e [["S'", 'S']]
a [["S'", 'S']]
c [["S'", 'S']]
b [["S'", 'S']]
# [["S'", 'S']]
d [["S'", 'S']]
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
S → aA·cBe ['#']
A → A·b ['c']
action
e None
a None
c [[6]]
b [[5]]
# None
d None
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
A → b· ['c']
action
e [['A', 'b']]
a [['A', 'b']]
c [['A', 'b']]
b [['A', 'b']]
# [['A', 'b']]
d [['A', 'b']]
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
A → Ab· ['c']
action
e [['A', 'Ab']]
a [['A', 'Ab']]
c [['A', 'Ab']]
b [['A', 'Ab']]
# [['A', 'Ab']]
d [['A', 'Ab']]
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
S → aAc·Be ['#']
B → ·d ['e']
action
e None
a None
c None
b None
# None
d [[8]]
goto
A None
S' None
B 7
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 7
S → aAcB·e ['#']
action
e [[9]]
a None
c None
b None
# None
d None
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 8
B → d· ['e']
action
e [['B', 'd']]
a [['B', 'd']]
c [['B', 'd']]
b [['B', 'd']]
# [['B', 'd']]
d [['B', 'd']]
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 9
S → aAcBe· ['#']
action
e [['S', 'aAcBe']]
a [['S', 'aAcBe']]
c [['S', 'aAcBe']]
b [['S', 'aAcBe']]
# [['S', 'aAcBe']]
d [['S', 'aAcBe']]
goto
A None
S' None
B None
S None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [1]
2 [0, 1] ['#', 'a'] [4]
3 [0, 1, 4] ['#', 'a', 'b'] ['A', 'b'] 3
4 [0, 1, 3] ['#', 'a', 'A'] [5]
5 [0, 1, 3, 5] ['#', 'a', 'A', 'b'] ['A', 'Ab'] 3
6 [0, 1, 3] ['#', 'a', 'A'] [6]
7 [0, 1, 3, 6] ['#', 'a', 'A', 'c'] [8]
8 [0, 1, 3, 6, 8] ['#', 'a', 'A', 'c', 'd'] ['B', 'd'] 7
9 [0, 1, 3, 6, 7] ['#', 'a', 'A', 'c', 'B'] [9]
10 [0, 1, 3, 6, 7, 9] ['#', 'a', 'A', 'c', 'B', 'e'] ['S', 'aAcBe'] 2
11 [0, 2] ['#', 'S'] ["S'", 'S'] None
接受 abbcde#
```


输入3

```
origin_dict = dict(
    S=['rD'],
    D=['D,i', 'i']
)
start = Expand('S', origin_dict)
test = 'ri#'
```

输出3

```python
7
state 0
S' → ·S ['#']
S → ·rD ['#']
action
, None
i None
# None
r [[2]]
goto
S 1
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
S' → S· ['#']
action
, [["S'", 'S']]
i [["S'", 'S']]
# [["S'", 'S']]
r [["S'", 'S']]
goto
S None
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
S → r·D ['#']
D → ·D,i ['#']
D → ·i ['#']
action
, None
i [[3]]
# None
r None
goto
S None
S' None
D 4
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
D → i· ['#']
action
, [['D', 'i']]
i [['D', 'i']]
# [['D', 'i']]
r [['D', 'i']]
goto
S None
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
S → rD· ['#']
D → D·,i ['#']
action
, [[5], ['S', 'rD']]
i [['S', 'rD']]
# [['S', 'rD']]
r [['S', 'rD']]
goto
S None
S' None
D None
移进-归约冲突 True
归约-归约冲突 False
---------------
存在冲突，尝试使用SLR(1)文法
state 4
S → rD· ['#']
D → D·,i ['#']
action
, [[5]]
i None
# [['S', 'rD']]
r None
goto
S None
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
D → D,·i ['#']
action
, None
i [[6]]
# None
r None
goto
S None
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
D → D,i· ['#']
action
, [['D', 'D,i']]
i [['D', 'D,i']]
# [['D', 'D,i']]
r [['D', 'D,i']]
goto
S None
S' None
D None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [2]
2 [0, 2] ['#', 'r'] [3]
3 [0, 2, 3] ['#', 'r', 'i'] ['D', 'i'] 4
4 [0, 2, 4] ['#', 'r', 'D'] ['S', 'rD'] 1
5 [0, 1] ['#', 'S'] ["S'", 'S'] None
接受 ri#

```

输入4

```python
origin_dict = dict(
    E=['E+T','T'],
    T=['T*F', 'F'],
    F=['(E)','i']
)
start = Expand('E', origin_dict)
test = 'i+i*i#'
```

输出4

```python
12
state 0
S' → ·E ['#']
E → ·E+T ['#']
E → ·T ['#']
T → ·T*F ['#']
T → ·F ['#']
F → ·(E) ['#']
F → ·i ['#']
action
# None
( [[4]]
) None
i [[2]]
* None
+ None
goto
F 1
T 3
S' None
E 5
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
T → F· ['#']
action
# [['T', 'F']]
( [['T', 'F']]
) [['T', 'F']]
i [['T', 'F']]
* [['T', 'F']]
+ [['T', 'F']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
F → i· ['#']
action
# [['F', 'i']]
( [['F', 'i']]
) [['F', 'i']]
i [['F', 'i']]
* [['F', 'i']]
+ [['F', 'i']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
E → T· ['#']
T → T·*F ['#']
action
# [['E', 'T']]
( [['E', 'T']]
) [['E', 'T']]
i [['E', 'T']]
* [['E', 'T'], [6]]
+ [['E', 'T']]
goto
F None
T None
S' None
E None
移进-归约冲突 True
归约-归约冲突 False
---------------
存在冲突，尝试使用SLR(1)文法
state 3
E → T· ['#']
T → T·*F ['#']
action
# [['E', 'T']]
( None
) [['E', 'T']]
i None
* [[6]]
+ [['E', 'T']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
F → (·E) ['#']
E → ·E+T [')']
E → ·T [')']
T → ·T*F [')']
T → ·F [')']
F → ·(E) [')']
F → ·i [')']
action
# None
( [[4]]
) None
i [[2]]
* None
+ None
goto
F 1
T 3
S' None
E 7
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
S' → E· ['#']
E → E·+T ['#']
action
# [["S'", 'E']]
( [["S'", 'E']]
) [["S'", 'E']]
i [["S'", 'E']]
* [["S'", 'E']]
+ [["S'", 'E'], [8]]
goto
F None
T None
S' None
E None
移进-归约冲突 True
归约-归约冲突 False
---------------
存在冲突，尝试使用SLR(1)文法
state 5
S' → E· ['#']
E → E·+T ['#']
action
# [["S'", 'E']]
( None
) None
i None
* None
+ [[8]]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
T → T*·F ['#']
F → ·(E) ['#']
F → ·i ['#']
action
# None
( [[4]]
) None
i [[2]]
* None
+ None
goto
F 9
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 7
F → (E·) ['#']
E → E·+T [')']
action
# None
( None
) [[10]]
i None
* None
+ [[8]]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 8
E → E+·T ['#']
T → ·T*F ['#']
T → ·F ['#']
F → ·(E) ['#']
F → ·i ['#']
action
# None
( [[4]]
) None
i [[2]]
* None
+ None
goto
F 1
T 11
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 9
T → T*F· ['#']
action
# [['T', 'T*F']]
( [['T', 'T*F']]
) [['T', 'T*F']]
i [['T', 'T*F']]
* [['T', 'T*F']]
+ [['T', 'T*F']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 10
F → (E)· ['#']
action
# [['F', '(E)']]
( [['F', '(E)']]
) [['F', '(E)']]
i [['F', '(E)']]
* [['F', '(E)']]
+ [['F', '(E)']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 11
E → E+T· ['#']
T → T·*F ['#']
action
# [['E', 'E+T']]
( [['E', 'E+T']]
) [['E', 'E+T']]
i [['E', 'E+T']]
* [['E', 'E+T'], [6]]
+ [['E', 'E+T']]
goto
F None
T None
S' None
E None
移进-归约冲突 True
归约-归约冲突 False
---------------
存在冲突，尝试使用SLR(1)文法
state 11
E → E+T· ['#']
T → T·*F ['#']
action
# [['E', 'E+T']]
( None
) [['E', 'E+T']]
i None
* [[6]]
+ [['E', 'E+T']]
goto
F None
T None
S' None
E None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [2]
2 [0, 2] ['#', 'i'] ['F', 'i'] 1
3 [0, 1] ['#', 'F'] ['T', 'F'] 3
4 [0, 3] ['#', 'T'] ['E', 'T'] 5
5 [0, 5] ['#', 'E'] [8]
6 [0, 5, 8] ['#', 'E', '+'] [2]
7 [0, 5, 8, 2] ['#', 'E', '+', 'i'] ['F', 'i'] 1
8 [0, 5, 8, 1] ['#', 'E', '+', 'F'] ['T', 'F'] 11
9 [0, 5, 8, 11] ['#', 'E', '+', 'T'] [6]
10 [0, 5, 8, 11, 6] ['#', 'E', '+', 'T', '*'] [2]
11 [0, 5, 8, 11, 6, 2] ['#', 'E', '+', 'T', '*', 'i'] ['F', 'i'] 9
12 [0, 5, 8, 11, 6, 9] ['#', 'E', '+', 'T', '*', 'F'] ['T', 'T*F'] 11
13 [0, 5, 8, 11] ['#', 'E', '+', 'T'] ['E', 'E+T'] 5
14 [0, 5] ['#', 'E'] ["S'", 'E'] None
接受 i+i*i#
```

## LR(1)/LALR(1)

输入1

```python
origin_dict = dict(
    S=['aAd', 'bAc', 'aec', 'bed'],
    A=['e']
)
start = Expand('S', origin_dict)
test = 'aed#'
```

输出1

```python
state 0
S' → ·S ['#']
S → ·aAd ['#']
S → ·bAc ['#']
S → ·aec ['#']
S → ·bed ['#']
action
e None
d None
# None
a [[1]]
b [[3]]
c None
goto
S 2
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
S → a·Ad ['#']
A → ·e ['d']
S → a·ec ['#']
action
e [[4]]
d None
# None
a None
b None
c None
goto
S None
A 5
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
S' → S· ['#']
action
e None
d None
# [["S'", 'S']]
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
S → b·Ac ['#']
A → ·e ['c']
S → b·ed ['#']
action
e [[6]]
d None
# None
a None
b None
c None
goto
S None
A 7
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
A → e· ['d']
S → ae·c ['#']
action
e None
d [['A', 'e']]
# None
a None
b None
c [[8]]
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
S → aA·d ['#']
action
e None
d [[9]]
# None
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
A → e· ['c']
S → be·d ['#']
action
e None
d [[10]]
# None
a None
b None
c [['A', 'e']]
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 7
S → bA·c ['#']
action
e None
d None
# None
a None
b None
c [[11]]
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 8
S → aec· ['#']
action
e None
d None
# [['S', 'aec']]
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 9
S → aAd· ['#']
action
e None
d None
# [['S', 'aAd']]
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 10
S → bed· ['#']
action
e None
d None
# [['S', 'bed']]
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 11
S → bAc· ['#']
action
e None
d None
# [['S', 'bAc']]
a None
b None
c None
goto
S None
A None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [1]
2 [0, 1] ['#', 'a'] [4]
3 [0, 1, 4] ['#', 'a', 'e'] ['A', 'e'] 5
4 [0, 1, 5] ['#', 'a', 'A'] [9]
5 [0, 1, 5, 9] ['#', 'a', 'A', 'd'] ['S', 'aAd'] 2
6 [0, 2] ['#', 'S'] ["S'", 'S'] None
接受 aed#
```

输入2

```python
origin_dict = dict(
    S=['BB'],
    B=['aB', 'b'],
)
start = Expand('S', origin_dict)
test = 'ab#'
```

输出2

```python
10
state 0
S' → ·S ['#']
S → ·BB ['#']
B → ·aB ['a', 'b']
B → ·b ['a', 'b']
action
a [[4]]
# None
b [[3]]
goto
B 1
S 2
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 1
S → B·B ['#']
B → ·aB ['#']
B → ·b ['#']
action
a [[6]]
# None
b [[7]]
goto
B 5
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 2
S' → S· ['#']
action
a None
# [["S'", 'S']]
b None
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 3
B → b· ['a', 'b']
action
a [['B', 'b']]
# None
b [['B', 'b']]
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 4
B → a·B ['a', 'b']
B → ·aB ['a', 'b']
B → ·b ['a', 'b']
action
a [[4]]
# None
b [[3]]
goto
B 8
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 5
S → BB· ['#']
action
a None
# [['S', 'BB']]
b None
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 6
B → a·B ['#']
B → ·aB ['#']
B → ·b ['#']
action
a [[6]]
# None
b [[7]]
goto
B 9
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 7
B → b· ['#']
action
a None
# [['B', 'b']]
b None
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 8
B → aB· ['a', 'b']
action
a [['B', 'aB']]
# None
b [['B', 'aB']]
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
state 9
B → aB· ['#']
action
a None
# [['B', 'aB']]
b None
goto
B None
S None
S' None
移进-归约冲突 False
归约-归约冲突 False
---------------
1 [0] ['#'] [4]
2 [0, 4] ['#', 'a'] [3]
3 [0, 4, 3] ['#', 'a', 'b'] 出错
```


输入3

```python
origin_dict = dict(
    S=['a', '^','(T)'],
    T=['T,S','S']
)
start = Expand('S', origin_dict)
```

输出3

```python

# test = '(a#'

# LR(0)
1 [0] ['#'] [3]
2 [0, 3] ['#', '('] [1]
3 [0, 3, 1] ['#', '(', 'a'] ['S', 'a'] 5
4 [0, 3, 5] ['#', '(', 'S'] ['T', 'S'] 6
5 [0, 3, 6] ['#', '(', 'T'] 出错

# LR(1)
1 [0] ['#'] [2]
2 [0, 2] ['#', '('] [7]
3 [0, 2, 7] ['#', '(', 'a'] 出错

# LALR(1)
1 [0] ['#'] [3]
2 [0, 3] ['#', '('] [4]
3 [0, 3, 4] ['#', '(', 'a'] ['S', 'a'] 6
4 [0, 3, 6] ['#', '(', 'S'] 出错

# test = '(a,a#'
# LR(0)
1 [0] ['#'] [4]
2 [0, 4] ['#', '('] [2]
3 [0, 4, 2] ['#', '(', 'a'] ['S', 'a'] 5
4 [0, 4, 5] ['#', '(', 'S'] ['T', 'S'] 6
5 [0, 4, 6] ['#', '(', 'T'] [8]
6 [0, 4, 6, 8] ['#', '(', 'T', ','] [2]
7 [0, 4, 6, 8, 2] ['#', '(', 'T', ',', 'a'] ['S', 'a'] 9
8 [0, 4, 6, 8, 9] ['#', '(', 'T', ',', 'S'] ['T', 'T,S'] 6
9 [0, 4, 6] ['#', '(', 'T'] 出错

# LR(1)
1 [0] ['#'] [1]
2 [0, 1] ['#', '('] [6]
3 [0, 1, 6] ['#', '(', 'a'] ['S', 'a'] 7
4 [0, 1, 7] ['#', '(', 'S'] ['T', 'S'] 9
5 [0, 1, 9] ['#', '(', 'T'] [12]
6 [0, 1, 9, 12] ['#', '(', 'T', ','] [6]
7 [0, 1, 9, 12, 6] ['#', '(', 'T', ',', 'a'] 出错

# LALR(1)
1 [0] ['#'] [3]
2 [0, 3] ['#', '('] [2]
3 [0, 3, 2] ['#', '(', 'a'] ['S', 'a'] 9
4 [0, 3, 9] ['#', '(', 'S'] ['T', 'S'] 6
5 [0, 3, 6] ['#', '(', 'T'] [11]
6 [0, 3, 6, 11] ['#', '(', 'T', ','] [2]
7 [0, 3, 6, 11, 2] ['#', '(', 'T', ',', 'a'] ['S', 'a'] 13
8 [0, 3, 6, 11, 13] ['#', '(', 'T', ',', 'S'] 出错
```