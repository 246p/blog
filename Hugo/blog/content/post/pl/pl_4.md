---
title: "4. 함수 정의와 호출"
date: 2024-01-24T13:38:09+09:00
tags: ["PL", "자유변수", "유효범위"]
draft: false
categories: ["2024", "PL", "학부연구생"]
---
# 4. 함수 정의와 호출
앞에서 선언한 언어를 확장하여 함수를 정의한다.
## 4.1 문법구조
프로그램에서 함수를 사용하려면 함수 생성(선언)과 호출을 지원해야한다.

     E -> n
        | E1 + E2
        | E1 - E2 
        | E1 * E2
        | E1 / E2
        | x                       
        | let x = E1 in E2        
        | if E1 then E2 else E3   
        | iszero E         
        | fun x E               함수 생성식
        | E1 E2                 함수 호출식

### fun x E
x를 인자로 받아서 E의 계산 결과를 반환하는 함수를 정의하는 구문이다.

x를 형식인자, E를 몸통식 이라고 한다.

ex) fun x (x+1) : 인자 x를 받아서 x+1을 반환하는 함수

### E1 E2
E1은 호출할 함수를 계산하는 식이고 E2는 함수의 인자를 계산하는 식이다. E2의 값을 실제인자라고 부른다.

ex) let f = fun x (x+1) in (f 2)

함수 fun x (x+1)을 f라고 정의하고 실제인자 2를 이용하여 호출하는 식이다.

### 동치관계
우리는 다음과 같은 동치관계를 발견할 수 있다.
> let x = E1 in E2 ≡ (fun x E2) E1

## 4.2 의미구조
함수의 생성과 호출에서 실행 의미를 정의해보자
이에 앞서 자유변수에 대하여 정의할 필요가 있따.

### 4.2.0 자유변수
함수의 의미를 정의하기우ㅏㅎ여 변수들을 자유변수와 묶인변수로 구분해야한다.

자유변수란 주어진 식에서 그 정의를 찾을 수 없는 변수를 말한다.

묶인변수란 주어진 식에서 정의를 찾을 수 있는 변수를 의미한다.

또한 식E에 등장하는 자유변수의 집합 FV(E)는 다음과 같이 귀납적으로 정의된다.

묶인변수는 VAR(E)\FV(E)가 된다.

    FV(n) = ∅
    FV(x) = {x}
    FV(E1 + E2) = FV (E1) ∪ FV(E2)
    FV(let x = E1 in E2) = FV(E1) ∪ (FV(E2) \ {x})
    FV(if E1 then E2 else E3) = FV(E1) ∪ FV(E2) ∪ FV(E3)
    FV(fun x E) = FV(E) \ {x}
    FV(E1 E2) = FV(E1) ∪ FV(E2)

### 4.2.1 유효범위
먼저 다음 함수에 대해서 생각해보자

    let x = 1
    in let f = fun y (x+y)
        in let x = 2
            in let g = fun y (x+y)
                in (f 1) + (g 1)

함수에서 등장하는 자유변수의 값을 결정할때 다음 두가지 방법을 생각해볼 수 있다

1. 함수가 정의되는 시점 (정적 유효범위)

f가 정의되는 시점에서 x=1, g가 정의되는 시점에서 x=2이므로 다음과 같이 계산된다.

> f 1 = 2, g 1 = 3 

2. 함수가 호출되는 시점 (동적 유효범위)

f, g가 호출되는 시점에서 x=2이므로 다음과 같이 계산된다.

> f 1 = 3, g 1 = 3

대부분의 프로그래밍 언어는 정적 유효범위를 지원한다. 변수의 유효범위가 프로그래밍 실행전에 정적으로 결정되어 프로그램을 이해하기 쉬워지기 때문이다.


