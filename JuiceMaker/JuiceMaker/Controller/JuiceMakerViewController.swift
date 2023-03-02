//
//  JuiceMaker - JuiceMakerViewController.swift
//  Created by Harry, kokkilE. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class JuiceMakerViewController: UIViewController, UpdateLabelsDelegate {

    @IBOutlet weak private var strawberryJuiceButton: UIButton!
    @IBOutlet weak private var bananaJuiceButton: UIButton!
    @IBOutlet weak private var kiwiJuiceButton: UIButton!
    @IBOutlet weak private var pineappleJuiceButton: UIButton!
    @IBOutlet weak private var strawberryBananaJuiceButton: UIButton!
    @IBOutlet weak private var mangoJuiceButton: UIButton!
    @IBOutlet weak private var mangoKiwiJuiceButton: UIButton!
    
    @IBOutlet weak private var strawberryCountLabel: UILabel!
    @IBOutlet weak private var bananaCountLabel: UILabel!
    @IBOutlet weak private var kiwiCountLabel: UILabel!
    @IBOutlet weak private var pineappleCountLabel: UILabel!
    @IBOutlet weak private var mangoCountLabel: UILabel!
    
    private let juiceMaker = JuiceMaker()
    private let fruitStore = FruitStore.shared
    
    private var juiceButtonsDictionary: [UIButton: Juice] = [:]
    private var fruitLabelsDictionary: [Fruit: UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineDictionary()
        configureFruitCountLabels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyAccessibilityToButton()
        applyAccessibilityToLabel()
    }
    
    func applyAccessibilityToButton() {
        strawberryBananaJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        strawberryBananaJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        strawberryBananaJuiceButton.accessibilityLabel = "딸기쥬스 주문"
        strawberryBananaJuiceButton.accessibilityHint = "딸기 10개 바나나 1개 사용"
        
        bananaJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        bananaJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bananaJuiceButton.accessibilityLabel = "바나나쥬스 주문"
        bananaJuiceButton.accessibilityHint = "바나나 2개 사용"
        
        kiwiJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        kiwiJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        kiwiJuiceButton.accessibilityLabel = "키위쥬스 주문"
        kiwiJuiceButton.accessibilityHint = "키위 3개 사용"
        
        pineappleJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        pineappleJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pineappleJuiceButton.accessibilityLabel = "파인애플쥬스 주문"
        pineappleJuiceButton.accessibilityHint = "파인애플 2개 사용"
        
        strawberryJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        strawberryJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        strawberryJuiceButton.accessibilityLabel = "딸기쥬스 주문"
        strawberryJuiceButton.accessibilityHint = "딸기 16개 사용"
        
        mangoJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        mangoJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        mangoJuiceButton.accessibilityLabel = "망고쥬스 주문"
        mangoJuiceButton.accessibilityHint = "망고 3개 사용"
        
        mangoKiwiJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
        mangoKiwiJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        mangoKiwiJuiceButton.accessibilityLabel = "망고키위쥬스 주문"
        mangoKiwiJuiceButton.accessibilityHint = "망고 2개 키위 1개 사용"
        
    }
    
    func applyAccessibilityToLabel() {
        strawberryCountLabel.accessibilityLabel = "딸기재고"
        strawberryCountLabel.accessibilityValue = "\(fruitStore.getStockCountToString(of: .strawberry)!)개"
        
        bananaCountLabel.accessibilityLabel = "바나나재고"
        bananaCountLabel.accessibilityValue = "\(fruitStore.getStockCountToString(of: .banana)!)개"
        
        mangoCountLabel.accessibilityLabel = "망고재고"
        mangoCountLabel.accessibilityValue = "\(fruitStore.getStockCountToString(of: .mango)!)개"
        
        pineappleCountLabel.accessibilityLabel = "파인애플재고"
        pineappleCountLabel.accessibilityValue = "\(fruitStore.getStockCountToString(of: .pineapple)!)개"
        
        kiwiCountLabel.accessibilityLabel = "키위재고"
        kiwiCountLabel.accessibilityValue = "\(fruitStore.getStockCountToString(of: .kiwi)!)개"
    }
    
    
    @IBAction private func touchUpEditStockButton(_ sender: UIBarButtonItem) {
        presentStockManager()
    }
    
    @IBAction private func touchUpJuiceOrderButton(_ sender: UIButton) {
        guard let juice = juiceButtonsDictionary[sender] else { return }
        
        do {
            try juiceMaker.makeJuice(for: juice)
            presentOrderSuccessAlert(juice: juice)
            updateFruitCountLabels(juice: juice)
        } catch {
            presentOrderFailureAlert()
        }
    }
    
    private func defineDictionary() {
        juiceButtonsDictionary = [
            strawberryJuiceButton: .strawberryJuice,
            bananaJuiceButton: .bananaJuice,
            kiwiJuiceButton: .kiwiJuice,
            pineappleJuiceButton: .pineappleJuice,
            mangoKiwiJuiceButton: .mangoKiwiJuice,
            mangoJuiceButton: .mangoJuice,
            strawberryBananaJuiceButton: .strawberryBananaJuice
        ]
        
        fruitLabelsDictionary = [
            .strawberry: strawberryCountLabel,
            .banana: bananaCountLabel,
            .kiwi: kiwiCountLabel,
            .pineapple: pineappleCountLabel,
            .mango: mangoCountLabel
        ]
    }
    
    func configureFruitCountLabels() {
        for fruit in Fruit.allCases {
            fruitLabelsDictionary[fruit]?.text = fruitStore.getStockCountToString(of: fruit)
        }
    }
    
    private func updateFruitCountLabels(juice: Juice) {
        for fruit in juice.recipe.keys {
            fruitLabelsDictionary[fruit]?.text = fruitStore.getStockCountToString(of: fruit)
        }
    }
    
    private func presentStockManager() {
        guard let stockManagerNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "StockManagerNavigationController") as? UINavigationController else { return }
        
        guard let stockManagerViewController = stockManagerNavigationController.viewControllers.first as? StockManagerViewController else { return }

        stockManagerViewController.juiceMakerViewControllerDelegate = self        
        stockManagerNavigationController.modalPresentationStyle = .fullScreen
        
        self.present(stockManagerNavigationController, animated: true)
    }
    
    private func presentOrderSuccessAlert(juice: Juice) {
        let message = "\(juice.rawValue) 나왔습니다! 맛있게 드세요!"
               
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    private func presentOrderFailureAlert() {
        let alert = UIAlertController(title: "알림",
                                      message: "재료가 모자라요. 재고를 수정할까요?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { _ in
            self.presentStockManager()
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
