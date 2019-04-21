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
    
    var shape = Shape.diamond
    var style = Style.solid
    var color = Color.green
    var number = Number.one
    
    override func draw(_ rect: CGRect) {
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
                    x: bounds.size.width / 4, y: bounds.size.height / 4,
                    width: bounds.size.width / 2, height: bounds.size.height / 2
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
        
        let numLines = 12
        let stripes = UIBezierPath()
        stripes.lineWidth = 2.0
        
        for pos in 0..<numLines {
            let curX = CGFloat(pos) * bounds.size.width / CGFloat(numLines)
            stripes.move(
                to: CGPoint(
                    x: curX,
                    y: 0
                )
            )
            stripes.addLine(to: CGPoint(x: curX, y: bounds.size.height))
        }
        
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
                let context = UIGraphicsGetCurrentContext()
                context!.saveGState()
                
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
                let context = UIGraphicsGetCurrentContext()
                context!.saveGState()
                
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
    }
    
    private func bezierSquiggle(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
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
