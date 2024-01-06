---
title: "4. 중간 점검"
date: 2024-01-07T05:52:58+09:00
#weight: 1
# aliases: ["/first"]
tags: ["Hugo", "Papermod"]
categories: ["2024", "Blog"]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: true
draft: false # 글쓰기 아이콘
hidemeta: false # 시간, 작성자 등 
comments: true
#description: "부제목" #부제목
canonicalURL: "https://canonical.url/to/page"
disableHLJS: false # to disable highlightjs
disableShare: true # 아래 공유 관련 sns 메뉴 
hideSummary: false #home에서 글 내용 안보이게
searchHidden: false #글 검색 허용
ShowReadingTime: false # 읽은 시간
ShowBreadCrumbs: true # Home >> posts 내용
ShowPostNavLinks: true
ShowWordCount: false # 단어 수
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

## 1. 소감
하루동안 "돌아는 가는" 웹사이트를 만들었다. 

웹에 대한 지식이 전무하기 때문에 많은 시행착오가 있었던것 같다. 

truouble shooting 과정에서 Papermod 위키를 10번은 읽은것 같다.

아직 다음과 같이 해결해야할 문제가 남아있다.

## 2. 해결해야 하는 문제
>prev/next가 뜻과 반대로 작용함

다른 사람의 repository를 본 결과 theme의 자체적 문제일 가능성이 높아보임

> blog 제외한 menu 에서 prev/next 버튼이 없음

menu 시스템을 다시 한번 손봐야 할것 같음

> 이미지 첨부 안됨

가장 큰 문제인데 상대 경로를 통한 이미지 첨부가 안됨
```.md
    ![img](./../../themes/PaperMod/images/screenshot.png)
```
![img](./../../themes/PaperMod/images/screenshot.png)
웹에서 받아오는건 됨
```.md
    ![img](https://i.pinimg.com/474x/4b/e5/f3/4be5f377959674df9c2fe172df272482.jpg)
```
![img](https://i.pinimg.com/474x/4b/e5/f3/4be5f377959674df9c2fe172df272482.jpg)
## 3. 추가하고싶은 기능

> 댓글 기능 구현

static site의 특성상 댓글이 기본 기능으로 없음, Utterance를 사용하면 구현할 수 있음


> 방문자수 확인

Hits나 Google Analasys를 이용하여 구현할 수 있을것 같음, 난이도가 낮아보임

