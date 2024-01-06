---
title: "2. MarkDown 문법"
date: 2024-01-07T05:05:14+09:00
#weight: 1
# aliases: ["/first"]
tags: ["blog", "Markdown"]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: false
TocOpen: false
draft: false # 글쓰기 아이콘
hidemeta: false # 시간, 작성자 등 
comments: false
#description: "부제목" #부재목
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
UseHugoToc: false
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

## 0. Markdown이란
[github](github.com)에 들어가본 사람이라면 한번쯤 .md 확장자 파일을 본 적 있을 것이다.
markdown은 간단한 문법으로 쉽게 쓰고 읽을 수 있다. 다음과 같은 장단점이 존재한다.
>장점
- 간결하다
- 텍스트 에디터로 쉽게 작성 가능하다.
- 다양한 프로그램과 플랫폼에서 활용할 수 있다.
> 단점
- 표준이 없다.
- 모든 HTML을 표기할 수 없다.
## 1. 문법
- Header

다음과 같이 제목을 표기할 수 있다.
```
    # Header 1
    ## Header 2
    ### Header 3
```
# Header 1
## Header 2
### Header 3

- BlockQuote
```
>first
> > second
> > > third
```

>first
> > second
> > > third

- List
```
1. first
2. second
3. third
```

1. first
2. second
3. third

순서를 바꾸어도 순서'만' 정렬된다.
```
1. first
3. third
2. second
```

1. first
3. third
2. second

- 순서없는 list (*, +, -)
```
* first
    * second
        * third
```

* first
    * second
        * third

- code

다음과 같이 코드 들여쓰기를 할 수 있다.
```
    ```c
    printf("hello world\n");
    ```
```
```c
    printf("hello world\n");
```

- vertical bar

```
---
***
```
---
***

- link

```
    [Title](link)
    [Google](https://google.com)
```


[Google](https://google.com)

## 2. 사용되는곳
가볍고 많은곳에 사용된다는 점에 있어서 Github, Stack Overflow, Velog, Obsidian, Discord 등 개발자가 많이 사용하는 플렛폼에서 많이 사용된다.