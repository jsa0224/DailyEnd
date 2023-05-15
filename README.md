# 📕 Diary
<img width="1024" alt="스크린샷 2023-05-15 오후 2 11 50" src="https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/cb58d55c-5468-46c6-bef4-f705a435faee">

> 기존의 야곰 아카데미에서 진행한 토이 프로젝트 Diary를 RxSwift와 MVVM, Clean Architecture를 활용하여 리팩토링한 프로젝트입니다.

> 개발기간: 2023.03.13 - 2023.05.15

<br>
<br>

## 🏷️ 프로젝트 소개
일기장을 작성할 수 있어요!
수정이 간편하고, 날짜별로 일기장을 검색할 수 있어요!

<br>
<br>

## ☁️ 개발 인원
|[som](https://github.com/jsa0224)|
|:---:|
|<img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/25aa347d-e125-42bd-9500-025c80807227 width="200" height="200">

<br>
<br>

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![Xcode](https://img.shields.io/badge/Xcode-16.2-blue)]() [![RxSwift](https://img.shields.io/badge/RxSwift-6.5.0-purple)]() [![CoreData](https://img.shields.io/badge/CoreData-3.0+-green)]()

<br>
<br>

## 📱 프로젝트 주요 기능
> 처음 앱을 사용하시면 일기장을 어디서 추가할 수 있는지 안내 문구가 나옵니다.

<img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/8635d9b8-c227-4e00-bb61-5bfc34a9e796 width="200" height="420"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/f3f67fb0-d105-46e5-8ce0-64fe31517023 width="200" height="420">

<br>

> 작성 페이지로 이동하면 사진과 함께 일기장을 작성할 수 있습니다. 
> 빈 일기장일 경우, 저장되지 않아요🥺

<img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/bb887e04-420b-469d-8433-adf7b6d207b3 width="200" height="420">  <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/72700450-7807-4844-93fc-d7ae23e2fa26 width="200" height="420"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/ec772af6-5534-4aa5-97a6-ecbf861121c8 width="200" height="420">

<br>

> 저장된 일기장은 메인 페이지에서 확인 가능합니다.
> 메인 페이지에서 일기장을 누르면 해당 일기장의 수정과 삭제가 가능합니다.

<img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/893a1eab-a901-4bce-8799-ecf701412694 width="200" height="420"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/e63d2d24-24e3-4d25-9f77-082eca5c4b7e width="200" height="420"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/7416dd18-873c-4abe-a37b-79a4ff563006 width="200" height="420">

<br>

> 저장된 일기장은 검색 페이지에서 검색 가능합니다.
> 해당 날짜에 없을 경우, 존재하지 않는다는 alert 창이 뜹니다.

<img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/a31bfe22-d0a9-47da-827d-14364061ca8b width="150" height="320"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/300aa86f-b9ac-411c-9a04-352ec6f8ab1b width="150" height="320"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/39f67413-e596-44db-b8dd-aa51912305cf width="150" height="320"> <img src=https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/4b4a9458-c37b-47a5-8ff9-8af8a20c9c12 width="150" height="320">

<br>
<br>

## ⚒️ 아키텍처
### 🌲 파일트리
<details>
<summary>세부사항</summary>
<div markdown="1">
  
```
Diary
├── App
│   ├── AppDelegate
│   └── SceneDelegate
├── Domain
│   ├── InterFaces
│   │   ├── Repositories
│   │   │   └── CoreDataRepositories 
│   ├── Entities
│   │   └── Diary
│   └── UseCases
│       └── DiaryUseCase
├── Presentation
│   ├── CommonView
│   │   ├── Item
│   │   │   └── DiaryItem
│   │   ├── View
│   │   │   ├── DiaryView
│   │   │   ├── TapBarController
│   │   │   └── RecordView
│   │   ├── Alert
│   │   │   ├── AlertActionType
│   │   │   └── AlertManager
│   │   └── Cell
│   │       ├── DiaryCollectionViewCell
│   │       ├── DiaryCellViewModel
│   │       ├── DateLabel
│   │       └── DiarySection
│   ├── HomeView
│   │   ├── ViewModel
│   │   │   └── HomeViewModel
│   │   └── View
│   │       ├── NoticeView
│   │       └── HomeViewController
│   ├── DetailView
│   │   ├── ViewModel
│   │   │   └── DetailViewModel
│   │   └── View
│   │       └── DetailViewController
│   ├── RecordView
│   │   ├── ViewModel
│   │   │   └── RecordViewModel
│   │   └── View
│   │       └── RecordViewController
│   └── SearchView
│       ├── ViewModel
│       │   └── SearchViewModel
│       └── View
│           └── SearchViewController
├── Data
│   ├── Repositories
│   │   └── DiaryRepositories
│   └── CoreData
│       ├── Model
│       │   ├── DiaryDAO+CoreDataClass
│       │   └── DiaryDAO+CoreDataProperties
│       └── Manager
│           ├── CoreDataManager
│           ├── CoreDataManageable
│           └── CoreDataError
├── Util
└── Resource
```
  
</div>
</details>


### 📊 다이어그램
![](https://github.com/jsa0224/ios-diary-RxSwift/assets/94514250/a2ae731b-297b-4d78-9fe5-6d9edb12e532)

> **Clean Architecture**
- MVVM 아키텍처로 구현하면서도 객체를 어느 파일에 구현하면 좋을 지, 의문이 생겨 해당 아키텍처를 공부하게 되었습니다.
![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*JxCAYFc2UsovUdt13vtEwQ.png)
- 도메인, 비즈니스 모델, 유즈케이스 등을 활용하면서 내부 레이어에서 외부 레이어로 종속성을 갖지 않도록 유의했습니다.

> **MVVM** 
- MVC 패턴을 사용하면서, Controller의 역할이 비대해져 역할 분리가 안 된다는 생각이 들어, MVVM을 공부하게 되었습니다.
- ViewModel, View 객체를 통해 역할 분리를 하였고, 기존 ViewController의 코드 2배가량 줄일 수 있었습니다.
- 화면 전환을 담당하는 Coordinator 객체가 있다면 역할 분리가 더 명확해진다는 것을 깨닫고, 다음 프로젝트에 적용해볼 생각입니다.

> **Input & Output**
- 뷰모델을 Input과 Output으로 정의하여 뷰의 이벤트들을 Input에 바인딩하고, 뷰에 보여질 데이터를 Output에 바인딩했습니다.
- 일관성 있고 직관적인 구조를 유지해 뷰모델의 코드 가독성이 높아졌습니다. 

<br>
<br>

## 🙇‍♀️ 참고 자료
### 🍎 애플 공식 문서
[Core Data](https://developer.apple.com/documentation/coredata) <br>
[NSFetchRequest](https://developer.apple.com/documentation/coredata/nsfetchrequest) 

### 📃 외부 문서
[ReactiveX](https://reactivex.io/) <br>
[Clean Architecture and MVVM on iOS](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)
