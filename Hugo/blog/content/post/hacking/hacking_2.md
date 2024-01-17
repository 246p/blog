---
title: "2. Introduction to Software Vulnerability"
date: 2024-01-10T23:10:32+09:00
tags: ["해킹", "작성중"]
draft: false
categories: ["2024","해킹"]
---

## Bug and Vulnerability
- Bug : error in program that make it malfunction
- Vulunerability : bug that causes security issues

![Bug](https://github.com/246p/blog/blob/main/Hugo/blog/content/post/hacking/image/2.Bug.png?raw=true)


## Buffer Overflow & Memory Corruption
C has no automatic check on array boundary
- Allow writing past the end of an array
- Buffer OverFlow
- corrupt other variables and data in memory

## Setuid Bit (SUID)
Linux 환경에서 passwd 명령을 입력하면 /etc/passwd 에 저장된 정보를 변경한다.

/만약 /etc/passwd 명령어가 

