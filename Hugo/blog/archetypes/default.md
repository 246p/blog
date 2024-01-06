---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
#weight: 1
# aliases: ["/first"]
tags: ["Tag"]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true # 목차
TocOpen: false #목차
draft: true # 글쓰기 아이콘 어디 사용되는지 모르겠음
hidemeta: false # 시간, 작성자 등 
comments: false
description: "부제목"
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: false
ShowReadingTime: false # 읽은 시간
ShowBreadCrumbs: true # Home >> posts
ShowPostNavLinks: true
ShowWordCount: false # 단어 수
ShowRssButtonInSectionTermList: treu
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

