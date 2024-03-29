---
title: "2. Automated Whitebox Fuzz Testing"
date: 2024-02-02T01:26:16+09:00
tags: ["2024", "논문", "학부연구생","whitebox fuzzing", "symbolic execution"]
draft: false
categories: ["2024","논문","학부연구생"]
---

[Automated Whitebox Fuzz Testing](https://patricegodefroid.github.io/public_psfiles/ndss2008.pdf)
# 0. Abstract
fuzz testing은 소프트웨어 보안 취약점을 찾는 효과적인 기술이다.
전통적인 fuzzer들은 well-formed input에 random mutations을 적용하고 결과값을 테스트한다.
이 논문에서는 Symbolic execution과 Dynamic test generation을 적용하여  alternative whitebox fuzz testing을 구현하였다.

이 논문에서는 well-formed input에 따라 실제로 실행되는 것을 기록하고, symbolicaly evalution하고, 프로그램이 입력을 어떻게 사용하는지 확인하여 입력에 대한 제약조건을 수집한다. 수집한 제약조건들을 하나씩 부정하고 constraint solver를 이용하여 solve한다. 이를 통해 프로그램에서 다른 경로를 실행하는 새로운 input을 생성한다. 이러한 과정은 code-coverage maximizing heuristic의 도움으로 반복된다.

이 알고리즘을 SAGE(Scalable, Automated, Guided, Execution)이라는 새로운 도구에서 구현하였고 SAGE는 임의의 파일을 읽는 windows application을 x86 instruct level tracing, emulation할 수 있는 white box fuzzing tool이다.
대규모 입력 파일과 수백만개의 명령으로 구성된 긴 실행 추적을 통하여 dynamic test generation을 하는 과정속 적용된 주요 최적화 기법을 소개한다.

이후 여러 windows application을 대상으로한 실험을 소개한다.
특정 지식없이 SAGE는 black box fuzzing, static analysis tool이 놓친 MS07-017 ANI vulnerability를 찾았고 image processsors, media players, file decoders등에서 30개 이상의 새로운 버그를 발견하였다.
이중 몇가지는 memory access violation이다.

# 1. Introduction
"Month of Browser Bugs"이 새로운 bug를 공개한 이후 fuzz testing은 large application에서 빠르고 효율적으로 보안 버그를 찾는 방법으로 떠오르고 있다. fuzz testing은 blackbox random testing의 한 사례이다. 어떤 경우에는 well-formed input을 생성하기위하여 grammar가 사용되며 application의 특정 지식과 test geuristics을 사용한다.

fuzz testing은 효과적이지만 blackbox testing의 한계는 잘 알려져 있다.
``` C
if (x==10) (statement)
```
의 경우 x가 무작위로 선택된 2^32분의 1 확률로 실행된다.
이것은 random testing이 낮은 code coverage를 제공하는 이유를 설명한다.

이러한 한계는 버그가 포함된 코드가 실행되지 않았기 때문에 BOF와 같은 심각한 security bug를 놓칠 수 있음을 의미한다.


이 논문에서 dynamic test generation으로부터 영감을 받아 whitebox testing 접근 방법을 제안한다. 

알고리즘은 fixed input으로 시작하여 프로그램을 symbolic하게 실행하며 조건문에서 constraint을 수집한다. 수집한 constraint을 부정하고 Constraint Solver를 이용하여 프로그램 내에서 다양한 path를 테스트 하는데 사용된다.

이 과정은 새로운 search algorithm과 coverage-maximizing heuristic을 이용하여 반복된다. 

예를들어 x=0을 위의 코드로 실행되면 constraint x≠10이 생성된다. 이를 부정하여 x=10을 생성하고 주어진 조건문을 만족하는 새로운 입력을 제공한다.

이를 통하여 입력 형식에 대한 구체적인 지식 없이도 보안 버그를 찾기 위해 프로그램의 추가 코드를 실행하고 테스트할 수 있다. 또한 프로그래머가 메모리를 올바르게 할당하고 버퍼를 조작하지 못하게 할 수 있는 "corner cases"를 자동으로 발견하고 테스트하여 security vulnerabilities를 탐지한다. 

이론적으로 systematic dynamic test generation은 full program path coverage, program verification에 도달할 수 있다. 그러나 실제로 테스트 대상 프로그램의 path의 수가 크고 symbolic exectuion, constraint generation, constraint solving이 부정확하기 때문에 일반적으로 search가 불가능하다.

따라서 우리는 실용적인 절충안을 찾을 수 밖에 없으며 이 논문에서는 유용하다고 생각하는 점을 제시한다. 실제로 특정 접근 방식은 이전에 well-test되었던 large application에서 새로운 결함을 찾는데 효과적이다.

우리의 알고리즘은 많은 결함을 찾아내었고 defact triage problem을 다룬다. 이는 static program analysis와 blackbox fuzzing에서 흔한 일이지만 dynamic test generation 에서는 이제까지 다루지 않았던 문제이다. 우리의 접근 방법은 기존 dynamic test generation에서 수행되었던것보다 더 큰 application을 테스트할 수 있다.

이 접근방식을 SAGE에 구현하였다 SAGE는 Scalable, Automated, Guided Execution의 약자로 x84 Windows application을 위한 whole-program whitebox file fuzzing tool이다. 현재 도구는 file-reading application에 중점을 두고 있지만 natwork-facing application에 대해서도 적용 가능하다.

SAGE는 blackbox fuzzer가 찾을 수 없었던 버그를 찾을 수 있다. 또한 formet-specific knowledge가 없이 blackbox fuzzing과 static anlysis에서 놓친 MS07-017 ANI bulnerability를 찾았다. 우리의 작엄은 다음 3가지에 대해 기여하였다.

- 2장에서 search가 불완전 할 수 있는 large input file, long execution traces를 갖는 large applicationd에 대한 새로운 search algorithm을 제시하였다.
- 3장에서는 SAGE의 구현에 관하여 논의하였다. symbolic execution algorithm 뒤에있는 엔지니어링 선택과 수백만 명령어의 program traces로 확장할 수 있는 key optimization techniques을 설명한다.
- 4장은 SAGE를 사용한 경험에 대하여 설명하고 있다. 발견한 결함의 예를 들고 다양한 실험의 결과에 대해서 논의하였다.


# 2. A White Box Fuzzing Algorithm
## 2.1 Background: Dynamic Test Generation
다음 프로그램에서 논의해 보자
```C
void top (char input[4]){
    int cnt=0;
    if (input[0]=='b') cnt++;
    if (input[1]=='a') cnt++;
    if (input[2]=='d') cnt++;
    if (input[3]=='!') cnt++;;
    if (cnt>=3) abort(); //error
}
```
abort가 발생할 조건을 random testing(blackbox fuzzing)으로 찾을 확률은 5/2^(8*4)정도이다. 이는 random testing의 전형적인 문제로 프로그램의 가능한 모든 execution path로 이끌어낼 input을 생성하기 어렵다.

반면 whitebox dynamic test generation은 이 프로그램의 오류를 쉽게 찾을 수 있다. 일부 initial input을 통하여 프로그램을 실행하여 실행 도중 분기문에서의 족너으로부터 입력에 대한 제약을 수집하기 위해 dynamic symbolic execution을 수행하여 constraint solver를 통하여 이전의 입력에 변형을 주어 다음 실행의 새로운 branch를 찾도록 한다.

이 과정은 주어진 프로그램 statement나 path가 실행되거나 프로그램의 모든(많은) 실행 가능한 path가 실행될때까지 반복된다.

위의 예시를 가정하면 우리는 초기 4개의 문자열 good을 가지고 함수 top을 실행한다 (경로 ρ). Figure 2는 top에 대한 모든 실행 가능한 program path의 집합을 보여준다. 가장 왼쪽 경로는 'good'에 대한 프로그램의 첫번째 실행을 나타내며 프로그램 내의 모든 if문의 else에 해당하는 경로에 해당한다. leaf의 숫자들은 0은 cnt의 값을 나타내고 있다.

![figure2](./../../image/paper_2_Figure2.png)

normal execution과 함께 symbolic execution은 조건문이 어떻게 평가되는지에 따라 다음과 같은 condition을 수집한다.

    i_0≠b, i_1≠a, i_2≠d, i_3≠!
    (i_0는 input[0]의 memory location의 값을 나타내는 symbolic variable)

다음 pathconstraint에 대해서 생각해보자

    φ_ρ = <i_0≠b, i_1≠a, i_2≠d, i_3≠!>

이는 input vector의 equivalant class이다. 즉, 방금 실행된 path로 실행되는 모든 input vector이다. 프로그램을 다른 equivalant class로 실행하려면 현제 path constraint 하나를 부정하여 다른 path로 실행할 수 있다.

    ex) φ = <i_0≠b, i_1≠a, i_2≠d, i_3=!>

