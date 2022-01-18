# CreditCardListView
## Description
Firebase의 Realtime Database와 Cloud Firestore를 이용하여 신용카드 리스트를 구현하는 프로젝트이다. <br>
Database에 저장된 카드 정보를 불러와 여러 개의 신용카드를 혜택에 따라 순위대로 리스트에 나타내며, 특정 카드를 선택하면 상세한 혜택 내용을 보여준다.
<img src="https://user-images.githubusercontent.com/62936197/149936826-eaa88251-8ca5-49fb-8315-b48502c4fe11.png" width="150" height="320"> 　　
<img src="https://user-images.githubusercontent.com/62936197/149936836-1c6d3dc6-233b-4602-9938-d7f95b62cf84.png" width="150" height="320">
## Prerequisite
* Firebase를 이용하기 위해 프로젝트 추가를 한다.
  1. https://firebase.google.com 에서 새 프로젝트를 생성한다.
  2. 콘솔 앱 프로젝트가 추가되었다면 ios 앱 추가를 선택한다. <br>
     이 때, iOS의 번들 ID에는 Xcode 프로젝트 파일의 Bundle Identifier를 입력한다.
  3. GoogleService-info.plist를 다운받아 Xcode 프로젝트 파일에 추가한다.
* Firebase SDK를 CocoaPods를 이용하여 설치한다.
  1. 터미널에서 해당 프로젝트 경로로 이동한 후 pod init을 입력하여 Podfile을 생성한다. <br>
    <img src="https://user-images.githubusercontent.com/62936197/149939979-90837f95-3d13-4b20-a802-5ded3668f65a.png" width="300" height="160"> <br>
  2. Podfile을 열어서 # Pods for CreditCardListView 아래에 세 가지를 추가한 후 저장한다.
      ```swift
        pod 'Firebase/Database' 
        pod 'Firebase/Firestore'
        pod 'FirebaseFirestoreSwift' 
      ```
  3. 터미널로 돌아와 pod install을 입력하여 SDK를 설치한다. <br>
    <img src="https://user-images.githubusercontent.com/62936197/149939987-3c580ae2-1299-45a2-8cd8-ec011154fe58.png" width="500" height="160"> <br>
  4. pod을 추가한 후에는 xcworkspace 파일을 이용해서 개발을 진행한다.
* KingFisher를 CocoaPods를 이용하여 설치한다.
  * KingFisher는 이미지 URL만 전달받은 상태에서 그것을 이미지뷰에 편리하게 표현해주는 오픈소스이다.
  1. Podfile을 열어서 # Pods for CreditCardListView 아래에 pod을 추가한 후 저장한다.
      ```swift
       pod 'Kingfisher'
      ```
  2. 터미널로 돌아와 pod install을 입력하여 설치한다.
  3. 개발 중인 프로젝트로 돌아와 빌드를 한 번 시켜주어 kingfisher 설치를 완료한다. 
  
* lottie를 CocoaPods를 이용하여 설치한다.
  * lottie는 GIF 파일이나 짧은 일러스트 동영상을 이미지뷰에 표현해주는 Airbnb에서 제공하는 오픈소스이다. pod 'lottie-ios'
  1. Podfile을 열어서 # Pods for CreditCardListView 아래에 pod을 추가한 후 저장한다.
      ```swift
       pod 'lottie-ios'
      ```
  2. 터미널로 돌아와 pod install을 입력하여 설치한다.
  3. 개발 중인 프로젝트로 돌아와 빌드를 한 번 시켜주어 lottie 설치를 완료한다.
## Files
>AppDelegate.swift
* AppDelegate.swift에서 Firebase 추가 및 초기화 코드를 작성한다. 
>CardListViewController.swift
* 어플을 실행하면 가장 먼저 보여질 메인 화면
  * kingfisher 적용
    ```swift
      let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
          cell.cardImageView.kf.setImage(with: imageURL)
    ```
>CardDetailViewController.swift
* 신용카드 셀을 탭했을 때 넘어가는 카드 혜택 상세정보 화면

>CreditCard.swift
* 신용카드 정보 및 상세 혜택 정보가 담긴 객체를 생성한다.
  * 읽을 때는 json decoding이 필요하고 쓸 때는 json encoding이 필요하기 때문에 codable을 상속하는 객체로 만든다.
    ```swift
      struct CreditCard: Codable {
          let id: Int
          let rank: Int
          let name: String
          let cardImageURL: String
          let promotionDetail: PromotionDetail
          let isSelected: Bool? // 사용자가 카드를 선택하기 전까지는 nil 값을 가짐
      }

      struct PromotionDetail: Codable {
          let companyName: String
          let period: String
          let amount: Int
          let condition: String
          let benefitCondition: String
          let benefitDetail: String
          let benefitDate: String
      }
    ```
>CardListCell.swift
* CardListViewController에 등록될 셀을 만든다. 
* 셀 위에 표현될 정보들을 CredirCard.swift에서 만든 카드 객체들로 채울수 있도록 구성한다.
* Cocoa Touch Class로 생성하고 셀을 커스텀 하기 위해 XIB 파일도 함께 생성한다.
>CreditCardDummy.swift
*
