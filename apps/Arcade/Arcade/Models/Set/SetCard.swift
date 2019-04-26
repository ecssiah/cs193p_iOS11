//
//  Card.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct SetCard : Equatable {
    private static var uidFactory = 0
    
    private static func getUniqueID() -> Int {
        uidFactory += 1
        return uidFactory
    }
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.id == rhs.id
    }

    enum Variant : CaseIterable {
        case v1
        case v2
        case v3
    }
    
    let id: Int
    
    let feature1: Variant
    let feature2: Variant
    let feature3: Variant
    let feature4: Variant
    
    init(feature1: Variant, feature2: Variant, feature3: Variant, feature4: Variant) {
        self.id = SetCard.getUniqueID()
        
        self.feature1 = feature1
        self.feature2 = feature2
        self.feature3 = feature3
        self.feature4 = feature4
    }
}
