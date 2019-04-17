//
//  CardView.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/16/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class CardView: UIView {

    var shape = Shape.squiggle
    var style = Style.unfilled
    var color = Color.green
    var number = Number.one
    
    enum Shape : CaseIterable {
        case squiggle
        case diamond
        case oval
    }
    
    enum Style : CaseIterable {
        case unfilled
        case striped
        case solid
    }
    
    enum Color : CaseIterable {
        case green
        case red
        case purple
    }
    
    enum Number : CaseIterable {
        case one
        case two
        case three
    }
    
    override func draw(_ rect: CGRect) {
        


    }
}
