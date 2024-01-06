---
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


## 들어가며
먼저 github.io를 이용하여 블로그를 구축하기위해서 SSG(Static Site Generator)를 정해야 한다.
대표적으로 Jkelly(Ruby), Eleventy(Node.js), Hugo(Go) 중 Hugo를 선택하였다. 한국어 레퍼런스가 부족하다는 단점이 있지만 속도측면에서 가장 빠르기 때문이다.

이 글은 Mac 사용자를 기준으로 작성되었다.


## hugo 설치하기

먼저 home brew를 이용하여 hugo를 설치해야 한다.
```.sh
brew install hugo
```
만약 home brew가 설치되어 있지 않다면 다음 명령을 사용하자
```.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## github repository 만들기

hugo 를 이용하여 사이트를 제작하기 위해서는 repository 2개가 필요하다.

- blog : 사이트를 빌드 하기 위한 파일들을 저장한다.

- 246p.github.io : 빌드된 사이트의 코드를 저장한다.


## 사이트 생성하기
```
hugo new site blog --format yaml
```

원하는 테마를 고른다 테마는 [다음 사이트](https://themes.gohugo.io/)에서 확인할 수 있다.

나는 마이너한 언어기도 하고 한글로 작성된 블로그가 잘 없어서 기술문서가 상세히 작성된 [Papermod](https://themes.gohugo.io/themes/hugo-papermod/)를 선택하였다. -[WiKi](https://github.com/adityatelange/hugo-PaperMod/wiki)

테마를 적용한다.
```.sh
git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod --depth=1
echo "theme: Papermod" >> hugo.yaml
```


이제 로컬 환경에서 만들어진 사이트를 시험해본다.
```.sh
git hugo server -D
```

localhost:1313 에 접속하여 사이트가 작동되는지 확인할 수 있다.


## github에 업로드하기
다음은 사이트를 github와 연결해야한다.

```.sh
git init
ID=$(git config --global user.name)
git remote add origin https://github.com/$ID/blog.git
git submodule add -b master --force https://github.com/$ID/$ID.github.io.git public
```
이제 빌드를 할 차례이다. 빌드는 앞으로 많이 사용할 예정이므로 스크립트를 작성해보자

```.sh
vi deploy.sh
chmod 777 deploy.sh
```

vim을 이용하여 다음 스크립트를 입력하자
```.sh
#!/bin/bash 
echo -e "\033[0;32mDeploying update to github...\033[0m"
hugo -t PaperMod
cd public
git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
	then msg="$1"
fi
git commit -m "$msg"
git push -u origin main
cd ..
git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
	then msg="$1"
fi
git commit -m "$msg"
git push -u origin main
```
다음 명령어를 실행하여 github에 업로드하자.
```
./deploy.sh
```