이 path constraint의 해는 goo! 이다. 이를 실행하게 된다면 Figure2에서 왼쪽에서 두번째에 있는 path가 실행 된다. 이과정을 반복함으로 이 프로그램에서 가능한 모든 16가지 path를 실행할 수 있다.

이 탐색이 depth-first order로 실행된다면 Figure의 왼쪽에서 오른쪽으로 탐색된다. 그러면 cnt==3인 첫 오류는 8번째 실행에서 발생하고 9번째 실행 후에 full branch/block coverage에 도달한다.
## 2.2 Limitations
위에서 간략하게 소개된 Systematic dynamic test generation에는 두가지 한계가 존재한다.
### 2.2.1 Path explosion
모든 실행 가능한 path를 실행하는것은 실제 대규모 프로그램에 대해서 확장성이 없다. path explosion은 dynamic test generation 을 compositionally하게 수행하면서 완하할 수 있다.

이는 함수를 독립적으로 테스팅하고 테스트 결과를 함수 입력전제조건과 출력 후 조건을 사용하여 function summaries하고 high-level function을 테스팅할때 이러한 summaries를 제사용 함으로서 이루어진다.

software testing에서 summaries가 유용해 보이지만 수백만 가지 명령어를 가진 large application에 대해서 full path coverage를 도달하기엔 한계가 존재한다.
### 2.2.2 Imperfect symbolic execution
large program에 대한 symbolic execution은 복잡한 program statements(포인터 조작, 산술연산 등)과 운영체제, 라이브러리 함수 호출로 인하여 정확하게 추론하기 어렵거나 불가능하여 정밀도가 떨어질 수 있다. 즉 합리적인 비용으로 정밀도를 가지고 symbolically precision하는것은 어렵다.

symbolic execution이 불가능할때 concrete한 값을 사용하여 constraint를 단순화 하고 단순화된 부분적 symbolic execution을 수행할 수 있다.

주어진 input vector에 대한 symbolic execution으로 예측된 프로그램 path와 실제 실행된 path가 일치하지 않을때 divergence가 발생하였다고 한다.

divergence은 예측된 path를 bit vector(각 조건분기 결과에 대한 한 비트)로 기록하고 이후 실제로 해당 path가 수행되어있는지 확인함으로 감지할 수 있다.
## 2.3 Generational Search
이러한 실용적 한계를 해결하기위하여 새로운 search algorithm을 소개한다. 이 알고리즘은 다음과 같은 주요 특징을 가지고 있다.

- 대규모 입력(수천개의 symbolic variable)을 사용하고 매우 깊은 path(수백만개의 명렁어)를 가진 large application의 state space를 체계적이고 부분적으로 탐색하도록 설계되었다.
- search 과정에서 중복을 피하며 각 symbolic execution(long, expensive)에서 생성된 새로운 테스트의 수를 극대한다.
- 버그를 빠르게 찾는것을 목표로 가능한 빨리 code coverage를 극대화하기 위한 heuristic을 사용한다.
- divergence가 발생할때 recover할 수 있고 계속 진행된다.

