---
title: "Install_hugo"
date: 2024-01-06T18:12:26+09:00
#weight: 1
# aliases: ["/first"]
tags: ["Hugo", "blog"]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false # 글쓰기 아이콘
hidemeta: false # 시간, 작성자 등 
comments: false
description: "부제목" #부재목
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
editPost: 
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---
먼저 github.io를 이용하여 블로그를 구축하기위해서 SSG(Static Site Generator)를 정해야 한다.
대표적으로 Jkelly(Ruby), Eleventy(Node.js), Hugo(Go) 중 Hugo를 선택하였다. 한국어 레퍼런스가 부족하다는 단점이 있지만 속도측면에서 가장 빠르기 때문이다.

이 글은 Mac 사용자를 기준으로 작성되었다.

1. hugo 설치

먼저 home brew를 이용하여 hugo를 설치해야 한다.
```.sh
brew install hugo
```
만약 home brew가 설치되어 있지 않다면 다음 명령을 사용하자
```.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. github repository 만들기
hugo 를 이용하여 사이트를 제작하기 위해서는 repository 2개가 필요하다.

- blog : 사이트를 빌드 하기 위한 파일들을 저장한다.

- 246p.github.io : 빌드된 사이트의 코드를 저장한다.

다음과 같이 생성하였다.



3. 
```
hugo new site blog
```

```hello.c
printf("hello world\n");
```