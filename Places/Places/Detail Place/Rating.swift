//
//  Rating.swift
//  Places
//
//  Created by adminaccount on 11/27/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class Rating: UIView {
    var rating: Double = 0.0
    var firstColor: CGColor = UIColor.yellow.cgColor
    var secondColor: CGColor = UIColor.white.cgColor
    
    let angles: [CGFloat] =
        [-9/10*CGFloat.pi, -7/10*CGFloat.pi, -5/10*CGFloat.pi, -3/10*CGFloat.pi, -1/10*CGFloat.pi,
         1/10*CGFloat.pi, 3/10*CGFloat.pi, 5/10*CGFloat.pi, 7/10*CGFloat.pi, 9/10*CGFloat.pi, -9/10*CGFloat.pi]
    var starPoints = [CGPoint] ()
    var filledHalf = [CGPoint] ()
    var emptyHalf = [CGPoint] ()
    
    var starSize: CGFloat = 0
    
    init (x: Double, y: Double, height: Double, currentRate: Double) {
        let frame = CGRect(x: x, y: y, width: height * 5, height: height)
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        starSize = CGFloat(height)
        rating = currentRate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        var center = CGPoint(x: starSize/2, y: rect.midY)
        let radius = rect.maxY/2
        //let smallBeam = radius*CGFloat((sin(18*Double.pi/180)/sin(126*Double.pi/180))) //classic star
        let smallBeam = radius/2 // for fat stars
        var split = CGFloat(rating)
        
        for _ in 1...5 {
            setStarPointsArray(centralPoint: center, longBeam: radius, shortBeam: smallBeam)
            if split > 0 && split < 1{
                setFilledHalfArray(split)
                if split < 0.5 {
                    drawStar(context: context, points: starPoints, color: firstColor)
                    drawStar(context: context, points: emptyHalf, color: secondColor)
                }
                else {
                    drawStar(context: context, points: starPoints, color: secondColor)
                    drawStar(context: context, points: filledHalf, color: firstColor)
                }
            }
            if split <= 0 {
                drawStar(context: context, points: starPoints, color: secondColor)
            }
            if split >= 1 {
                drawStar(context: context, points: starPoints, color: firstColor)
            }
            center.x += starSize
            split -= 1
        }
    }
    
    func createPoint(angle: CGFloat, centralPoint: CGPoint, beam: CGFloat) ->CGPoint {
        return CGPoint(x: cos(angle) * beam + centralPoint.x,
                       y: sin(angle) * beam + centralPoint.y)
    }
    
    func drawStar(context: CGContext, points: [CGPoint], color: CGColor) {
        context.setFillColor(color)
        context.move(to: points[0])
        for dot in points {
            context.addLine(to: dot)
        }
        context.fillPath()
    }
    
    func setFilledHalfArray(_ split: CGFloat) {
        var splitPoint = CGPoint(x: starPoints[0].x + (starPoints[4].x - starPoints[0].x) * split, y: 0)
        filledHalf.append(starPoints[0])
        for currentIndex in 1...10 {
            if  ( starPoints[currentIndex].x >= splitPoint.x && starPoints[currentIndex - 1].x < splitPoint.x ) ||
                ( starPoints[currentIndex].x < splitPoint.x && starPoints[currentIndex - 1].x >= splitPoint.x ) {
                splitPoint.y = ( ( splitPoint.x - starPoints[currentIndex - 1].x) / (starPoints[currentIndex].x - starPoints[currentIndex - 1].x) ) * (starPoints[currentIndex].y - starPoints[currentIndex - 1].y) + starPoints[currentIndex - 1].y
                print(starPoints[currentIndex].x)
                print(split)
                filledHalf.append(splitPoint)
                emptyHalf.append(splitPoint)
            }
            if starPoints[currentIndex].x < splitPoint.x {
                filledHalf.append(starPoints[currentIndex])
                
            }
            if ( starPoints[currentIndex].x > splitPoint.x ) {
                emptyHalf.append(starPoints[currentIndex])
                
            }
        }
    }
    
    func setStarPointsArray(centralPoint: CGPoint, longBeam: CGFloat, shortBeam: CGFloat) {
        starPoints = []
        for index in 0...4 {
            starPoints.append(createPoint(angle: angles[index*2], centralPoint: centralPoint, beam: longBeam))
            starPoints.append(createPoint(angle: angles[index*2 + 1], centralPoint: centralPoint, beam: shortBeam))
        }
        starPoints.append(createPoint(angle: angles[10], centralPoint: centralPoint, beam: longBeam))
    }
}