이 새로운 search algorithm은 아래 두 코드로 제시된다. 먼저 Search함수는 standard한 과정이다. 

    1. 초기 inputSeed를 workList에 넣는다. 
    2. 프로그램을 실행하여 bug가 감지되었는지 확인한다.
    3. workList에서 Input 하나 선택하고 ExpandExecution을 통하여 새로운 childInputs을 생성한다.
    4. childInput의 각각에 대해 프로그램을 실행하고 오류를 확인하고 점수를 계산한다.
    5. workList에 이를 추가한다.
``` C 
Search(inputSeed){
    inputSeed.bound = 0;
    workList = {inputSeed};
    Run&Check(inputSeed);
    while (workList not empty) {//new children
        input = PickFirstItem(workList);
        childInputs = ExpandExecution(input);
        while (childInputs not empty) {
            newInput = PickOneItem(childInputs);
            Run&Check(newInput);
            Score(newInput);
            workList = workList + newInput;
        }
    }
}
```
이 알고리즘에서 주요한 부분은 아래코드와 같이 childInput을 확장하는 방식에 있다. ExpandExecution은 아래와 같이 동작한다.

    1. 해당 입력으로 symbolic excution를 통하여 path constraint (PC)를 생성한다.
    2. not(PC[j])와 PC[0..(j-1)]이 해 I가 존재하는지 확인한다. 
    3. 해가 존재한다면 해를 이용하여 input을 업데이트한다.
    4. 새로운 input은 evalutaion을 위하여 저장한다.

``` C
ExpandExecution(input) {
    childInputs = {};
    // symbolically execute (program,input)
    PC = ComputePathConstraint(input);
    for (j=input.bound; j < |PC|; j++){ 
        if((PC[0..(j-1)] and not(PC[j]))has a solution I){
            newInput = input + I;
            newInput.bound = j;
            childInputs = childInputs + newInput;
        }
    }
    return childInputs;
}
```


즉 inputSeed와 PC로 시작하여 새로운 search alogrithm은 PC의 모든 constraint를 확장하려고 시도할것이다. DFS의 경우 마지막 constraint를, BFS의 경우 첫번째 constraint를 확장하는것과 대비된다. 

또한 child sub-search가 중복 탐색하는것을 방지하기위하여 bound 매개변수를 사용하여 sub-search가 parent로부터 시작된 분기로 돌아가는것을 제한한다.

각 실행이 많은 child로 확장되기 때문에 이러한 검색 순서를 generational search 라고 한다.

다시 top에 대해 고려해 본다면 초기 입력이 good이라고 가정하였을때 Figure 2의 tree에서 가장 왼쪽 path는 그 입력에 대한 첫번째 실행을 의미한다.

이 parent execution에서 generational search는 4개의 first-generation child를 생성하는데 이는 leaf에 1로 기록된 4개의 path에 해당한다. 실제로 이 path들은 parent의 path constraint중 하나의 constraint를 부정하는것에 해당한다.

위 코드의 과정을 통하여 6개의 second-generation child를 생성할 수 있다. 이 과정을 반복하여 top 함수의 모든 실행 가능한 execution path를 한번씩 생성할 수 있다. 또한 cnt의 값은 generation number을 나타낸다.

ExpandExecution은 현재 path constraint에서 하나만 확장하는 대신 bound 안의 모든 constraint를 확장하기 때문에 각 symbolic execution에서 생성된 새로운 테스트 input의 수를 극대화 한다.

이 최적화는 top과 같은 작은 프로그램의 모든 execution path를 탐색하는데는 중요하지 않을 수 있지만 symbolic execution이 오랜 시간 걸리는 경우(모든 path를 실행하는것이 불가능한 large application)에는 중요하다. 3장에서 이에대해 더 자세히 논의되고 4장에서 관련된 실험을 통해 설명한다.

이 시나리오에서 initial input으로 수행된 첫번째 symbolic execution을 최대한 이용하고 first-generation child를 체계적으로 탐색하고자 한다. 이검색 전략은 initial input이 잘 형성되어 있을때 가장 잘 작동한다.

실제로 프로그램 코드의 더 많은 부분을 실행할 가능성이 더 높아지고 따라서 더 많은 constraint를 부어할 수 있으며 그 결과 더 많은 child가 생성된다. 이는 4장에서 실험을 통해 보여진다.

initial input에 대한 중요성은 전통적인 blackbox fuzz testing에서 수행하는것과 유사하며 이때문에 이러한 검색 기법을 whitebox fuzzing라고 한다.

첫번째 parent execution의 child를 확장하는것은 빠르게 block covarage를 극대화 하는 heuristic를 사용하여 우선순위를 정하여 더 빠르게 더 많은 bug를 찾을 수 있다.

Search의 Score함수는 newInput을 실행하여 이전 모든 실행과 비교했을때 얻은 incremental block coverage를 계산한다.

예를들어 100개의 새로운 block을 만드는 newInput에는 100점을 할당한다.

이후 newInput은 점수에 따라 workList에 삽입되며 높은 점수를 가진 항목이 List의 가장 앞에 배치된다. 즉 모든 자식들은 generation number와 관련없이 서로 경쟁한다.

우리의 block coverage heuristic은 EXE의 Best-First Search와 관련있다. 하지만 전체 검색 전략은 다르다.
EXE는 block coverage heuristic을 사용하지만 다음 child 를 탐색할때 DFS를 사용하는 반면 우리는 generational serach를 사용하여 모든 child를 테스트한다. workList에서 가장 좋은 것을 선택하기 전에 점수를 부여한다.

Score 함수로 계산된 block coverage heuristic은 divergent를 처리하는데도 도움이 된다. 하나의 divergent는 검색의 완전성을 손상하지만 매우 큰 검색 공간에서는 검색이 불완전할 수 밖에 없으므로 주요 문제가 되진 않는다. 하지만 divergent가 발생한다면 검색이 진행되지 않는다.

