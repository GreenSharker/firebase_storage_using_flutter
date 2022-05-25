# Firebase Storage에 있는 항목을 다운로드하거나 스토리지에 업로드하는 앱

## 사용법

## 다운로드
- 앱을 실행하면, "파일 다운로드" 페이지가 나옵니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170213402-b4faaa55-bba2-4865-975f-95f24040b3a3.png">

- 다운로드 받을 항목의 다운로드 아이콘을 클릭합니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170213781-cd397037-5f34-41f7-b531-05cee33316f4.png">

- 다운로드하는 동안 ProgressBar가 나타내고, 다운로드 완료되면 하단에 메시지가 "다운로드가 완료되었습니다."라는 메시지가 나타냅니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170213964-cb69ed97-25bb-43ee-b1fb-5ef3c7f6006a.png">

## 업로드
- 하단 메뉴의 업로드 부분을 클릭합니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170214506-7011d7b0-0f6d-4b2f-8c06-77416f896955.png">

- "파일 선택" 버튼을 클릭합니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170214837-6d731877-826a-4879-9d2e-dfd281582117.png">

- 업로드할 이미지나 비디오를 선택합니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170215056-47b79240-0a34-4324-859a-d26b954e2863.png">

- 파일을 선택하면 아래 이미지와 같이 나타냅니다(비디오 파일 선택 시, 아래 이미지와 같이 나타내지 않을 수 있습니다.)
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170215348-297da62a-0561-47ca-99e0-3ca066c57dd0.png">

- "파일 업로드" 버튼을 클릭합니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170215572-18e4cfda-8e1a-48c2-afdf-15a3dba6f4bb.png">

- 업로드하는 중에 ProgressBar가 나타내어 얼마나 업로드되는지 알 수 있습니다. 업로드 완료되면 성공적으로 클라우드에 업로드되었습니다.
<img width="30%" src="https://user-images.githubusercontent.com/48400348/170216372-d53738d8-0ec4-4197-aa1e-b7a5c9cdfcc8.png">

### 설치된 라이브러리
- firebase_core
- firebase_storage
- path_provider
- gallery_saver
- dio
- file_picker