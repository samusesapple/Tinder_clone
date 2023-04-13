# Tinder_clone
### Tinder 클론 코딩
---

* 기간 : 23.03.30 ~ (진행중) 
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
<br>

### 배운 점 
---
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
<br>
<br>

해결 방법 : <br>
<img width="803" alt="image" src="https://user-images.githubusercontent.com/126672733/231732988-ede2f56f-3a59-4293-a63d-0a88577e4f51.png">
<img width="700" alt="image" src="https://user-images.githubusercontent.com/126672733/231732091-4579f5d4-9076-41ab-927f-3d3a21a6e8b9.png">

1. 버튼에 이미지가 있는 경우, 버튼의 index값을 인자로 받아서 해당되는 index의 imageURL을 새로운 URL로 대치하는 함수를 생성했습니다.
2. 기존 버튼에 이미지가 있을 경우 / 없을 경우를 분기처리 했습니다.
<br>

### 구현 내용 
---