예를 들어서 path P에서 이전 탐색된 경로 P'로 divergence하는 경우 DFS는 P'과 P사이에 영원히 순환한다. 반면 우리의 generational search는 dievergence를 허용하고 이러한 pathological 상황에서 회복할  수 있다.

실제로 각 실행은 DFS처럼 많은 child를 생성하며, 만약 child P가 이전 실행 P'으로 divergent한다면 p는 점수가 0이되어 workList의 끝에 배치되므로 정상적인(non-divergent) child의 확장에 방해를 주지 않는다. 또한 divergence은 4장에서 다룰 우리의 알고리즘의 중요한 기능이다.


마지막으로 generational search는 병렬화 하기 쉽다. child를 독립적으로 확인하고 점수를 부여할 수 있다.
# 3. The SAGE System
SAGE(Scalable, Automated, Guided Execution)은 파일에서 읽은 바이트를 symbolic input으로 취급하여 windows에서 실행되는 모든 파일 읽기 프로그램을 테스트할 수 있다.

SAGE의 또 다른 혁신은 symbolic execution을 수행할때 x86 Binary level에서 trace할 수 있다는 것이다.

이 섹션은 SGAE의 설계 선택을 정당화 할 수 있는 논리를 제시한다.
## 3.1 System Architecture
SAGE는 4가지 유형의 작업을 반복하며 generational serach를 수행한다.

### 3.1.1 Tester
 
Tester는 testinput으로 프로그램을 실행하여 access violation exceptions과 extreme memory consumption등 비정상적인 이벤트를 찾는 Run&Check를 구현한다. Tester가 오류를 감지하면 testcase를 저장하고 4장에 나오는 방법대로 분류를 수행한다.

### 3.1.2 Tracer
Tracer는 동힐한 input으로 다시 실행하여 프로그램이 실행되지 않을때 확인하기 위한 로그를 생성하고 저장한다. 이 작업은 *iDNA framework*를 사용하여 machine-instruction level에서의 execution traces를 수집한다.

### 3.1.3 CoverageCollector
기록된 로그 재생하여 어떤 basic block이 실행되었는지 계산한다. SAGE는 이 정보를 사용하여 Score 함수를 구현한다.

### 3.1.4 SymbolicExecutor
기록된 로그를 다시 재생하여 입력관련 constraint를 수집하고 constraint solver *Disolver*를 사용하여 새로운 입력을 생성하고 2.3절의 ExpandExecution을 구현한다.

### 3.1.5 TrueScan
CoverageCollector와 SymbolicExecutor는 *iDNA*에 의해 생성된 trace file을 사용하고 기록된 실행을 가상으로 재실행하는 trace replay framework *TruScan*위에 구축하였다.

*TruScan*은 symbolic execution을 단순화 하는 다음과 같은 기능을 제공한다.
- 명령어 디코딩
- symbolic information에 대한 인터페이스 제공
- 다양한 입출력 시스템 호출 모니터링
- heap, stack frame 할당 추적
- 프로그램 구조를 통한 data flow tracking
  
## 3.2 Trace-based x86 Constraint Generation
SAGE의 constraint generation은 dynamical test generation과 두가지 방면에서 차이가 있다.
### 3.2.1 Machine-Code-Based Approach
#### Multitude of languages and build processes
source-based 계측은 테스트 대상 프로그램에 사용된 특정 언어, 컴파일러, 빌드 프로세스를 지원해야한다. 따라서 새로운 언어, 컴파일러, 빌드 도구에 계측을 적용하는데는 많은 초기비용이 든다. 다양한 빌드 프로세스와 호환되지 않는 컴파일러 버전으로 개발된 많은 application을 cover하는 것은 쉽지 않다.

반면 machine-code-based symbolic execution engine은 복잡하지만 아키텍처마다 한번만 구현하면 된다.

#### Compiler and post-build transformations
실제로 출시된 binary code에서 symbolic execution을 수행함으로서 SAGE는 대상 프로그램 뿐만 아니라 컴파일, 후처리 과정에서 발생할 수 있는 버그를 포착할 수 있게 한다.

예를들어 코드 난독화 도구나 base block transformer와 같은 도구는 source code와 bianary code사이으 미묘한 차이를 발생시킬 수 있다.

#### Unavailability of source
source code를 얻기 어려울 수 있다. source-based 계측은 self-modifying, JITed(Just-In-Time compiled) 코드에 대해서 어려울 수 있으나 SAGE는 machine code level에서 작업함으로 이러한 문제를 해결할 수 있다.

물론 source code에는 machine code에서 즉시 보이지 않는 타입과 구조에 대한 정보가 있지만 SAGE의 path search에는 이 정보가 필요하지 않다.
### 3.2.2 Offline Trace-Based Constraint Generation
SAGE는 online 계측 대신 offline trace기반의 constraint generation을 사용한다. online generation은 프로그램이 실행될때 정적으로 주입된 계측 코드나 *Nirvana*, *Valgrind*와 같은 static binary 계측도구를 이용하여 constraint가 생성된다.

SAGE가 offline trace-based constraint generation을 사용하는것은 두가지 이유 때문이다.
1. 프로그램은 OS에 의하여 보호되거나 난독화될 수 있는 binary 요소들을 포함할 수 있어 계측된 버전으로 교체하기 어려울 수 있다.
2. 프로그램의 비결정성은 online constraint generation의 디버깅을 어렵게 만든다. constraint generation engine에 문제가 발생한다면 이를 재현하기 어려울 것이기 때문이다. SAGE에서 constraint generation은 실행시간 동안 모든 비결정적 이벤트의 결과를 기록하는 execution trace에서 작동하기에 완전히 결정론적이다.

