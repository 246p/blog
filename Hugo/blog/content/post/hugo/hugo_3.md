---
title: "3. Papermod 설정"
date: 2024-01-07T05:08:36+09:00
#weight: 1
# aliases: ["/first"]
tags: ["Hugo", "Papermod", Blog]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: true
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
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

## 1. hugo.yaml
사이트의 전반적인 설정을 저장하는 설정이다. [예시 코드](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#sample-configyml)
``` yaml
baseURL: "https://246p.github.io/" #기본주소
title: Junlog #이름
paginate: 5
theme: PaperMod

enableRobotsTXT: true
buildDrafts: false
buildFuture: false
buildExpired: false

googleAnalytics: UA-123-45

minify:
  disableXML: true
  minifyOutput: true

params:
  env: production # to enable google analytics, opengraph, twitter-cards and schema.
  title: Junlog
  description: "MJ's Study Log"
  keywords: [Blog, Portfolio, PaperMod]
  author: Kim-Minjoon
  # author: ["Me", "You"] # multiple authors
  images: ["<link or path of image for opengraph, twitter-cards>"]
  DateFormat: "January 2, 2006"
  defaultTheme: dark # dark, light
  disableThemeToggle: true
  sectionPagesMenu: true
  ShowReadingTime: false
  ShowShareButtons: false
  ShowPostNavLinks: true
  ShowBreadCrumbs: true
  ShowCodeCopyButtons: true
  ShowWordCount: false
  ShowRssButtonInSectionTermList: true
  UseHugoToc: true
  disableSpecial1stPost: false
  disableScrollToTop: false
  comments: false
  hidemeta: false
  hideSummary: false
  ShowToc: true
  TocOpen: true
  
  assets:
    # disableHLJS: true # to disable highlight.js
    #disableFingerprinting: true
    favicon: "<link / abs url>"
    favicon16x16: "<link / abs url>"
    favicon32x32: "<link / abs url>"
    apple_touch_icon: "<link / abs url>"
    safari_pinned_tab: "<link / abs url>"

  label:
    text: "HOME"
    icon: /apple-touch-icon.png
    iconHeight: 35

  profileMode:
        enabled: true
        title: "Hello World"  # optional default will be site title
        subtitle: "Welcome to MJ`s Blog"
        imageUrl: "" # optional
        imageTitle: "" # optional
        imageWidth: 120 # custom size
        imageHeight: 120 # custom size

  socialIcons:
    - name: github
      url: "https://github.com/246p"
    - name: linkedin
      url: "https://www.linkedin.com/in/minjoon-kim-9823101a7/"
    - name: instagram
      url: "https://www.instagram.com/minjunkinn/"

  analytics:
    google:
      SiteVerificationTag: "XYZabc"
    bing:
      SiteVerificationTag: "XYZabc"
    yandex:
      SiteVerificationTag: "XYZabc"

  cover:
    hidden: true # hide everywhere but not in structured data
    hiddenInList: true # hide on list pages and home
    hiddenInSingle: true # hide on single page

  fuseOpts:
    isCaseSensitive: false
    shouldSort: true
    location: 0
    distance: 1000
    threshold: 0.4
    minMatchCharLength: 0
    keys: ["title", "permalink", "summary", "content"]
menu: # 메뉴에서 이중 디렉토리는 불가능함
  main:
    - identifier: POST
      name: POST
      url: /post/
      weight: 10
    - identifier: hacking
      name: hacking
      url: /hacking/
      weight: 20
    - identifier: blog
      name: blog
      url: /blog/
      weight: 30
    - identifier: CV
      name: CV
      url: https://docs.google.com/document/d/1ZByTPJ0BOfy14Zpwjisc0QT0JuTDOpcl/edit?usp=sharing&ouid=104987107477019496766&rtpof=true&sd=true
      weight: 40
pygmentsUseClasses: true
markup:
  highlight:
    noClasses: false
    # anchorLineNos: true
    # codeFences: true
    # guessSyntax: true
    # lineNos: true
    # style: monokai
```
## 2. Page.md
게시물을 작성할때 페이지의 정보에 대한 설정이다. [예시코드](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#sample-pagemd)

``` yaml
title: "1. Hugo 시작"
date: 2024-01-06T18:12:26+09:00
#weight: 1
# aliases: ["/first"]
tags: ["Hugo", "Papermod", Blog]
author: "Kim-Minjoon"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: true
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
UseHugoToc: true

cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---
```
## 3. default.md

blog/archetypes/defaul.md 파일에 새로 생성되는 파일에 대한 기본 설정을 저장할 수 있다.
``` yaml
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
```