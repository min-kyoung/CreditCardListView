//
//  CardListViewController.swift
//  CreditCardListView
//
//  Created by 노민경 on 2022/01/05.
//

import UIKit

class CardListViewController: UITableViewController{
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: <#T##IndexPath#>)
                as? CardListCell else { return UITableViewCell() }
        
        cell.lblRank.text = "\(creditCardList[indexPath.row].rank)위"
        cell.lblPromotion.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.lblCardName.text = "\(creditCardList[indexPath.row].name)"
        
        return cell
    }
    
}

