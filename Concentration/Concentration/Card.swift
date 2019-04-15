//
//  Card.swift
//  Concentration
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct Card : Hashable
{
    static func ==(lhs: Card, rhs: Card) -> Bool {
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
        self.identifier = Card.getUniqueID()
    }
    
}
