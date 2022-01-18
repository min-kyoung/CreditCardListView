# CreditCardListView
## Description
Firebase의 Realtime Database와 Cloud Firestore를 이용하여 신용카드 리스트를 구현하는 프로젝트이다. <br>
Database에 저장된 카드 정보를 불러와 여러 개의 신용카드를 혜택에 따라 순위대로 리스트에 나타내며, 특정 카드를 선택하면 상세한 혜택 내용을 보여준다. <br>
<img src="https://user-images.githubusercontent.com/62936197/149936826-eaa88251-8ca5-49fb-8315-b48502c4fe11.png" width="170" height="320"> 　　　　
<img src="https://user-images.githubusercontent.com/62936197/149936836-1c6d3dc6-233b-4602-9938-d7f95b62cf84.png" width="170" height="320">
## Prerequisite
* Firebase를 이용하기 위해 프로젝트르 추가한다.
  1. https://firebase.google.com 에서 새 프로젝트를 생성한다.
  2. 콘솔 앱 프로젝트가 추가되었다면 ios 앱 추가를 선택한다. <br>
     이 때, iOS의 번들 ID에는 Xcode 프로젝트 파일의 Bundle Identifier를 입력한다.
  3. GoogleService-info.plist를 다운받아 Xcode 프로젝트 파일에 추가한다.
* Realtime Database를 만든다.
  1. 실시간 데이터베이스 위치는 기본값인 미국으로 하고 테스트 모드에서 시작을 선택한다.
  2. 저장할 신용카드 정보가 담긴 json 파일을 **JSON 가져오기**를 통해 업로드한다.
* Cloud Firestore를 만든다.
  1. 테스트 모드에서 시작하고 위치는 기본값으로 선택한다.
  2. 업로드하고자 하는 데이터의 양이 많기 때문에 코드를 이용한 작업, 즉 batch를 통해 읽기 작업을 진행하여 한번에 데이터를 넣을 것이다. <br>
* Firebase SDK를 CocoaPods를 이용하여 설치한다.
  1. 터미널에서 해당 프로젝트 경로로 이동한 후 pod init을 입력하여 Podfile을 생성한다. <br>
    <img src="https://user-images.githubusercontent.com/62936197/149939979-90837f95-3d13-4b20-a802-5ded3668f65a.png" width="300" height="160"> <br>
  2. Podfile을 열어서 # Pods for CreditCardListView 아래에 pod을 추가한 후 저장한다.
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
  * lottie는 GIF 파일이나 짧은 일러스트 동영상을 이미지뷰에 표현해주는 Airbnb에서 제공하는 오픈소스이다.
  1. Podfile을 열어서 # Pods for CreditCardListView 아래에 pod을 추가한 후 저장한다.
      ```swift
      pod 'lottie-ios'
      ```
  2. 터미널로 돌아와 pod install을 입력하여 설치한다.
  3. 개발 중인 프로젝트로 돌아와 빌드를 한 번 시켜주어 lottie 설치를 완료한다.
  
## Files
>AppDelegate.swift
* AppDelegate.swift에서 Firebase 추가 및 초기화 코드를 작성한다. 
* firestore에 데이터를 저장하기 위한 batch 코드를 작성한다.
    ```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        let db = Firestore.firestore()

        db.collection("creditCardList").getDocuments { snapshot, _ in
            guard snapshot?.isEmpty == true else { return }
            let batch = db.batch()

            // creditCardList 라는 컬렉션에 card0 라는 경로를 만들어 줌
            let card0Ref = db.collection("creditCardList").document("card0")
            let card1Ref = db.collection("creditCardList").document("card1")
             ...

            do {
                try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref)
                try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                 ...
            } catch let error {
                print("ERROR writing card to Firestore \(error.localizedDescription)")
            }

            batch.commit() // 반드시 batch를 commit 해야 추가가 됨      
        }      
        return true
    }
    ```
>CardListViewController.swift
* 어플을 실행하면 가장 먼저 보여질 메인 화면
  * kingfisher 적용
    ```swift
    let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
    ```
  * Realtime Database 연결
    ```swift
    // realtime database 읽기
    ref = Database.database().reference()

    // ref가 value 값을 바라보고 그 다음에는 snapshot을 이용해서 데이터를 불러옴
    ref.observe(.value) { snapshot in
        guard let value = snapshot.value as? [String: [String: Any]] else { return }

        // json decoding
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: value)
            let carData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
            let cardList = Array(carData.values)
            self.creditCardList = cardList.sorted { $0.rank < $1.rank } // 순위 순서대로 보여줌

            // table view reload
            // 메인 스레드에 해당 액션을 넣어주는 것
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error {
            print("ERROR JSON parsing \(error.localizedDescription)")
        }
     }
     ```
   * Cloud Firestoire 연결
      ```swift
      db.collection("creditCardList").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("ERROR Firestore fetching document \(String(describing: error))")
                return
            }
            
            // creditCard 객체 리스트로 가져옴
            self.creditCardList = documents.compactMap { doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error {
                    print("ERROR JSON Parshing \(error)")
                    return nil
                }
            }.sorted{ $0.rank < $1.rank } // 랭크 순 정렬
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
      }
      ```
>CardDetailViewController.swift
* 신용카드 셀을 탭했을 때 넘어가는 카드 혜택 상세정보 화면
  * lottie 적용
    ```swift
    override func viewDidLoad() {
         super.viewDidLoad()

         let animationView = AnimationView(name: "money") // 프로젝트에 넣어준 json 파일 이름
         lottieView.contentMode = .scaleAspectFit
         lottieView.addSubview(animationView)
         animationView.frame = lottieView.bounds
         animationView.loopMode = .loop
         animationView.play()
    }
    ```
  * firebase에서 데이터를 받았을 때 label에 표현될 내용 연결
    ```swift
    var promotionDetail: PromotionDetail?

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

        guard  let detail = promotionDetail else { return }

        lblTitle.text = """
            \(detail.companyName)카드 쓰면
            \(detail.amount)만큼 드려요
            """

        lblPeriod.text = detail.period
        lblCondition.text = detail.condition
        lblBenefitCondition.text = detail.benefitCondition
        lblBenefitDetail.text = detail.benefitDetail
        lblBenefitDate.text = detail.benefitDate
    }
    ``` 
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
* firestore에 fetch를 통해 데이터를 저장하기 위한 카드 객체의 정보가 담긴 파일

   
    
