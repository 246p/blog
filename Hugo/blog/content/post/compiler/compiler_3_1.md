---
title: "3. Syntax analysis (1)"
date: 2024-01-10T17:47:45+09:00
tags: ["컴파일러", "Syntax analysis", "Parser", "Top-Down", "CFG" ]
draft: false
categories: ["2024", "컴파일러"]
---
## Context-free grammar
CFG : defined with a set of production rules
ex) 
E -> E + E
E -> E * E
E -> id
E -> num

### Derivation
ex) E ⇒ E + E ⇒ id + E ⇒ id + num
we will use ⇒* to denote arbitrary number of rewriting steps

### Terminal Symbol vs Non-Terminal Symbol
Terminal Symbol : can't be rewritten anymore (+, *, id, num)
Non-Terminal Symbol : can be rewritten (E)

### CFG : Sentence and Language
Sentence : Result of derivation that does not contain nay non-terminal

Language : set of all derivable sentences
>  𝑳(𝑮) = {𝒘 | 𝑺⇒ ∗𝒘, 𝒘 consists of terminals}

### Leftmost Derivation 
derivation을 할때 가장 왼쪽의 non-terminal을 먼저 변환하는 규칙

### Parse tree
Derivation process중 Parse tree를 만들 수 있음
> ex) E ⇒ E + E ⇒ id + E ⇒ id + num

![Parse](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Parse.png?raw=true)



### RegEx vs CFG
- R = ((id | num) (' + ' | ' * '))* (id | num) 와 같이 RegEx로 할 수 있다.
- 하지만 brackets : "{}", "{{}}", {{{}}}",... 과 같이 RegEx로 표현 불가능한 것이 존재 한다.
- 또한 RegEx는 Parse Tree를 생성할 수 없다.

### Ambiguous Grammar
derivations 방법에 따라서 서도 다른 parse tree가 만들어진다.

![Amb_1](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Amb_1.png?raw=true)

![Amb_2](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Amb_2.png?raw=true)


이와 같은 경우를 막기 위하여 세가지 요소를 고려해야한다.
1) Eliminate ambiguity
2) (Precedence) Bind * before +
- id + id * id must be interpreted as id + (id * id)
3) (Associativity) * and + associate to the left
- id + id + id must be interpreted as (id + id) + id

다음과 같이 CFG를 정의하면 가능하다.

> Start variable is E
>
>E -> E + T | T
>
>T -> T * F | F
>
>F -> id | num



### General Rewriting Algorithm? 
ambiguous -> unambiguous로 rewrite하는 algorithm은 없다.

심지어 ambiguous 한지 판단하는 algorithm 또한 없다.
- Undecidable problem
하지만 우리는 unambiguous 하다는 가정하에 진행한다.

## Top-down parsing
Parser는 derivation을 추론해야함 (if exist)
- Parsing is the process of inferring derivation for the token stream
- construction of parse tree

### Top-down parsing
- leftmost derivations
- root node에서 아래 방향으로 늘려야함


At each step, we must rewrite the left most non-terminal
- 이때 어떠한 production rule을 사용할지 골라야 한다.


parsing table : case에 따라 어떤 rule을 사용할지 알려줌
- current status + next token을 통해 고를 수 있음
- table drivven LL(1) parsing or LL(1) parsing
    - **L**eft-to-right, **L**eftmost derivation, **1** token lookahead

## LL(1) Grammar
- LL(1) Grammar 란 LL(1) parsing이 적용 되는 CFG를 의미한다.
- 모든 CFG에 대해서 적용할 수 는 없다.
- 즉 어떤 grammar들은 parsing table을 만들 수 없음


다음 CFG는 LL(1)이 아님
E -> E + T | T
T -> T * F | F
F -> id | num

### Left-Recursion
 - CFG has a variable A that appear as the fist symbol in right-hand side of a rule

- 위 예시에서 E, T는 left-recursive 이다.

- CFG가 left-recursive이면 LL(1)이 될 수 없다.

### Eliminating Left-Recursion

> 𝑨 → 𝑨𝜶 | 𝜷 

위와 같은 rule을 다음과 rewrite할 수 있다.
> 𝑨 → 𝜷𝑨′
>
> 𝑨′ → 𝜶𝑨′ | 𝝐
이를 우리의 production rule에 적용해 보자. 

![Left](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Left.png?raw=true)

Left- Recursion 이 아니더라도 꼭 LL(1) Grammer는 아니다. 다행히 운이 좋게도 우리의 CFG는 LL(1) Grammar이다. 

### LL(1) Parsing Example
num + id 에 대해서 LL(1) parsing을 적용해보자

|            Stack  |     Input Tokens |  Rule       |
|---------------:|-----------------:|:---------------:|
|               E $ |         num + id $ |                    |
|           T E' $ |         num + id $ |  E -> T E'       |
|         F T' E' $ |        num + id $ | T -> F T'        | 
|      num T' E' $ |        num + id $ | F -> num         |
|           T' E' $ |              + id $ | Match and Pop  |
|               E' $ |              + id $ | T' -> 𝜺           |
|          + T E' $ |              + id $ | E' -> + T E;     |
|            T E' $ |                id $ | Match and Pop  |
|         F T' E' $ |                id $ | T -> F T'        |
|         id T' E' $ |                id $ | F -> id           |
|            T' E' $ |                   $ | Match and Pop |
|               E' $ |                   $ | T' -> 𝜺           |
|                  $ |                   $ | E' -> 𝜺           | 

### Parsing Table
Parsing 을 수행하다보면 Parsing table의 필요성을 느끼게 된다.

Row : non-terminal on stack top

Column : first terminal (token) in buffer

![Parsing_table_1](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Parsing_table_1.png?raw=true)






### First and Follow

Parsing table을 만들기 위해서는 First, Follow set을 먼저 만들어야 한다.

First(a) : a를 파생하여 나올 수 있는 문장 중 첫 문자들의 집합

Follow(X) : X를 파생하여 나온 문장 문장 이후 나올 수 있는 문자 들의 집합

다음은 예시이다.
![FirstFollow](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.FirstFollow.png?raw=true)





### Building Parsing Table 
X -> a 에 대해서 parsing table에 넣는 방법이다.
- for t in First (a), add X -> a to the parsing table in Tap [X, t]
- if 𝜺 is in First (a), for t in Follow (x), add X -> a to Tap [X, t] 





![Parsing_table_2](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/compiler/image/3_1.Parsing_table_2.png?raw=true)



### Construction Fail 
X -> a1 | ... | an 을 생각해 보자

First (ai)들이 disjoint 하지 않을 경우 table의 하나의 slot에 여러 rule이 들어가게 된다. 즉 해당 parsing table을 만들 수 없고 CFG가 LL(1) Grammar가 아니라는 의미이다.


