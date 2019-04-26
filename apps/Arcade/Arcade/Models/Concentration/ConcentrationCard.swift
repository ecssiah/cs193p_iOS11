//
//  Card.swift
//  Arcade
//
//  Created by Michael Chapman on 4/26/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct ConcentrationCard : Hashable
{
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var uidFactory = 0
    
    private static func getUniqueID() -> Int {
        uidFactory += 1
        return uidFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueID()
    }
}
