# 동물의 사생활 (Privacy of Animal)

<p align="center">
  <img src="./portfolio/icon.png" width="300px">
</p>

## 프로젝트 소개

"동물의 사생활"은 현대사회의 외모지상주의에 지친 현대인들에게 채팅어플을 통해 더 많은 기회를 제공해주고자 하는 프로젝트입니다. 현재 많은 채팅/소개팅 어플이 있지만 많은 어플들이 사진을 필수로 요구하는 경우가 많고 사진이 필수가 아니더라도 많은 사용자들이 상대방의 사진을 필요로 하기 때문에 외모에 자신감이 없는 이들은 사람과 대화할 수 있는 기회가 적을 가능성이 높습니다. 따라서 저는 **대학교의 졸업 프로젝트로, 외모에 자신감이 없는 사람들도 다른 사람들과 대화할 수 있는 환경을 구축해주는 어플을 만들게 되었습니다.** 비록, 완벽하게 만들지 못해서 런칭하진 못했지만 새로운 프레임워크를 사용하고 여러가지 이슈들을 해결하면서 많은 것들을 배울 수 있었습니다.

> 이 프로젝트의 최종보고서는 [구글 문서](https://docs.google.com/document/d/1ggPAQ1k4UmtZ8kKbfVrrfnba5mlVYGM4zX228x1D2xM/edit?usp=sharing) 에서 확인할 수 있습니다.

<br>

## 앱 동작화면

|                       홈                       |                     로그인                      |                     회원가입                     |
| :--------------------------------------------: | :---------------------------------------------: | :----------------------------------------------: |
| <img src="./portfolio/home.png" width="300px"> | <img src="./portfolio/login.png" width="300px"> | <img src="./portfolio/signup.png" width="300px"> |

|                   태그선택                    |                   태그상세 채팅                   |                   얼굴 분석 대기                   |
| :-------------------------------------------: | :-----------------------------------------------: | :------------------------------------------------: |
| <img src="./portfolio/tag.png" width="300px"> | <img src="./portfolio/tagchat.png" width="300px"> | <img src="./portfolio/analyze1.png" width="300px"> |

|                   얼굴분석 결과                    |                      프로필                       |                     친구목록                      |
| :------------------------------------------------: | :-----------------------------------------------: | :-----------------------------------------------: |
| <img src="./portfolio/analyze3.png" width="300px"> | <img src="./portfolio/profile.png" width="300px"> | <img src="./portfolio/friends.png" width="300px"> |

|                   친구신청 목록                   |                      채팅목록                      |                      채팅                      |
| :-----------------------------------------------: | :------------------------------------------------: | :--------------------------------------------: |
| <img src="./portfolio/request.png" width="300px"> | <img src="./portfolio/chatlist.png" width="300px"> | <img src="./portfolio/chat.png" width="300px"> |

|                   관심사 매칭                    |                 관심사 매칭 결과                 |                     랜덤 매칭                     |
| :----------------------------------------------: | :----------------------------------------------: | :-----------------------------------------------: |
| <img src="./portfolio/match1.png" width="300px"> | <img src="./portfolio/match2.png" width="300px"> | <img src="./portfolio/random1.png" width="300px"> |

|                  랜덤 매칭 결과                   |
| :-----------------------------------------------: |
| <img src="./portfolio/random2.png" width="300px"> |

<br>

## 사용해 본 기술 및 프로그램들과 배운 것들

|                  프로젝트 기획                  |                  프로토타입                   |                     언어                     |                   프레임워크                    |
| :---------------------------------------------: | :-------------------------------------------: | :------------------------------------------: | :---------------------------------------------: |
| <img src="./portfolio/sprint.jpeg" width=150px> | <img src="./portfolio/figma.png" width=150px> | <img src="./portfolio/dart.png" width=150px> | <img src="./portfolio/flutter.png" width=150px> |
|            **Google Design Sprint**             |                   **Figma**                   |                   **Dart**                   |                   **Flutter**                   |

|                유명인 및 감정추출                |                    좌표 추출                     |                    데이터베이스                    |
| :----------------------------------------------: | :----------------------------------------------: | :------------------------------------------------: |
| <img src="./portfolio/vision.png" width="150px"> | <img src="./portfolio/clova.jpeg" width="150px"> | <img src="./portfolio/firebase.png" width="150px"> |
|               **Kakao Vision API**               |               **Naver Clova API**                |                    **Firebase**                    |

<br>

### Google Design Sprint

구글의 디자인 스프린트는 구글 벤쳐스가 개발한 아이디어 검증 기법입니다. 처음엔 별로 시덥지 않은 방법이라고 생각했지만 이를 통해서 확실한 주제가 없었던 저희 팀에게 보다 확실한 아이디어를 결정짓게 하였고 **끊임없는 논의와 다른 사람들의 평가를 통해서 기획 단계에서 조금이나마 더 검증하고 확실히** 할 수 있었습니다.

| 스프린트1                                         | 스프린트2                                         |
| ------------------------------------------------- | ------------------------------------------------- |
| <img src="./portfolio/sprint1.jpg" width="400px"> | <img src="./portfolio/sprint2.jpg" width="400px"> |

### Figma

프로토타입을 작성해본 적이 없었던 와중에 Figma라는 툴이 새롭게 나오게 되었고 이걸 프로젝트에 적용하여 프로토타입을 작성해보면 좋을 것 같다고 말씀하셔서 적용하게 되었습니다. 사실상 기술적인 면과 크게 관련되어 있진 않지만 프로토타입을 작성하면서 배웠던 점은 개발을 하기전에 **뭘 개발해야 할지 명확하게 파악할 수 있었다는 점** 입니다. 본래, 개발을 할 때는 의식의 흐름으로 개발을 하고는 했는데 프로토타입을 통해서 **체계적인 구조를 세우는 방법과 실제로 시연해봄으로써 발생할 수 있는 버그/예외 케이스 등에 대해 예측** 할 수 있었습니다.

<img src="./portfolio/prototype.png">

### Dart & Flutter

어플을 만들 때 기존 방식을 사용하면 Java/Swift를 사용해서 안드로이드/iOS를 각각 개발하는 것이 일반적인데, 프로젝트를 진행하던 시기에 마침 크로스 플랫폼 프레임워크인 Flutter가 베타버전으로 나왔습니다. 바로 적용해보고자 했지만 프레임워크가 Dart라는 언어를 사용했기 때문에 해당 언어도 배우게 되었습니다. 결국, 새로운 언어와 새로운 프레임워크를 배워야했고 정말 낯설었지만 이런 환경을 통해 **공식문서로 학습하는 방법과 깃헙 이슈를 이용해 커뮤니케이션 하는 방법** 을 배울 수 있었습니다. 아래 사진은 제가 Flutter 저장소에 문의했던 이슈들입니다.

<img src="./portfolio/issue.png">

2번째로, 구글에서 공식적으로 권장했던 설계구조인 **BLoC(Business Logic Component)** 패턴을 공부하면서 Dart의 Stream API에 대해서 학습했는데 이는 리액티브 프로그래밍을 구현하는 핵심이었고 이를 통해 구현된 RxDart를 적용해나가면서 **리액티브 프로그래밍이라는 개념에 대해서 처음으로 접할 수 있었고** 기존 방식에 비해 어떤 점이 나은 점인지에 대해 배울 수 있었습니다. 아래는 BLoC 패턴이 적용된 프로젝트의 구조입니다.

<p align="center">
  <img src="./portfolio/bloc.png" width="600px">
</p>

### Firebase

이제까지 데이터베이스를 사용해본 적은 MySQL이 전부였고 클라우드 서비스를 사용해 본적이 없었습니다. 물론 유명한 AWS가 있었지만 교수님께서 서비스가 활성화되기 전까진 Firebase가 가성비와 사용법이 좋다고 하셔서 사용해보게 되었습니다. Firebase에는 여러가지 서비스들이 있는데 전 여기서 Firebase authentication, Cloud Function, Cloud Firestore를 적용하였고 실험적으로 Firebase ML Kit 또한 사용해보았습니다. **Authentication과 Cloud Function을 통해선 클라우드 서비스가 주는 이점에 대해 확실히 알 수 있었고 Cloud Firestore를 통해선 NoSQL이 RDBMS에 비해서 갖는 장점에 대해 느낄 수 있었습니다.**

### Kakao Vision & Naver Clova APIs

사용자의 얼굴로부터 뽑아내야 할 정보들을 위해서 카카오의 비전과 네이버의 클로바를 사용하였습니다. 비전에선 얼굴의 눈, 코, 입, 턱 등의 부위로부터 좌푯값들을 뽑아내었고 클로바에선 얼굴의 표정분석과 유명인추정을 사용하였습니다. 해당 API들도 사용해 본 경험이 없었고 Dart로 작성된 예시코드는 제공되지 않았기 때문에 Java 코드를 통해서 Dart로 다시 구현하는 작업을 하였습니다. 비록, 어렵지 않은 작업이었지만 **새로운 언어를 통해서 낯선 API를 활용해보는 것이 색다른 경험이었습니다.**

<br>

## 아쉬웠던 점

약 2달동안 열심히 프로젝트를 진행했지만 결국은 런칭하지 못했고 프로젝트도 완벽하게 마무리하지는 못했습니다. 그래서, 만약에 다시 프로젝트를 하게 된다면 고쳐야 할 점을 되돌아보고자 합니다.

* **소프트웨어 설계의 중요성**

프로젝트를 마무리하던 학기에 "소프트웨어 공학" 이라는 수업을 들으면서 소프트웨어를 제대로 설계하지 않는다면 결국 "늑대인간"과 같이 변해서 개발자에게 공포를 선사한다는 논문인 *"No Silver Bullet"* 을 보게 되었습니다. 이를 통해서 시간에 쫓겨 단순 구현에만 초점을 맞추고 집중했던 저의 모습을 반성했고 어떠한 소프트웨어를 만들던지 그 소프트웨어를 체계적이고 관리할 만하게 설계한다는 것이 얼마나 중요한지 깨달았습니다. BLoC 패턴을 적용하며 전체적인 설계를 어느정도 예상했음에도 불구하고 상세하게 큰 그림을 설계하지 않았다는 점에서 아쉬움이 있습니다.

* **소프트웨어 테스팅의 중요성**

이것도 위와 마찬가지로 시간에 쫓겨 구현에만 집중했던 것 때문에 테스팅을 시도해 볼 수조차 없었습니다. 핑계일 수 있지만 테스팅을 하기 위해선 테스트 코드를 짜는 방법도 배워야 하고 유닛 테스팅인지 통합 테스트인지도 구분하는 안목을 길러야 하기 때문에 멀리했던 것 같습니다. 역시 테스트 코드를 짜지 않았기 때문에 제가 손수 하나하나 빌드/테스트하는 시간이 굉장히 오래걸렸습니다. 만약, 테스트 코드를 짜고 CI/CD를 적용했다면 훨씬 수월한 개발과정이 되었을 것 같습니다.

* **아이디어 확립의 미비함**

위에서 말한 구글의 디자인 스프린트를 하면서 많은 아이디어 회의를 했지만, 역시 이렇다 할 아이디어를 낼 수는 없었습니다. 프로젝트를 진행한 이 아이디어 역시 제일 처음에 제가 냈던 아이디어를 조금 보완한 수준입니다. 이렇게 아이디어가 미비했기 때문에 개발과정도 막힐 때가 많았고 문제가 발생할 때가 많았습니다. 또한 제가 약한 부분이 바로 새로운 아이디어를 내고 그것을 발전시키는 것이라는 걸 확실히 깨닫는 계기도 되었습니다.

* **팀원들간의 협동**

처음에 디자이너가 1명 있었고 개발을 2명이서 하는 구조로 되어있지만 코드의 95%를 제가 짜게 되었고 다른 이들간의 커뮤니케이션 또한 원활하게 이루어지지 않았습니다. 속으로 많은 불평들을 하였지만 그 시간에 그들과의 간극을 어떻게 더 좁힐까 고민했다면 일의 분배를 좀 더 효율적으로 할 수 있었을 것 같습니다. 한 명만 하면 되는 개인 프로젝트와는 달리 팀 프로젝트였는데도 불구하고 협동정신이 부족했던 점이 아쉽습니다.