## 3.3 Constraint Generation
### Symbolic Tag
SAGE는 프로그램의 concrete and symbolic state를 각 메모리 위치와 레지스터를 byte-sized value와 symbolic tag를 각각 연결하여 한쌍으로 저장한다.
symbolic tag는 input vlaue나 어떤 값의 함수를 나타내는 표현식이다.

SAGE는 여러 종류의 tag를 지원한다.
- input(m) input의 m번째 바이트
- c : 상수
- t1 op t2 : t1과 t2의 연산(op)값
- sequence tag <t0...tn> : t0...tn에서 내는 byte-size값을 그룹화 하여 얻은 word, double-word 크기의 값
- subtag (t,i) : word, double-word 크기의 t중 i번째 byte의 값

SAGE는 symbolic pointer dereference를 추론하지 않는다.
SAGE는 비 상수 symbolic tag마다 새로운 symbolic variable을 정의한다. SAGE가 프로그램 trace를 재생할때 방문한 각 명령어의 의미에 따라 concrete and symbolic 저장소를 업데이트한다.

SAGE는 symbolic tag propagation을 수행하는것 이외에도 input vlaue에 대한 constraint를 생성한다. constraint는 symbolic variable간의 관계를 나타낸다.

예를 들어 input(4)에 해당하는 변수 x가 주어졌을때 x<10은 입력의 다섯번째 바이트가 10보다 크다는 뜻이다.

input에 의존하는 conditional jump를 만나면 분기의 결과를 모델링하는 constraint를 생성하고 지금까지 만난 contraint로 구성된 path constraint에 추가한다.

###  Tracking Symbolic Tag and Collecting Constraints
다음은 symbolic tag를 추적하고 constraint를 수집하는 과정을 보여준다.

``` assembly
# read 10 byte file into a
# buffer beginning at address 1000

mov ebx, 1005
mov al, byte [ebx]
dec al                  # Decrement al
jz LabelForIfZero       # Jump if al == 0
```
1. 10byte의 파일을 읽어서 1000번지 주소에 저장한다.
이 명령어를 실행함에 따라 SAGE는 주소 1000~1009를 symbolic tag input(0)~input(9)와 연결하여 symbolic 저장소를 업데이트한다. 
2. mov 명령어는 6번째 입력 바이트를 al레즈스터로 로드한다. 명령어를 재생한 후 SAGE는 al을 input(5)dp mapping하는것으로 symbolic 저장소를 업데이트한다.
3. 마지막 두 명령언s al을 감소하고 감소된 값이 0이면 LabelForIfZero로 conditional jump를 수행한다. 분기의 결과에 따라 두가지 constraint중 하나를 추가한다. (t=input(5)-1 -> t=0 or t=1 추가)

### Conditional Jump
이는 x86 machine instruction 으로부터 constraint를 형성하는데 있어서 주요 문제중 하나로 이어진다. conditional expression에서 비교과 이루어질때 그것이 어떻게 conditional jump에 사용되는지 알 수 없다.

### EFLAG
프로세서에는 CF,SF,AF,PF,OF,ZF와 같은 EFLAG가 존재한다.
EFLAG는 다양한 명령어의 결과에 따라 결정된다 예를들어 CF는 산술연산간 carry가 발생하였다면 1로 설정된다.

EFLAG의 처리를 위해 SAGE는 n비트의 값으로 *f*0...*f*n-1에 따라 설정된 비트를 나타네는 bit vector tag <*f*0...*f*n-1>을 정의한다.

위의 예시에서 SGAE가 dec명령어를 실행할떄 al과 EFLAG에 대한 symbolic 저장소의 mapping을 업데이트 한다(t=input(5)-1, CF,ZF).

### Casting
x86에서 자자주 사용되는 관행은 byte, word, double word간의 casting이다. 테스트 대상 프로그램의 코드에 명시적인 casting이 포함되지 않더라도 atol, malloc, memcpy등 run-time library에서 casting을 수행하는 함수를 호출하게 된다.

SAGE는 subtag와 sequence tag를 이용하여 casting의 정확한 처리를 구현한다.

```
mov ch, byte [...]
mov cl, byte [...]
inc cx              # Increment cx
```

두개의 명령어가 symbolic tag t1,t2와 관련된 주소를 읽을때 SAGE가 명령어를 재생할때 symbolic 저장소는 cl->t1, ch->t2으로 mapping을 업데이트한다. 다음 명령어는 cx를 증가한다 cx는 16bit 레지스터로 cl과 ch를 포함한다.

증가하기 전에 cx의 내용은 <t1,t2>로 표현할 수 있다. 증가한 후 cx는 t=<t1,t2+1>로 표현할 수 있는데 inc를 마무리하기 위하여 SAGE는 symbolic 저장소의 byte크기의 maaping을 cl->subtag(t,0), ch->subtag(t,1)로 업데이트 한다.

SAGE는 symbolic 저장소를 byte크기로 다음과 같이 인코딩하여 mapping한다.

    x=x'+256*x', where x=t, x'=subtag (t,0), x''=subtag(t,1)

## 3.4 Constraint Optimization
### Standard Optimization
SAGE의 constraint generation의 속도와 메모리 사용을 향상시키기 위하여 몇가지 최적화 기법을 사용한다.

    1. Tag Caching : 구조적으로 동등한 tag들이 동일한 physical object에 mapping되도록 한다.
    2. unrelated constraint elimination : 부정된 constraint와 symbolic variable을 공유하지 않는 constraint를 제거함으로서 constraint solver의 크기를 줄인다.
    3. local constraint caching : 이미 path constraint에 추가된 constraint는 건너 뛴다.
    4. flip count limit : 특정 명령어에서 생성된 constraint가 몇번 flip가능한 최대 횟수를 설정한다.
    5. concretization : 여러 명령을 포함하는 symbolic tag를 concerete value로 줄인다.

이러한 최적화는 dynamical test generation에서 표준적인 방법이다. 이 섹션의 나머지 부분은 structured-file parsing application에 대한 최적화에사용되는 constraint subsumption(가정)에 대해서 설명한다. 

