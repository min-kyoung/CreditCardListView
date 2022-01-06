//
//  CardListViewController.swift
//  CreditCardListView
//
//  Created by 노민경 on 2022/01/05.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController{
    var ref: DatabaseReference! // Firebase realtime reference를 가져올 수 있는 값
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath)
                as? CardListCell else { return UITableViewCell() }
        
        cell.lblRank.text = "\(creditCardList[indexPath.row].rank)위"
        cell.lblPromotion.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.lblCardName.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 어떠한 셀을 탭했을 때 사용하는 delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 각 셀이 표현하고 있는 카드의 혜택 상세 정보가 담긴 화면으로 이동
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController")
                as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // 특정 key의 값이 cardID와 같은 객체를 찾아서 snapshot으로 찍는 것
        let cardID = creditCardList[indexPath.row].id
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]],
                  let key = value.keys.first else { return }
            
            self.ref.child("\(key)/isSelected").setValue(true)
        }
    }
    
    // 카드 셀 삭제
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // edigingStyle이 삭제인 경우
        if editingStyle == .delete {
            let cardID = creditCardList[indexPath.row].id
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first else { return }
                
                self.ref.child(key).removeValue()
            }
        }
    }
}

