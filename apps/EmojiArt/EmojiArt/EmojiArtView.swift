//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Michael Chapman on 4/29/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class EmojiArtView: UIView
{
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