### Constraint subsumption
constraint subsumption은 주어진 분기 명령에서 셍성된 constraint를 추적하여 새로운 constaint *f*가 생성될때 SAGE는 빠른 syntactic check를 통하여 *f* 다른 constaint를 함축하거나 같은 명령에서 생성된 다른 constraint에 의해 함축되는지 판단하고 함축된다면 path constraint에서 제거된다.

subsumption 최적화는 다양한 image parser및 미디어 플레이어와 같은 structured file을 처리하는 많은 프로그램에 중요한 영향을 미친다.

### Constant Folding
다음과 같은 예제를 확인해보자
```
mov cl, byte [...]
dec cl              # Decrement cl
ja 2                # Jump if cl > 0
```
이 코드는 cl에 바이트를 로드하고 0이 될때까지 loop에서 감소시킨다. mov 명령에 의해 읽힌 바이트가 symbolic tag t0에 매핑된다고 하자. 3.3절에서 설명한 알고리즘은 다음과 t1>0,...,tk-1>0과 tk<=0을 생성한다. 여기서 k는 로드된 바이트의 구체적인 값이고 ti+1=ti-1이다.

반복마다 새로운 constraint와 symbolic tag를 생성하기 때문에 메모리는 루프 반복횟수에 선형적이다.

여기서 subsumption을 사용한다면 첫 k-2개의 constraint는 다음 constraint에 의해 축약되기 때문에 제거할 수 있다. 우리는 symbolic tag는 선형적인 수로 유지해야 한다. 왜냐하면 각 tag는 이전 tag에 대한 조건으로 정의되기 때문이다.

이를 상수 크기의 공간으로 동작을 하기 위해서는 tag 생성중 constand folding을 수행해야한다. : (t-c)-1=t-(c+1)

constraint subsumption과 constant folding을 적용한다면 다음 두가지 constraint를 갖는 path constraint가 된다.

    t0-(k-1)>0 and t0 -k <=0

### sequence tag simplification
만약 multi-byte에 대해서는 또 다른 문제가 있다 다음 예제를 보자 위 예시와 비슷하지만 cl이 아닌 cx로 대체되었다.
```
mov cx, word [...]
dec cx              # Decrement cx
ja 2                # Jump if cx > 0
```
mov 명령에 의해 읽힌 두 바이트가 t'0 ,t''0에 메핑된다고 가정한다면 다음과같은 constraint를 생성한다
    
    s1>0,...,sk-1>0 and sk<=0 where si+1 = <t'0,t''0>-1

이때 constant folding은 어려워진다. 왜냐하면 각 루프 반복은 syntatically unique하지만 의미적으로는 중복되는 word-size sequence tag이기 때문이다.

SAGE는 sequence tag simplification을 지원한다. <subtag(t,0), subtag(t,1)>를 t로 재작성하여 동등한 tag를 피하고 constant folding을 지원한다.

constraint subsumption, constant folding, sequence tag simplification은 위에서 생성된 constraint를 상수공간에서 재생하는것을 보장해 준다.

이 세가지 방법은 SAGE가 structured-file-parsing application을 효과적으로 fuzzing하도록 한다.
# 4. Experiments
Sblackbox fuzz에서 놓친 버그를 SAGE가 찾아낸것을 걸명한다. 두 memdia parsing application에서 SAGE의 행동에 대한 더 체계적인 연구룰 추구한다. 
- initial inpuy file의 중요성
- generational search vs DFS 
- block coverage heuristic의 효과
## 4.1 Initial Experiences
### MS07-017
MS는 ANI(애니메이션 커서 파일)을 parsing하는 코드에서 중요한 보안 패치를 발표했다. 이 코드에 대한 광범위한 blackbox fuzz testing을 하였지만 버그를 발견하지 못하였고 기존 static analysis 도구들은 과도한 거짓 false positive 없이 버그를 찾을  수 없었다. 하지만 SAGE는 well-formed ANI file에서 시작하여 몇시간 내에 버그를 드러내는 새로운 input file을 만들어 내었다.

이 취약점은 ANI parsing code와 관련된 MS05-006에 대한 불완전한 패치로 인하여 생성되었다. 이 버그의 근본 원인은 ANI파일의 *anih* rdcord 에서 읽은 size parameter에 대한 검증을 못한 것이다. 이 패치는 첫번째 *anih* record만 확인하였고 파일에 36byte이하의 초기 *anih* record가 있으면 이후 모든 *anih* record에 대한 아이콘 로딩 함수가 호출된다. 두번째 이후 recode의 길이가 확인되지 않으므로 memory corruption이 발생할 수 있다.

testcase는 최소한 두개의 *anih* record가 필요하다. blackbox fuzz testing이 MS07-017을 발견하지 못한 이유는 testing에 사용된 모든 seed file이 하나의 *anih* record만을 가지고 있기 때문이다. 물론 blackvox fuzz testing을 위해 여러 testcase를 생성하는 grammar를 사용할 수 있지만 노력이 필요하고 ANI format을 넘어 일반화할 수 없다.

반면 SAGE는 ANI format에 대한 지식 없이 하나의 *anih* record를 가진 well-formed ANI 파일에서 시작하여 MS07-017을 생성하는 입력을 생성할 수 있다. seed file은 잘성성된 ANI 파일 라이브러리에서 임의로 생성되었으며 *user32.dll*을 호출하여 ANI 파일을 parsing하는 작은 test driver을 사용하였다. 아래는 crash test case이다.

