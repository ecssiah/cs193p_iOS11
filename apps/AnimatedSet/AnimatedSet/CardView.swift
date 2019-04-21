//
//  CardView.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/16/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class CardView: UIView
{
    static var inset: CGFloat = 2
    
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
    
    var card: Card? {
        didSet {
            switch card!.feature1 {
            case Card.Variant.v1: shape = CardView.Shape.diamond
            case Card.Variant.v2: shape = CardView.Shape.oval
            case Card.Variant.v3: shape = CardView.Shape.squiggle
            }
            
            switch card!.feature2 {
            case Card.Variant.v1: style = CardView.Style.solid
            case Card.Variant.v2: style = CardView.Style.striped
            case Card.Variant.v3: style = CardView.Style.unfilled
            }
            
            switch card!.feature3 {
            case Card.Variant.v1: color = CardView.Color.green
            case Card.Variant.v2: color = CardView.Color.purple
            case Card.Variant.v3: color = CardView.Color.red
            }
            
            switch card!.feature4 {
            case Card.Variant.v1: number = CardView.Number.one
            case Card.Variant.v2: number = CardView.Number.two
            case Card.Variant.v3: number = CardView.Number.three
            }
        }
    }
    
    var faceUp = false { didSet { updateView() } }
    var selected = false { didSet { updateView() } }
    
    var shape = Shape.diamond
    var style = Style.solid
    var color = Color.green
    var number = Number.one
    
    private func updateView() {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let base = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0)
        base.addClip()
        
        if faceUp {
            #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
            base.fill()
            
            var path = UIBezierPath()
            
            switch shape {
            case Shape.diamond:
                let p1 = CGPoint(
                    x: bounds.midX + bounds.size.width / 4, y: bounds.midY
                )
                let p2 = CGPoint(
                    x: bounds.midX, y: bounds.midY - bounds.size.width / 8
                )
                let p3 = CGPoint(
                    x: bounds.midX - bounds.size.width / 4, y: bounds.midY
                )
                let p4 = CGPoint(
                    x: bounds.midX, y: bounds.midY + bounds.size.width / 8
                )
                
                path.move(to: p1)
                path.addLine(to: p2)
                path.addLine(to: p3)
                path.addLine(to: p4)
                path.close()
            case Shape.oval:
                path = UIBezierPath(
                    ovalIn: CGRect(
                        x: bounds.size.width / 4,
                        y: bounds.midY - bounds.size.height / 10,
                        width: bounds.size.width / 2,
                        height: bounds.size.height / 5
                    )
                )
            case Shape.squiggle:
                path = bezierSquiggle(
                    CGRect(
                        x: bounds.size.width / 4,
                        y: bounds.size.height / 4,
                        width: bounds.size.width / 2,
                        height: bounds.size.height / 2
                    )
                )
            }
            
            switch color {
            case Color.green:
                let strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                strokeColor.setFill()
                strokeColor.setStroke()
            case Color.purple:
                let strokeColor = #colorLiteral(red: 0.555020988, green: 0.3270847797, blue: 0.6812944412, alpha: 1)
                strokeColor.setFill()
                strokeColor.setStroke()
            case Color.red:
                let strokeColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                strokeColor.setFill()
                strokeColor.setStroke()
            }
            
            path.lineWidth = 3.0
            
            let context = UIGraphicsGetCurrentContext()
            context!.saveGState()
            
            let stripes = stripesPath()
            
            switch number {
            case Number.one:
                switch style {
                case Style.solid:
                    path.stroke()
                    path.fill()
                case Style.unfilled:
                    path.stroke()
                case Style.striped:
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                }
            case Number.two:
                switch style {
                case Style.solid:
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -0.2 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                    path.fill()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 0.4 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                    path.fill()
                case Style.unfilled:
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -0.2 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 0.4 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                case Style.striped:
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -0.2 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                    
                    context!.restoreGState()
                    context!.saveGState()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 0.4 * bounds.size.width
                        )
                    )
                    
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                }
            case Number.three:
                switch style {
                case Style.solid:
                    path.stroke()
                    path.fill()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -1.5 * bounds.size.width / 4
                        )
                    )
                    
                    path.stroke()
                    path.fill()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 1.5 * bounds.size.width / 2
                        )
                    )
                    
                    path.stroke()
                    path.fill()
                case Style.unfilled:
                    path.stroke()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -1.5 * bounds.size.width / 4
                        )
                    )
                    
                    path.stroke()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 1.5 * bounds.size.width / 2
                        )
                    )
                    
                    path.stroke()
                case Style.striped:
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                    
                    context!.restoreGState()
                    context!.saveGState()
                    
                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: -1.5 * bounds.size.width / 4
                        )
                    )
                    
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                    
                    context!.restoreGState()
                    context!.saveGState()

                    path.apply(
                        CGAffineTransform(
                            translationX: 0,
                            y: 1.5 * bounds.size.width / 2
                        )
                    )
                    
                    path.stroke()
                    path.addClip()
                    stripes.stroke()
                }
            }
            
            context!.restoreGState()
            
            if selected {
                #colorLiteral(red: 1, green: 0, blue: 0.8122541904, alpha: 1).setStroke()
                base.lineWidth = 6.0
                base.stroke()
            }
        } else {
            #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).setFill()
            base.fill()
            
            #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).setStroke()
            base.lineWidth = 4.0
            base.stroke()
        }
    }
    
    private func stripesPath() -> UIBezierPath {
        let numLines = 12
        let path = UIBezierPath()
        path.lineWidth = 2.0
        
        for pos in 0..<numLines {
            let curX = CGFloat(pos) * bounds.size.width / CGFloat(numLines)
            path.move(to: CGPoint(x: curX, y: 0))
            path.addLine(to: CGPoint(x: curX, y: bounds.size.height))
        }
        
        return path
    }
    
    private func bezierSquiggle(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 3.0
        
        path.move(
            to: CGPoint(
                x: rect.minX + 0.0366 * rect.width,
                y: rect.minY + 0.6416 * rect.height
            )
        )
        // Point 1
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.3226 * rect.width,
                y: rect.minY + 0.3581 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.0383 * rect.width,
                y: rect.minY + 0.4578 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.1240 * rect.width,
                y: rect.minY + 0.3367 * rect.height
            )
        )
        // Point 2
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.7623 * rect.width,
                y: rect.minY + 0.4945 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.5213 * rect.width,
                y: rect.minY + 0.3795 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.6325 * rect.width,
                y: rect.minY + 0.4918 * rect.height
            )
        )
        // Point 3
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.9318 * rect.width,
                y: rect.minY + 0.3501 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.8920 * rect.width,
                y: rect.minY + 0.4972 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.9310 * rect.width,
                y: rect.minY + 0.4573 * rect.height
            )
        )
        // Point 4
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.9688 * rect.width,
                y: rect.minY + 0.3501 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.9508 * rect.width,
                y: rect.minY + 0.3503 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.9508 * rect.width,
                y: rect.minY + 0.3503 * rect.height
            )
        )
        // Point 5
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.6908 * rect.width,
                y: rect.minY + 0.6443 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.9676 * rect.width,
                y: rect.minY + 0.5502 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.8735 * rect.width,
                y: rect.minY + 0.6683 * rect.height
            )
        )
        // Point 6
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.2353 * rect.width,
                y: rect.minY + 0.5052 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.5080 * rect.width,
                y: rect.minY + 0.6202 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.3783 * rect.width,
                y: rect.minY + 0.5052 * rect.height
            )
        )
        // Point 7
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.0737 * rect.width,
                y: rect.minY + 0.6416 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.0922 * rect.width,
                y: rect.minY + 0.5052 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.0739 * rect.width,
                y: rect.minY + 0.5969 * rect.height
            )
        )
        // Point 8
        path.addCurve(
            to: CGPoint(
                x: rect.minX + 0.0366 * rect.width,
                y: rect.minY + 0.6416 * rect.height
            ),
            controlPoint1: CGPoint(
                x: rect.minX + 0.0547 * rect.width,
                y: rect.minY + 0.6416 * rect.height
            ),
            controlPoint2: CGPoint(
                x: rect.minX + 0.0557 * rect.width,
                y: rect.minY + 0.6416 * rect.height
            )
        )
        
        path.close()
        
        return path
    }
}
