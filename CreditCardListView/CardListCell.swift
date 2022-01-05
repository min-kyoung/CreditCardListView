//
//  CardListCell.swift
//  CreditCardListView
//
//  Created by 노민경 on 2022/01/05.
//

import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblPromotion: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
