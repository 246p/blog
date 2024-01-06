---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
#weight: 1
# aliases: ["/first"]
tags: ["Tag"]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: true
draft: false # 글쓰기 아이콘
hidemeta: false # 시간, 작성자 등 
comments: false
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

