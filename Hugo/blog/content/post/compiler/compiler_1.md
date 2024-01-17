---
title: "1. overview"
date: 2024-01-10T17:42:23+09:00
tags: ["컴파일러"]
draft: false
categories: ["2024", "컴파일러"]
---
## 컴파일러란?
컴파일러는 source language를 target language로 변환한다.

일반적으로 source = high-level, target = low-level 이다.
ex) C -> machine code

## Compiler vs Interpreter

Compiler는  input program을 executable form으로 변환한다.

반면 Interpreter는  input program을 실행한다.

## Compier
컴파일러는 세가지 과정으로 구분할 수 있다.Front-end -> Middle-end -> Back-end 

### Front-end 
1. Lexer (lexical analysis)
문자열을 token단위로 나눈다.
> x=y+10; -> VAR "X", ASSIGN, VAR "y", PLUS, CONST 10
2. Parser (syntax analysis)
abstract syntax tree (AST)를 생성한다.
3. Type Checker (semantic analysis)
AST를 분석하여 type이 알맞은지 확인한다.
4. IR Generator 로 이루어져 있다.
AST를 IR로 변환한다.

### Middle-End
실행 시간, 코드 크기, 메모리 사용량 등을 고려하여 IR을 최적화한다.

### Back-End 
IR을 target language로 변환한다.  이때 Target-dependent optimization 이 일어난다