```
SEED
RIFF...ACONLIST
B...INFOINAM....
3D Blue Alternat
e v1.1..IART....
................
1996..anih$...$.
................
................
..rate..........
..........seq ..
................
..LIST....framic
on......... ..

CRASH
RIFF...ACONB
B...INFOINAM....
3D Blue Alternat
e v1.1..IART....
................
1996..anih$...$.
................
................
..rate..........
..........seq ..
................
..anih....framic
on......... ..
```
### Compressed File Format
SAGE의 alpha 버전을 이용하여 압축 파일 형식을 처리하는 코드에서 버그를 찾도록 하였다. 이 parsing code는 blackbox fuzzing tool을 이용하여 테스트 되었지만 SAGE는 다음 두가지 새로운 버그를 찾았다.
- Stack Overflow 
- CPU를 100% 사용하게 하는 무한루프
### Media File Parsing
SAGE를 널리 사용되는 4가지 media file format parser에 적용하였다. 이를 Media 1,2,3,4라 하자.
SAGE는 100개의 0x00으로 시작한 seed를 이용하여 각 Media File에서 충돌을 발견하여 9개의 bug reports를 생성하였다. 
### Office 2007 Application
SAGE는 Office 2007의 large application에 대한 crash test case를 생성했다. 이는 NULL포인터 역참조 오류들이다. 이는 SAGE가 large scale의 프로그램에 대해서 성공적임을 보여준다.
### Image Parsing
SAGE를 이용하여 media player의 image parsing code를 테스팅하였다. 초기에 충돌을 찾지 못하였지만 내부 도구를 사용하여 SAGE-generated test case를 추적하여 여러 uninitialized value use error를 발견하였다. 이 결과를 재현 가능한 충돌로 확장 가능하였다. 즉 SAGE는 즉시 충돌로 이어지지 않는 심각한 버그를 발견할 수 있었다.
## 4.2 Experiment Setup
### Test Plan
널리 사용되는 Media 1,2 parser에 초점을 맞추었다. Media 1 parser에 대해 test media file liabrary에서 선택된 5개의 well-formed media file로 SAGE를 실행하였다. Media file은 다음과 같은 5개의 "bogus" 파일로실행하였다.

|bogus| contents|
|:---:|:---:|
|1|\x00 * 100|
|2|\x00 * 800|
|3|\x00 * 25600|
|4|rand * 100|
|5|rand * 100|

이 10개의 파일에 대하여 10시간씩 SAGE를 실행하였다. 충돌을 찾은 경우 bloc coverage heuristic을 비활성화하고 다시 10시간 실행하였다. 

각 SAGE serach는 heap memory error을 확인하기위하여 *AppVerfier*를 사용하였다. error가 발생할때마다 *AppVerfier*는 테스트중인 application에서 crash를 발생시킨다. 이후 crashing test case, seed input에 의해 cover된 block의 수, 검색 과정에 추가된 code block의 수를 수집하였다. 
### Triage
SAGE는 동일한 버그를 나타내는 많은 test case를 생성할 수 있으므로 crashing file 을 *stack hash*를 이용하여 "bucket"하였다. 이는 오류 발생 명령의 주소를 포함며 동일한 원인으로 인해 다양한 경로로 발생한 버그에 대해서 같은 버그인지 분류하는 역할을 수행한다.
### Nondeterminism in Coverage Results
실험의 일부로 test 실행중 cover된 block의 수를 측정하였다. 동일한 초기 프로그램에서 동일한 실행을 하더라도 약간의 다른 initial coverage가 나올 수 있다는것을 관찰하였다. 이는 test application을 사용하는 DLL을 로드하고 초기화하는 과정에서 발생하는 nondeterminisim 때문이라고 생각한다.

## 4.3 Results and Observations
부록에는 실험 결과의 표가 있다. 여기서 우리는 몇가지 일반적인 관찰사항에 대해서 설명한다. 이러한 관찰사항은 두개의 application에 대한 제한된 샘플 크기에서 얻어진것이므로 주의해서 받아들여야 한다.
### Symbolic execution is slow
각 검색에서 symbolic execution에 소요된 시간을 측정하였다. symbolic excution에 소요되는 시간이 프로그램 testing이나 tracing 하는것보다 훨씬 더 많이 걸린린다. 예를들어 Media2 검색에서 wtf-3로 실행된 symbolic execution의 평균 실행 시간은 25분 30초이고 testing에 소요된 시간은 몇초이다. 왜냐하면 각 작업은 많은 test case를 생성하였기 때문이다. 하지만 전체 실행 시간은 25%에 불과하다 generational search가 symbolic execution을 효율적으로 활용함을 보여준다.
### Generational search is better than depth-first search
- DFS를 사용하여 execution 하였을때 pathological divergence이 발생하였다. 이것은 path constraint의 AND 연산자를 구체화 하는것에 의해 발생하였다. 
  
- coverage와 관련하여도 geneartional search에 비해서 더 적은 것을 확인할 수 있었다. DFS가 localized하기 때문이다.반면 generational search의 경우 모든 depth에서 실행 분기를 탐색하여 프로그램의 레이어를 동시에 탐색한다. 

- DFS가 symbolic execution에 더 많은 시간을 소비한다.
### Divergences are common
기본적인 test 설정에서 divergence를 측정하지 않았고 몇가지 측정용 test case를 실행하여 diveergence rate를 측정하여따 종종 60%넘기도 하였다. 이는 실험 설정에서 효율성을 위하여 non-linear operation (곱셈 나눗셈, 비트연산)을 구체화 하기 때문일 수 있다. 또한 아직 emulate하지 않은 x86 명령들이 존재하며 pointer의 dereference 에 대한 모델을 만들지 않았기 때문이다. 

symbolic variable을 tracking하는것은 불완전할 수 있읏고 위에 언급한 snondeterministic한 요소를 제어하기 때문이다.

