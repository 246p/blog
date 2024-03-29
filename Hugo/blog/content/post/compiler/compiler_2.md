---
title: "2. Lexical Analysis"
date: 2024-01-10T17:46:04+09:00
tags: ["컴파일러", "Lexical Analysis", "DFA", "NFA", "RegEx", "Lexer"]
draft: false
categories: ["2024", "컴파일러"]
---

## Token
문자열을 해당 문자열의 의미하는 연산, 값에 따라 token으로 분류할 수 있다.
|Token  |Example|
|:---:|:---:|
|Keyword|int, void, if|
|Identifier|a, var_1|
|Integer| 10, 20|
|Operators | +, =, *|
|Whitespace| “ “, \t, \n|

## Regula Expression
Token을 나누는 방법은 Automata를 이용한다. 이에 앞서 Regula Expression (RegEx) 에 대해서 알아볼 필요가 있다.


RegEx는 Base case와 Inductive case로 구성된다.


### Regula language
1. 𝚺 를 이용하여 symbol들의 집합을 표기한다.

ex) binary numbers : 𝚺 = {'0','1'}, lowercase letters : 𝚺 = {'a','b',...'z'}

2. Word는 주어진 𝚺의 symbol들의 나열이다.
- empty word를 나타낼때에는 𝜖을 사용한다.

ex) 𝚺 = {'0','1','2'} -> word : 𝜖, "1," ,"12", "012"

3. Language란 word의 집합을 의미한다.
- L1 = {"a","b","ab","aaaab",...}


### Base case
- 빈 문자는 𝜖로 표기한다.
- 하나의 문자는 'c' ∈ 𝚺 로 표기한다.
### Inductive case
- Union : R1|R2 : R1 or R2
- Concat : R1∙R2 : R1 and R2
- Repeat : R* : R을 반복
- 우선순위는 * > ∙ > | 순이다.

ex){ 𝝐, "a", "aa", "aaa", ..., "b", "bb", "bbb", ... }

### Formal Definition of RegEx
L(R) : a set defined by R

![Formal](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/2.Formal.png?raw=true)


## Defining Token
RegEx를 이용하여 Token을 정의할 수 있다.

- digit = | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
- letter_ = [ 'A'-'Z' ] | [ 'a'-'z' ] | '_' 

- Keyword = "int" | "void" | "if" | "else" | ... 
- Integer = digit 
- Identifier = letter_ ( letter_ | digit )*
- Operator = "=" | "+" | "-" | ... 
- Whitespaces = (" " | "\t" | "\n")+ 


## Automata
Finite-state Automata는 NFA, DFA 두 종류가 있다.
### Non-deterministic finite automata (NFA)
> Initial state, Accepting state가 존재하며 각 state들은 𝜖 또는 𝚺 에 따라 변화한다. 
>
> 다음 state로 가는 Outgoing edges들이 같은 symbol을 공유할 수 있다.

![NFA](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NFA.png?raw=true)

NFA 를 이용하여 RegEx R = ('a'|'b')* ∙ 'a'를 구현해 보면 다음과 같다.

![NFA_ex](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NFA_ex.png?raw=true)

### Deterministic finite automata (DFA)
> initial state, Accepting state가 존재하며 각 state들은 𝚺에 따라 변화한다.
>
> 다음 State로 가는 Outgoing edges들이 같은 symbol을 공유 할 수 없다.


### 𝝐-closure
우리는 RegEx->NFA->DFA->Code(Lexer) 순으로 변환하려고 한다.

이를 위히 𝝐-closure 라는 개념을 도입한다.

- 𝝐-closure(S) : S에서 symbol 없이 도달 할 수 있는 state의 집합

![e-closure](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/2.e-closure.png?raw=true)
위 그림에서 𝝐-closure({s2,s5}) = {s2,s5,s6} 이다.

### NFA to DFA
NFA를 DFA로 변환하기 위해선 NFA의 여러 state를 DFA의 하나의 state에 mapping 해야한다.

1. NFA의 s0의 𝝐-closure 계산
- 𝝐-closure({s0})={s0,s1}, 이는 DFA의 starting state가 된다.
![NtoD_1](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NtoD_1.png?raw=true)
2. S01에서 𝚺의 symbol들에 대해서 𝝐-closure 계산
- 'a' : 𝝐-closure({s2})={s2}
- 'b' : 𝜙
![NtoD_2](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NtoD_2.png?raw=true)
3. 이를 s2에서도 반복한다.
- 'a' : 𝜙
- 'b' : 𝝐-closure({s2})={s1,s3}
![NtoD_3](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NtoD_3.png?raw=true)
4. s13 에서도 반복한다.
- 'a' : 𝜖-closure( {𝑠1,s3} ) = {𝑠2}
- 'b' : 𝜙
![NtoD_4](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NtoD_4.png?raw=true)
5. 탐색하지 않은 state가 없으므로 중단한다. accepting state는 NFA와 동일하다.
![NtoD_5](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/2.NtoD_5.png?raw=true)

## Ambiguity
만약 int =x+10 이라는 문자열을 token으로 구분해 보자. 이때 int는 keyword, indentifier 둘다 해당할 수 있다.

이러한 모호성을 해소하기 위해서는 각 keyword간에 precedence를 정해주어야 한다.