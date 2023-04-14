# Tinder_clone
### Tinder 클론 코딩
---

* 기간 : 23.03.30 ~ 23.04.14
<br>

### 개발 환경
---
#### StoryBoard vs Code
* 100% 코드 (UIKit)
#### 디자인패턴
* MVVM 패턴
#### 사용 기술 및 오픈소스 라이브러리
* Firebase
* SDWebImage
* JGProgressHUD
<br>
<br>

### 문제 및 해결과정
---
#### 1. SettingsVC - 기존 사진이 업데이트 되지 않고 새로운 이미지가 저장되는 문제
문제 상황 : <br>
* 프로필 사진을 바꾸려고 하면, 업데이트 되지 않고 새로운 이미지가 저장됨 
* 이미지가 3개 이상 업로드 된 상태에서 이미지를 변경하려고 하면, fatal error 발생 <br>

<img width="785" alt="image" src="https://user-images.githubusercontent.com/126672733/231730857-e4ccbe17-02fd-4507-bcd6-48b6a5a676e7.png">
<img width="573" alt="image" src="https://user-images.githubusercontent.com/126672733/231726022-c9fb9d9e-59b6-428f-8e85-51c904468548.png">
<br>

파악 과정 : <br>
1. 기존에 업로드 된 프로필 사진을 변경-저장하는 경우, 기존의 이미지가 update되지 않고 새로운 이미지로 추가됨을 발견했습니다.
2. Firestore에서 해당되는 유저의 imageURL 정보 확인 - ***저장 버튼을 누르면, 기존 이미지 url배열의 요소 갯수가 증가***되는 것을 확인했습니다.
3. 저장 버튼을 누르지 않은 경우 - 버튼의 view가 정상적으로 변경됨을 확인했습니다. 
4. imageURLs의 배열 갯수를 count 하자, 해당 전역변수의 count가 증가한 것을 확인했습니다.
5. imagePickerController(...didFinishPickingMediaWithInfo: ) 함수에서 호출된 메서드가 잘못됨을 인지했습니다.
6. 호출되는 함수를 보니, imageURLs 배열에 새로운 요소를 append하고 있기에, 새로운 요소가 추가만 되고 기존의 요소를 변경하는 로직은 구현되지 않음을 인지할 수 있었습니다.
<br>
<br>

해결 방법 : <br>
<img width="803" alt="image" src="https://user-images.githubusercontent.com/126672733/231732988-ede2f56f-3a59-4293-a63d-0a88577e4f51.png">
<img width="700" alt="image" src="https://user-images.githubusercontent.com/126672733/231732091-4579f5d4-9076-41ab-927f-3d3a21a6e8b9.png">

1. 버튼에 이미지가 있는 경우, 버튼의 index값을 인자로 받아서 해당되는 index의 imageURL을 새로운 URL로 대치하는 함수를 생성했습니다. updateImage(image: UIImage, index: Int) <br>
2. 기존 버튼에 이미지가 있을 경우 / 없을 경우를 분기처리 했습니다.
- 기존 버튼에 이미지가 있는 경우 : 기존에 사용했던 uploadImage() 함수 사용
- 기존 버튼에 이미지 없는 경우 : updateImage(image: UIImage, index: Int) 함수 사용
<br>
<br>

### 배운 점 
---
- MVVM 디자인 패턴을 익혔으며, 차후 프로젝트에서도 사용하면서 더욱 이해도를 높일 예정입니다. (view를 최대한 멍청하게..!)
- Firestore에 데이터를 구축하고 저장, 업로드, 업데이트 하는 법을 배웠습니다.
- Firestore에 저장된 두 데이터를 비교하는 법을 배웠습니다.
- Firebase Auth를 통해 유저 로그인, 로그아웃을 구현하는 법을 배웠습니다. 
- Delegate Pattern을 자신있게 사용할 수 있게 되었습니다.
- CollectionView의 사용법을 익혔습니다.
- 재사용성이 높은 코드를 작성하여 반복되는 코드를 줄이는 법을 배웠고 앞으로 활용할 예정입니다.
- 생소했던 UIPanGestureRecognizer 사용하는 방법을 알 수 있었습니다. 
<br>
<br>

### 구현 내용 
---
- 로그인 / 회원가입 / 로그아웃
- Swipe 제스처와 버튼을 이용한 좋아요, 싫어요 기능
- 프로필 수정 (프로필 사진 변경, 이름 변경, 검색 나이 범위 변경 등)
- 유저 검색 필터 기능 (설정한 검색 나이 범위에 해당되는 유저만 목록에 표시)
- 매칭 기능 (서로 좋아요 한 경우, 매칭 화면 present하기 및 messageView에 매칭된 유저 리스트 띄우기)
<br>
<br>







### 시연 영상 
---
* #### 로그인, 로그아웃, 회원가입 <br>
![Simulator Screen Recording - iPhone 14 - 2023-04-14 at 16 46 57](https://user-images.githubusercontent.com/126672733/231979103-600b1fe2-99bb-4e35-ba24-c4668112ba4a.gif)!
[Simulator Screen Recording - iPhone 14 - 2023-04-14 at 16 47 59](https://user-images.githubusercontent.com/126672733/231979323-b0130bc0-2c89-48b0-9e84-54da2ba17931.gif)


<br>

* #### 유저 정보 수정 및 유저 목록 새로고침 <br>
![Simulator Screen Recording - iPhone 14 - 2023-04-14 at 16 23 06](https://user-images.githubusercontent.com/126672733/231972956-dd28f540-75d5-4910-a8cc-85d17e03ee3f.gif)
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-14 at 16 24 19](https://user-images.githubusercontent.com/126672733/231973186-ba2a142a-4d96-41ce-ae44-8a8a5f5df345.gif)
<br>

* #### 유저 카드 이미지 확인 <br>
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-14 at 16 18 30](https://user-images.githubusercontent.com/126672733/231971959-1df30fc0-b92b-4bd2-87d0-84caae0c68a3.gif)
<br>

* #### swipe / 버튼 눌러서 해당 유저 좋아요 싫어요 선택하기 <br>
![Simulator Screen Recording - iPhone 14 - 2023-04-14 at 16 34 32](https://user-images.githubusercontent.com/126672733/231976685-1ff91316-4b07-4e08-bd50-3d966950289c.gif)
<br>


* #### 서로 좋아요 된 상태면 매칭 및 서로 메세지에서 매칭된 상대 목록 확인 <br>
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-14 at 16 08 54](https://user-images.githubusercontent.com/126672733/231969993-f40f9013-8767-473d-a462-c08b898dc7a2.gif)
![Simulator Screen Recording - iPhone 14 - 2023-04-14 at 16 29 12](https://user-images.githubusercontent.com/126672733/231974297-11d4bda3-dc01-4edb-8bfe-ddc2e85cc485.gif)







