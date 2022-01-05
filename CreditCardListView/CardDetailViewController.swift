//
//  CardDetailViewController.swift
//  CreditCardListView
//
//  Created by 노민경 on 2022/01/05.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
    var promotionDetail: PromotionDetail?
    
    @IBOutlet weak var lottieView: AnimationView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblBenefitCondition: UILabel!
    @IBOutlet weak var lblBenefitDetail: UILabel!
    @IBOutlet weak var lblBenefitDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = AnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
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
    
}
