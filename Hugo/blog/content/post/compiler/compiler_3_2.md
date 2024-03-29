---
title: "3. Syntax analysis (2)"
date: 2024-01-10T21:32:30+09:00
tags: ["컴파일러", "Syntax analysis","Parser","Bottom-up" , "CFG", "작성중"]
draft: false
categories: ["2024", "컴파일러"]
---

## Bottom-up
bottom-up parsing을 수행할때는 소괄호를 지원하는 조금 다른 CFG를 사용한다
- 피 연산자로 id만 지원함
- left-recursion이 있어도 됨

![CFG](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_2.CFG.png?raw=true)

Top-down parsing은 다음과 같은 방식으로 시작된다.
1. tree를 만드는 동안 token을 하나씩 읽는다.
2. 끝이 난다면 root node는 start symbol이 된다.

다음은 id1 * id2 에 대한 예시이다.
![Parse](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_2.Parse.png?raw=true)

즉 reversed order Rightmost Derivation이라고 볼 수 있다.

## LR(1) Parsing
- 매 단계마다 다음 token을 받아올지 production rule을 적용할지 정해야 한다.
- top-down parsing과 동일하게 parsing table을 사용한다.

### Three Types of LR(1) Parsing
- **L**eft-to-right, **R**ightmost derivation, **1** token lookahead
- SLR(1) Parsing : **S**imple **LR(1)** Parsing  
  - 우리가 다룰것
- LALR(1) Parsing : **L**ook-**A**head **LR(1)** Parsing
  - SLR(1)보다 많은 grammar에 적용 가능하다.
  - 많은 언어에서 사용된다.
- Canonical LR(1) Parsing
  - LALR(1)보다 더 많은 grammar에 적용 가능하다.
  - 복잡하다.

### LR(1) Grammar
- 위에서 소개한 CFG는 SLR(1)에 포함된다.

![Grammar_diagram](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_2.Grammar_diagram.png?raw=true)

### LR(1) Parsing Overview 
LR(1) Parsing을 하기 위해서 두가지 작업을 수행한다.
- shift : input token을 Stack에 push 한다.
- reduce :  Stack의 top에 있는 변수를 rule에 맞게 변형한다.

다음은 id1 * id2 에 대한 예시이다.
|Stack|Input Tokens|
|:---|---:|
||id1 * id2 $|
|id1| *id2 $| 
|F|*id2 $ |
|T|*id2 $ | 
|T*|id2 $ |
|T*id2|$|
|...|...|
|E|$|

### LR(1) Parsing
하지만 실제 LR(1) Parsing은 매우 복잡하게 작동한다.

효율성을 위하여 state를 저장하는 Stack을 추가로 구현한다.

또한 LR(1)의 parsing table은 LL(1)과 다르다
- Row : top element in the state stack
- Column : next token or reduced variable


SLR(1) Parsing Table

![SLR_Table](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_2.SLR_Table.png?raw=true)

추가로 CFG의 Rule을 새롭게 정의한다.
CFG
|:---|:---|
|R1|E -> E + T|
|R2|E -> T|
|R3|T -> T * F|
|R4|F -> (E)|
|R5|F -> id|

Shift action : s5
- s5 : shift a symbol and push state 5

Reduce action : r6
- reduce with rule 6 and pop state
- lookup table [0,F]=g3, push state 3




|State Stack    |Symbol Stack   |Input Tokens   |Action     |
|:---           |:---           |---:           |---:       | 
|0              |               |id1 * id2 $    |           |
|0 5            |id1            |* id2 $        |s5         |
|0 3            |F              |* id2 $        |r6         |
|0 2            |T              |* id2 $        |r4         |
|0 1            |E              |id2 $          |r2         |
|0 1 6          |E +            |$              |s6         |
|0 1 6 5        |E + id2        |$              |s5         |
|0 1 6 3        |E + F          |$              |r6         |
|0 1 6 9        |E + T          |$              |r4         |
|0 1            |E              |$              |r1         |

## SLR Parsing Table
### Preparation with CFG
- add new start symbol 
> (R0) S -> E

### LR(0)
<!--- 추후 업데이트 예정 p.29  --->