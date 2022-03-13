# Bithumb_Market
>  빗썸 테크 캠프   
>  빗썸 Public API 사용한 앱 구현 프로젝트
>  

<img src="https://img.shields.io/badge/Platform-iOS-blue?style=flat&logo=ios&logoColor=white/"> <img src="https://img.shields.io/badge/Language-Swift-red?style=flat&logo=swift&logoColor=white/"> ![Swift](https://img.shields.io/badge/swift-v5.5.2-orange?logo=swift) ![Xcode](https://img.shields.io/badge/xcode-v13.1-blue?logo=xcode)

### [Ground Rule](https://github.com/HoonHaChoi/Bithumb_Market/wiki/Ground-Rule)
#### 🗓 기간 : 2022.02.21 - 2022.03.13  
#### 👩‍💻 개발 인원 : iOS 3명
#### 📙 라이브러리 : [**Starscream 4.0.0**](https://github.com/daltoniam/Starscream) 
#### ⛏ 사용 API: [**bithumb API**](https://apidocs.bithumb.com)

<br/>

## Table of contents 🌳

>1. [**Developer**](#developer-)
>2. [**Preview**](#preview-)
>3. [**Feature**](#feature-)
>4. [**Architecture**](#architecture-)
>5. [**DevOps**](#devops-)
>6. [**Challenges**](#challenges-)


<br/>

## Developer 👨🏻‍💻 

#### Team: 🧚 하쿠니마타타 

  |       iOS       |       iOS      |        iOS     |
  | :-------------: | :-------------:| :-------------:|
  |     **훈하**     |     **도쿠**    |     **지니**    |
  |    [@HoonHaChoi](https://github.com/HoonHaChoi)   |      [@Doku](https://github.com/iDoyoung)     |     [@JIINHEO](https://github.com/JIINHEO)   |
  |   코인목록        |      호가정보    |      체결내역, 그래프     |


<br/>


## Preview 📱
> 앱의 미리보기 화면입니다. 
> 하단에 [다크모드](#dark-) 도 준비되어있습니다. ✨

    
<br/>

| <img width="250" height="360" alt="image" src="https://user-images.githubusercontent.com/39071796/157900017-0b2a30ad-b2e9-4ffb-9b7e-a042084e029a.gif"> | <img width="250" height="360" src="https://user-images.githubusercontent.com/39071796/157910632-ed792bef-2140-4327-9242-a47823295ab0.gif"> | <img width="250" height="360" src="https://user-images.githubusercontent.com/39071796/157901504-7006a438-cb8f-45d9-81ae-6e94d4f782d0.gif"> | <img width="250" height="360" src="https://user-images.githubusercontent.com/39071796/157902297-c394d558-7ee9-4960-85fc-a1b7b4b3d89e.gif"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     `목록`                    |                      `상세`                      |                        `호가`                        |                        `체결내역`                        |

<br/>





## Feature ✨
> 화면별 기능 목록입니다. ✨

| <img width="331" height="360" alt="image" src="https://user-images.githubusercontent.com/39071796/157891887-efc25e8f-ba44-436c-b3f7-f2e115631235.png"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157892211-51eee188-37ce-4529-9626-b44d723a1d9f.png"> | <img width="331" height="360"  src="https://user-images.githubusercontent.com/39071796/157896022-5c0fa713-26e7-42d7-9cf2-9d8f175a886f.png"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157896006-f178e811-1198-456d-803a-e05c04f09e89.png"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     ```코인목록```                     |                      ```관심목록```                      |                        ```상세보기(라인차트)```                        |                        ```상세보기(봉차트)```                        |
|               활발한 체결순의 현재가 및 변동률               |               관심 코인 목록               |        현재가 및 변동률과 입출금 현황        |              이전 기록 시세 그래프               |
| <img width="331" height="360" alt="image" src="https://user-images.githubusercontent.com/39071796/157896767-e29f5494-276b-410f-85ea-6c907ab1706e.png"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157896754-58517e61-a020-4a28-ac12-818b9e9ab2db.png"> | <img width="240" height="360" src="https://user-images.githubusercontent.com/39071796/157897332-0834d047-069b-4e87-8e1b-5f05f1119f6f.png"> | <img width="240" height="360" src="https://user-images.githubusercontent.com/39071796/157897338-26faaf13-cd84-4450-bbeb-460bf5a8a4c8.png">| 
|                     `호가`                     |                      `체결내역`                      |                        `그래프 자세히보기`                        |                        `그래프 자세히보기 `                       |
|               매수/매도 실시간 표시               |               체결내역 실시간 표시               |        이전 기록 시세 라인그래프         |               이전 기록 시세 봉그래프               |




#### 코인목록
  - 현재가 및 변동률을 `활발한 체결순(인기)`으로 정렬해 표시합니다. 
  - 관심있는 코인들을 모아서 볼 수 있는 `관심 목록`을 제공합니다. 
  - 코인 변동에 따른 `애니메이션` 과 `CAShapeLayer` 을 추가하여 사용자들에게 증가, 감소를 명확히 알 수 있는 경험을 제공합니다.

#### 상세 정보
  - 코인 관심 등록 및 제거를 위해 `Core Data`를 사용합니다.
  - `Core Data` 에 저장된 데이터를 사용하여 그래프를 그립니다.
  - 라인그래프와 봉그래프 전환 시, `UserDefault` 를 사용하여 현재 그래프 모드를 저장합니다.
  
#### 실시거래가 그래프
  - `UIBezierPath`를 이용한 `LineGraph`와 `CandleStickGraph`를 제공합니다. 
  - 가격변동률을 `1분/10분/30분/1시간/일` 단위로 제공합니다.
  - 기간별 `최고가, 최저가`를 표시합니다. 
  - 스크롤에 따라 `최고가, 최저가`를 기준으로 `스케일`을 적용합니다.
  - 그래프를 클릭시 `CATextLayer`를 추가하여 `날짜와 시간`에 해당하는 `가격`을 표시합니다. 
  
#### 호가 정보
  - `매수/매도`를 구분하여 수량을 한눈에 알아볼 수 있게 전체수량을 기준으로 `프로그레스바`를 적용하였습니다.

#### 체결내역
  - 새로운 체결이 발생할 때마다 `insertRow`를 통한 테이블뷰를 `업데이트`를 해줍니다.
  
#### 다이나믹 타입
  - `접근성`을 고려해 `Dynamic Type`을 적용하였습니다.  
<!-- <details>
    <summary>Dynamic Type</summary> -->

| <img width="280" alt="image" src="https://user-images.githubusercontent.com/39071796/158006753-07b32ca4-869d-4d43-85b7-4b732cc8baa6.png"> | <img width="280" alt="image" src="https://user-images.githubusercontent.com/39071796/158006741-e0b827c3-ebb7-48dc-ba26-d0a0e10a6920.png">|
| :---------------------: | :------------------------: | 
|       `글씨크기 작게`      |      `굵게 & 글씨크기 크게`     |


#### Dark Mode

| <img width="331" height="360" alt="image" src="https://user-images.githubusercontent.com/39071796/157903531-29215a06-d28e-4925-b026-5d2426e517e7.gif"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157910654-b7c4c3ac-543b-42a4-882b-be46023205e2.gif"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157903569-e17ed51e-3100-4b07-8437-b4a3dea7fa3d.gif"> | <img width="331" height="360" src="https://user-images.githubusercontent.com/39071796/157903566-b88ce4ef-4344-4f7c-be17-9f383d41426e.gif"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     `목록`                     |                      `상세`                      |                        `호가`                       |                        `체결내역`                        |

<!--     
</details> -->



<br/>

## Architecture 🏛

- MVVM
- Pure DI

![](https://i.imgur.com/XO5rxxk.png)


<br/>


## DevOps 🐱


### - Github
    이슈를 작성하고, 이슈별 브랜치를 생성하여 진행 
### - Figma

![](https://cdn.discordapp.com/attachments/945122582963814430/945231006292672582/unknown.png)

    UI Design, flow Diagram 
### - Discord
    매일 오전 10시 스크럼 진행   
    매일 오전 10시 ~ 오전 2시 회의실에서 같이 프로젝트 진행    
<br/> 

## Challenges 💪


### [앱 제작시 작성한 트러블 슈팅 및 고민 & 회고](https://github.com/HoonHaChoi/Bithumb_Market/wiki/Challenges)
> 위의 링크를 통해 앱을 제작하면서 경험한 이슈 목록을 보실 수 있습니다.


### 후기

- 훈하:

코어데이터 백그라운드 동작과 CALayer를 활용한 코인변동 애니메이션을 적용시켜 사용자들에게 좋은 경험을 줄 수 있도록 구현 했던 경험이 기억에 남습니다. 또한 이번 프로젝트는 라이브러리를 최대한 사용하지 않은 챌린징을 했습니다.
거래소 특성상 실시간이라는 특징이 있기에, 웹소켓에 대한 연결과 해제, 동작 흐름을 중요하다는 것을 느낄 수 있었습니다.


- 도쿠: 

객체간 결합을 고려하지 않고 코드를 작성하던 저에게 있어서, 의존성 주입을 위해 Pure DI로 수행을 한 것이 이번 프로젝트에서 가장 많은 것을 얻어 갈 수 있었습니다. 조금이나마 조금 더 한 단계 성장한 코드를 작성할 수 있는 기회가 되었던 것 같습니다.
시간상 100% 만족스러운 코드를 작성하지 못한 것이 아쉽기는 했지만, 모르는 부분에 있어서 많은 도움을 주는 팀원들을 만나 프로젝트 진행에 있어서 힘들지만 즐겁게 진행할 수 있던 것에 감사했습니다.


- 지니

라이브러리를 최대한 사용하지 않고 기본에 충실하자는 목표로 라이브러리 없이 시세 그래프 그리기에 도전하며 CALayer를 활용해 그래프를 구현하고 텍스트는 어떤 식으로 보여줄 지 많은 고민을 했습니다. 5000개가 넘는 데이터를 한 번에 보여주면서 성능에 대한 고민도 해보며 조금 더 성장할 수 있었던 계기가 된 것 같습니다. 욕심이 생겼던 부분들을 더 구현하지 못한것이 조금은 아쉽지만, 그래도 3주동안 아침 10시부터 새벽 3시까지 열심히 같이 달려온 팀원들 덕분에 마지막까지 재미있게 진행할 수 있었습니다. 감사합니다.🥰