그럼에도 SAGE의 검색 기술이 divergence를 허용함을 확인할 수 있었다.
### Bogus files find few bugs
우리는 well-formed, bogus seed에서 발생한 crash data를 수집하였다. 각 시드 파일로 발견된 버그는 stack hash에 따라 나타내었다. 이 결과를 살펴보면 well-formed 파일을 initial로 하여야 fuzz testing이 잘 된다는 전통적인 지혜가 whitebox fuzzing에도 적용됨을 확인할 수 있었다.
### Different files find different bugs
Media 1,2의 경우 bug를 찾은 well-formed file이 하나가 아니라는 것을 확인할 수 있었다. 각 search가 불완전 하기에 많은 well-formed file을 사용하는것이 중요하다.
### Bugs found are shallow
각 seed file에 대하여 최대한 많은 generation을 수집하였다. 그런 다음 충돌이 발생한 버킷중 가장 마지막으로 찾은 generation을 확인하였다. media 1의 경우 4 generation 이내에 모든 버그를 찾았고 최대 generation은 5~7까지 다양하다.

즉 이러한 검색에서 찾은 대부분의 버그는 shallow하다. 적은 수의 generation에 도달할 수 있다. 이는 작은 generation에서도 확장할 후보 입력이 많고 나중 세대의 많은 테스트의 coverage score가 낮기 때문이다.
### No clear correlation between coverage and crashes
coverage 증가가 새로운 버그관련과 관련이 있지만 모든 경우에 일관되게 관찰되지는 않았다.
### Effect of block coverage heuristic
다음 child를 선택하기위하여 block coverage heuristic을 사용을 한 테스트와 사용하지 않은 실행을 비교해본 결과 사용한 경우가 훨씬 많은 block을 추가함을 확인할 수 있었다.
# 5. Other Relate Work
## Input Grammar
최근 fuzz testing에 있어서 많은 개발이 있었다. 하지만 이들은 대부분 가능한 input을 표현하기위한 *grammar*를 사용하였다. 또한 input을 생성할때 확률적 가중치를 할당하여 random test input generation을 위한 heuristic으로 사용할 수 있다. 이러한 가중치는 가벼운 동적 프로그래밍 계측을 사용하여 수집된 coverage data를 사용하여 자동의로 정의되거나 수정될 수 있다. 이러한 *grammar*또한 입력 검증 코드에서 흔히 발생하는 함정을 테스트 하기위한 규칙 (긴 문자열 ,NULL값 포함)을 포함 할 수 있다.

input grammar의 사용은 application-specific knowledge를 사용하고 다른 영역에 비해 특정 input space의 영역을 선호하는 test guideline을 만드는 것을 가능하게 한다. 순수 무작위 테스팅을 통하여 버그를 찾는 확률은 매우 작기 때문에 blackbox fuzzing을 가능하게 하는데 핵심적인 역할을한다. 하지만 grammar를 수동으로 작성하는것은 비용이 많이들고 확장성이 떨어진다.

하지만 SEGA는 input grammar가 필요 없다. 하지만 주어진 search를 위한 initial seed file을 중요하게 생각한다. 이러한 seed file은 blackbox fuzzing에 사용되는 grammar를 사용하여 생성된다.

또한 blackbox fuzz가 symbolic execution과 constraint solving의 비용 때문에 whitebox fuzz보다 더 빠른 속도로 새로운 테스트 케이스를 실행한다.
그리고 whitebox fuzzing의 symbolic executinon의 부정확성 때문에 whitebox fuzzing에서 발견하지 못한 새로운 path를 찾을 수 있다.

##  Generational Search Algorithm
이 논문의 접근 방식은 dynamic test generation 작업에 기반을 두고 있다. 주요 차이점은 heuristic을 사용하는 generational serach algorithm을 사용하고 large application을 테스트 한다는 것이다. trace-based x86-binary symbolic excution에 의해 가능하다. 이러한 차이점으로 dynamical test generation 보다 더 많은 버그를 발견할 수 있었다.

SAGE은 dynamic taint analysis를 사용하는 도구와도 다르다. 이러한 도구는 false positive 가 발생할 수 있지만 symbolic execution은 static analysis의 핵심 구성 요소이다.

static analysis 일반적으로 dynamic analysis보다 효율적이지만 정확도가 떨어지면 이둘은 상호보완적이다. static test generation은 특정 프로그램 경로를 따라가기위해 input vlaue를 계산하려고 시도하지만 프로그램을 실제로 실행하진 않는다. 반면 dynamic test generation은 추가적인 runtime information이 있기에 더 일반적이고 강력하다. 
# 6. Conclusion

우리는 dynamic test generation을 위한 새로운 탐색 알고리즘인 generational serach 를 도입하였다. 이 알고리즘은 divergences를 허용하고 비용이 많이드는 symbolic execution 을 더 잘 사용한다.

SAGE는 이 알고리즘을 통하여 Windows에서 실행되는 다양한 x86코드에서 버글르 찾아내었다.

SAGE의 행동을 잘 이해하기위한 실험에 있어서 well-formed input file을 사용하는것이 버그를 찾는것에 있어서 중요하다는걸 발견하였다.

또한 탐색된 세대의 수가 block coverage보다 중요하다는 것을 알게되엇다.  특히 발견된 대부분의 버그들은 낮은 세대에서 발견되었다.

이러한 결과는 제한된 크기의 셈플에서 나온것이므로 신중하게 다루어야 하지만 새로운 탐색 전략을 제시한다.

정해진 시간동안 실행하는 대신 초기 seed file에서 작은 수의 세대를 탐색하고 이 test case가 소진되면 새로운 seed file로 넘어갈 수 있다.

이러한 전략은 발견한 버그의 다른 경로를 찾는 "tail"을 잘라내고 같은 시간에 더 많은 고유한 버그를 찾을 수 있을지도 모른다.

향후 연구에서 이 탐색 방법을 실행하여 우리의 block-coverage hueristic을 다른 seed file에 적용하여 동일한 코드를 여러번 탐색하는것을 피해야 한다.

중요한 부분은 code coverage만 사용할때보다 depth와 code coverage의 좋바이 더 나은 지표인지 확인해야 한다.





# 7. 의문점
- 후속 연구
- 소스코드를 볼 수 있을까?
- 유망한 (workList 상단) test case가 꼭 input을 bug를 trigger할 가능성이 높은 input일까? score봐야할지도?
-  