### 4.2.2 정적 유효범위
정적 유효범위를 지원하도록 함수의 의미를 정의해보자. 먼저 함수를 값으로 사용할 수 있도록 하기위하여 다음과 같이 의미공간을 확장한다.

    Val = Z + Bool + Procedure
    Procedure = Var × Exp × Env
    Env = Var → Val

함수 생성식의 실행 의미는 다음과 같이 정의할 수 있다.
        
    ------------------------
    ρ ⊢ fun x E ⇒ (x, E, ρ)

즉 환경 ρ에서 식 fun x E를 계산하면 함수값 (x,E,ρ)가 생성된다.

함수 호출식은 다음과 같다.

    ρ ⊢ E1 ⇒ (x, E, ρ′)   ρ ⊢ E2 ⇒ v   {x |→ v}ρ′ ⊢ E ⇒ v′
    ---------------------------------------------------------
                          ρ ⊢ E1 E2 ⇒ v′


### 4.2.3 동적 유효범위
동적 유효범위를 지원하기위해 다음과같이 함수호출식의 의미를 변경하면 된다.


    ρ ⊢ E1 ⇒ (x, E, ρ′)   ρ ⊢ E2 ⇒ v   {x |→ v}ρ ⊢ E ⇒ v′
    ---------------------------------------------------------
                          ρ ⊢ E1 E2 ⇒ v′

함수 몸통부를 계산할때 ρ′ 대신 ρ를 사용한다 즉 위에서 정의한 의미공간의 Env를 제외하여 Procedure = Var × Exp과 같이 다시 정의할 수 있다.

이를 다시 정의하여 나타내면 다음과 같다.
    
    ---------------------
    ρ ⊢ fun x E ⇒ (x, E)

    ρ ⊢ E1 ⇒ (x, E)    ρ ⊢ E2 ⇒ v    {x |→ v}ρ ⊢ E ⇒ v′
    ------------------------------------------------------
                       ρ ⊢ E1 E2 ⇒ v′

### 4.2.4 재귀함수

#### 정적 유효범위 재귀함수
정적 유효범위를 지원하는 의미구조 하에서 다음과 같은 프로그램을 생각해보자.

    let f = fun x (f x) in (f 1)

위 식을 실행하면 다음과 같은 환경이 만들어진다.
    
    {f |→ (x, (f x), ∅)}

이 환경에서 f 1을 실행한다면 몸통 식 f x를 계산할때 f에 대한 정보가 없으로 실행이 불가능하다. 즉 문법구조를 확장하여 재귀함수를 지원하도록 해야한다.

    E -> ...
        | let rec f(x) = E1 in E2

또한 의미구조 정의를 위하여 다음과 같이 의미공간을 확장한다.

    Val = Z + Bool + Procedure + RecProcedure
    Procedure = Var × Exp × Env
    RecProcedure = Var × Var × Exp × Env
    Env = Var → Val

즉 재귀함수는 일반함수와 다르게 함수 이름을 기억한다. 재귀함수 생성식의 의미는 다음과 같다.

    {f |→ (f, x, E1, ρ)}ρ ⊢ E2 ⇒ v
    -------------------------------
    ρ ⊢ letrec f(x) = E1 in E2 ⇒ v

    ρ ⊢ E1 ⇒ (f, x, E, ρ′)   ρ ⊢ E2 ⇒ v   {x |→ v, f |→ (f, x, E,ρ′)}ρ′ ⊢ E ⇒ v′
    -------------------------------------------------------------------------------
                                    ρ ⊢ E1 E2 ⇒ v

비재귀 함수의 호출과 다르게 함수를 호출할때 함수가 정의된 시점의 환경과 호출되는 함수를 함께 확장한다.

#### 동적 유효범위 재귀함수

동적 유효범위에서는 다른 확장 없이 재귀함수가 잘 정의된다.

왜냐하면 함수의 몸통을 함수의 호출이 일어날때 환경에서 계산한느데 그때 환경에 이미 함수 f에 대한 정보가 존재하기 때문이다.
