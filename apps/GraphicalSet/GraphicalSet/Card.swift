//
//  Card.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct Card : Equatable {
    enum Variant : CaseIterable {
        case v1
        case v2
        case v3
    }
    
    let feature1: Variant
    let feature2: Variant
    let feature3: Variant
    let feature4: Variant
}
