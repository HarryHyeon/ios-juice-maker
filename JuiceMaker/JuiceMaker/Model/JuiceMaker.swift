//
//  JuiceMaker - JuiceMaker.swift
//  Created by Harry, kokkilE. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

struct JuiceMaker {
    let fruitStore = FruitStore.shared
    
    func makeJuice(recipe: [Fruit: Int]) throws {
        do {
            guard try fruitStore.isStocked(recipe: recipe) else {
                throw JuiceMakerError.outOfStock
            }
        } catch FruitStoreError.invalidFruitInput {
            print("FruitStoreError.invalidFruitInput")
        }
        
        for ingrediant in recipe {
            do {
                try fruitStore.subtractStock(fruit: ingrediant.key, amount: ingrediant.value)
            } catch FruitStoreError.invalidFruitInput {
                print("FruitStoreError.invalidFruitInput")
            } catch FruitStoreError.belowZeroAmount {
                print("FruitStoreError.belowZeroAmount")
            }
        }
    }
}
