//
//  ScreenPieceLayer.swift
//  SplashAnimation
//
//  Created by Connor Reid on 1/11/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

import UIKit

class Slice: CAShapeLayer {
    
    var animationDuration = 0.0
    
    fileprivate var splines = [[CGPoint]]()
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    enum positions{
        case top, topRight, bottomRight, bottom, bottomLeft, topLeft
    }
    
    override init(){
        super.init()
        fillColor = Colours.red.cgColor
        strokeColor = Colours.red.cgColor
        lineWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPoints(_ position: positions){
        self.width = frame.width
        self.height = frame.height
        let centerPoint = CGPoint(x: width/2, y: height/2)
        switch position {
        case .top:
            
            fillColor = Colours.orange.cgColor
            strokeColor = Colours.orange.cgColor
            
            let refAngle = CGFloat(M_PI) - atan((height/2)/(width/2))
            let refAngle2 = CGFloat(M_PI) + atan((height/2)/(width/2))
            let refAngle3 = CGFloat(M_PI) + atan((height/2)/(width/2))/2
            
            //  Starting Points (Boarder Line) (1)
            var firstPoint = CGPoint(x: 0, y: 0)        //  Top
            var secondPoint = CGPoint(x: width, y: 0)   //  Bottom
            var thirdPoint = CGPoint(x: width/2, y: 0)  //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle (2)
            firstPoint = CGPoint(x: 0, y: 0)            //  Top
            secondPoint = CGPoint(x: width, y: 0)       //  Bottom
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (3)
            firstPoint = CGPoint(x: 0, y: 0)
            secondPoint = CGPoint(x: width/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (3)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (4)
            firstPoint = CGPoint(x: width/2, y: 0)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = CGPoint(x: width/4, y: height/2)
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (4)
            firstPoint = CGPoint(x: width/2, y: 0)
            secondPoint = getRadiusPoint(refAngle, radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (5)
            firstPoint = CGPoint(x: width/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (5)
            firstPoint = CGPoint(x: width/4, y: height/2)
            secondPoint = CGPoint(x: width*3/8, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = getRadiusPoint(refAngle2, radius: width/4)
            secondPoint = getRadiusPoint(refAngle3, radius: width/4)
            thirdPoint = CGPoint(x: width/4, y: height/2)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = getRadiusPoint(refAngle2, radius: width/4)
            secondPoint = getRadiusPoint(refAngle3, radius: width/4)
            thirdPoint = CGPoint(x: width/4, y: height/2)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: 0, y: height)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: 0, y: height/2)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        case .topRight:
            
            fillColor = Colours.red.cgColor
            strokeColor = Colours.red.cgColor
            
            let refAngle = CGFloat(M_PI) - atan((height/2)/(width/2))
            let refAngle2 = CGFloat(M_PI) - atan((height/2)/(width/2))/2
            let refAngle3 = CGFloat(M_PI) - atan((height/2)/(width/2))/8
           
            //  Starting Points (Boarder Line)
            var firstPoint = CGPoint(x: width, y: 0)        //  Top
            var secondPoint = CGPoint(x: width, y: height/2)   //  Bottom
            var thirdPoint = CGPoint(x: width, y: height/4)  //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle
            firstPoint = CGPoint(x: width, y: 0)            //  Top
            secondPoint = CGPoint(x: width, y: height/2)    //  Bottom
            thirdPoint = getRadiusPoint(refAngle, radius: height/4)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (b)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width/2, y: height/8)
            thirdPoint = getRadiusPoint(refAngle, radius: 3*height/8)
            fourthPoint = centerPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (a)
            firstPoint = CGPoint(x: width, y: height/2)
            secondPoint = CGPoint(x: width/2, y: 3*height/8)
            thirdPoint = getRadiusPoint(refAngle, radius: height/8)
            fourthPoint = centerPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (d)
            firstPoint = CGPoint(x: width, y: height/4)
            secondPoint = CGPoint(x: width/2, y: height/8)
            thirdPoint = getRadiusPoint(refAngle3, radius: 3*height/8)
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (c)
            firstPoint = CGPoint(x: width, y: height/4)
            secondPoint = getRadiusPoint(refAngle, radius: height/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (f)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = CGPoint(x: width/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (e)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(CGFloat(M_PI*3/8), radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = CGPoint(x: width/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = CGPoint(x: width/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: 0, y: height/2)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: 0, y: 0)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        case .bottomRight:
            
            fillColor = Colours.mustard.cgColor
            strokeColor = Colours.mustard.cgColor
            
            let refAngle = atan((height/2)/(width/2))
            let refAngle2 = CGFloat(M_PI) - atan((height/2)/(width/2))
            
            //  Starting Points (Boarder Line)
            var firstPoint = CGPoint(x: width, y: height)        //  Top
            var secondPoint = CGPoint(x: width, y: height/2)   //  Bottom
            var thirdPoint = CGPoint(x: width, y: height*3/4)  //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle
            firstPoint = CGPoint(x: width, y: height)            //  Top
            secondPoint = CGPoint(x: width, y: height/2)    //  Bottom
            thirdPoint = CGPoint(x: width*3/4, y: height/2)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (b)
            firstPoint = CGPoint(x: width, y: height)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (a)
            firstPoint = CGPoint(x: width, y: height/2)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (d)
            firstPoint = CGPoint(x: width, y: height*3/4)
            secondPoint = centerPoint
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (c)
            firstPoint = CGPoint(x: width, y: height*3/4)
            secondPoint = getRadiusPoint(refAngle, radius: width*3/8)
            thirdPoint = getRadiusPoint(refAngle2, radius: width/8)
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (f)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(refAngle, radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (e)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = CGPoint(x: width/2, y: (height/2)-(width/4))
            thirdPoint = getRadiusPoint(refAngle2, radius: width/4)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = CGPoint(x: width/2, y: (height/2)-(width/4))
            thirdPoint = getRadiusPoint(refAngle2, radius: width/4)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: 0, y: 0)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        case .bottom:
            
            fillColor = Colours.aqua.cgColor
            strokeColor = Colours.aqua.cgColor
            
            let refAngle = CGFloat(M_PI*2) - atan((height/2)/(width/2))
            let refAngle2 = atan((height/2)/(width/2))
            let refAngle3 = atan((height/2)/(width/2))/2
            
            //  Starting Points (Boarder Line) (1)
            var firstPoint = CGPoint(x: width, y: height)       //  Top
            var secondPoint = CGPoint(x: 0, y: height)           //  Bottom
            var thirdPoint = CGPoint(x: width/2, y: height)          //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle (2)
            firstPoint = CGPoint(x: width, y: height)             //  Top
            secondPoint = CGPoint(x: 0, y: height)                //  Bottom
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (3)
            firstPoint = CGPoint(x: width, y: height)
            secondPoint = CGPoint(x: width*3/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (3)
            firstPoint = CGPoint(x: 0, y: height)
            secondPoint = CGPoint(x: width*3/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (4)
            firstPoint = CGPoint(x: width/2, y: height)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = CGPoint(x: width*3/4, y: height/2)
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (4)
            firstPoint = CGPoint(x: width/2, y: height)
            secondPoint = getRadiusPoint(refAngle, radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (5)
            firstPoint = CGPoint(x: width*3/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (5)
            firstPoint = CGPoint(x: width*3/4, y: height/2)
            secondPoint = CGPoint(x: width*5/8, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = getRadiusPoint(refAngle2, radius: width/4)
            secondPoint = getRadiusPoint(refAngle3, radius: width/4)
            thirdPoint = CGPoint(x: width*3/4, y: height/2)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = getRadiusPoint(refAngle2, radius: width/4)
            secondPoint = getRadiusPoint(refAngle3, radius: width/4)
            thirdPoint = CGPoint(x: width*3/4, y: height/2)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: width, y: height/2)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        case .bottomLeft:
            
            fillColor = Colours.purple.cgColor
            strokeColor = Colours.purple.cgColor
            
            let refAngle = CGFloat(2*M_PI) - atan((height/2)/(width/2))
            let refAngle2 = CGFloat(2*M_PI) - atan((height/2)/(width/2))/2
            let refAngle3 = CGFloat(2*M_PI) - atan((height/2)/(width/2))/8
            
            //  Starting Points (Boarder Line)
            var firstPoint = CGPoint(x: 0, y: height)           //  Top
            var secondPoint = CGPoint(x: 0, y: height/2)        //  Bottom
            var thirdPoint = CGPoint(x: 0, y: height*3/4)       //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle
            firstPoint = CGPoint(x: 0, y: height)            //  Top
            secondPoint = CGPoint(x: 0, y: height/2)    //  Bottom
            thirdPoint = getRadiusPoint(refAngle, radius: height/4)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (b)
            firstPoint = CGPoint(x: 0, y: height)
            secondPoint = CGPoint(x: width/2, y: height*7/8)
            thirdPoint = getRadiusPoint(refAngle, radius: 3*height/8)
            fourthPoint = centerPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (a)
            firstPoint = CGPoint(x: 0, y: height/2)
            secondPoint = CGPoint(x: width/2, y: 5*height/8)
            thirdPoint = getRadiusPoint(refAngle, radius: height/8)
            fourthPoint = centerPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (d)
            firstPoint = CGPoint(x: 0, y: height*3/4)
            secondPoint = CGPoint(x: width/2, y: height*7/8)
            thirdPoint = getRadiusPoint(refAngle3, radius: 3*height/8)
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (c)
            firstPoint = CGPoint(x: 0, y: height*3/4)
            secondPoint = getRadiusPoint(refAngle, radius: height/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (f)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = CGPoint(x: width*3/4, y: height/2)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (e)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(CGFloat(M_PI+(M_PI*3/8)), radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = CGPoint(x: width*3/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = CGPoint(x: width*3/4, y: height/2)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = getRadiusPoint(refAngle, radius: width/4)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: width, y: height/2)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: width, y: height)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        case .topLeft:
            
            fillColor = Colours.blue.cgColor
            strokeColor = Colours.blue.cgColor
            
            let refAngle = CGFloat(M_PI) + atan((height/2)/(width/2))
            let refAngle2 = CGFloat(2*M_PI) - atan((height/2)/(width/2))
            
            //  Starting Points (Boarder Line)
            var firstPoint = CGPoint(x: 0, y: 0)        //  Top
            var secondPoint = CGPoint(x: 0, y: height/2)   //  Bottom
            var thirdPoint = CGPoint(x: 0, y: height/4)  //  Middle
            var fourthPoint = CGPoint.zero
            let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(first)
            
            //  First Triangle
            firstPoint = CGPoint(x: 0, y: 0)            //  Top
            secondPoint = CGPoint(x: 0, y: height/2)    //  Bottom
            thirdPoint = CGPoint(x: width/4, y: height/2)
            fourthPoint = CGPoint.zero
            let second = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(second)
            
            //  third Shape Cubic Spline (Top) (b)
            firstPoint = CGPoint(x: 0, y: 0)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let third = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(third)
            
            //  third Shape Cubic Spline (Bottom) (a)
            firstPoint = CGPoint(x: 0, y: height/2)
            secondPoint = getRadiusPoint(refAngle, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = secondPoint
            let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fourth)
            
            //  fourth Shape Cubic Splines (Top) (d)
            firstPoint = CGPoint(x: 0, y: height/4)
            secondPoint = centerPoint
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(fifth)
            
            //  fourth Shape Cubic Splines (Bottom) (c)
            firstPoint = CGPoint(x: 0, y: height/4)
            secondPoint = getRadiusPoint(refAngle, radius: width*3/8)
            thirdPoint = getRadiusPoint(refAngle2, radius: width/8)
            fourthPoint = centerPoint
            let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(sixth)
            
            //  fifth Shape Cubic Splines (Top) (f)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(refAngle, radius: width/8)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(seventh)
            
            //  fifth Shape Cubic Splines (Bottom) (e)
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(refAngle2, radius: width/4)
            thirdPoint = secondPoint
            fourthPoint = centerPoint
            let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eighth)
            
            //  sixth Shape Arc
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(CGFloat(M_PI*3/2), radius: width/4)
            thirdPoint = getRadiusPoint(refAngle2, radius: width/4)
            fourthPoint = centerPoint
            let ninth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(ninth)
            
            //  Open Arc
            firstPoint = getRadiusPoint(refAngle, radius: width/4)
            secondPoint = getRadiusPoint(CGFloat(M_PI*3/2), radius: width/4)
            thirdPoint = getRadiusPoint(refAngle2, radius: width/4)
            fourthPoint = secondPoint
            let tenth = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(tenth)
            
            //  extend arc
            firstPoint = CGPoint(x: 0, y: height)
            secondPoint = CGPoint(x: width/2, y: height/2)
            thirdPoint = CGPoint(x: width, y: height)
            fourthPoint = secondPoint
            let eleventh = [firstPoint, secondPoint, thirdPoint, fourthPoint]
            splines.append(eleventh)
            
        }
    }
    
    func getRadiusPoint(_ theta: CGFloat, radius: CGFloat) -> CGPoint{
        let point = CGPoint(x: cos(theta)*radius + width/2, y: height/2 - sin(theta)*radius)
        return point
    }
    
    func startingPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[0][0])
        path.addLine(to: splines[0][1])
        path.addLine(to: splines[0][2])
        path.close()
        return path
    }
    
    func secondPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[1][0])
        path.addLine(to: splines[1][1])
        path.addLine(to: splines[1][2])
        path.close()
        return path
    }
    
    func thirdPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[2][0])     // Top
        path.addLine(to: splines[3][0])  //  Bottom
        path.addCurve(to: splines[3][3], controlPoint1: splines[3][1], controlPoint2: splines[3][2]) // Bottom Curve
        path.addCurve(to: splines[2][0], controlPoint1: splines[2][2], controlPoint2: splines[2][1]) // Top  Curve
        path.close()
        return path
    }
    
    func fourthPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[4][0])     // Top
        path.addLine(to: splines[5][0])  //  Bottom
        path.addCurve(to: splines[5][3], controlPoint1: splines[5][1], controlPoint2: splines[5][2]) // Bottom Curve
        path.addCurve(to: splines[4][0], controlPoint1: splines[4][2], controlPoint2: splines[4][1]) // Top  Curve
        path.close()
        return path
    }
    
    func fifthPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[6][0])     // Top
        path.addLine(to: splines[7][0])  //  Bottom
        path.addCurve(to: splines[7][3], controlPoint1: splines[7][1], controlPoint2: splines[7][2]) // Bottom Curve
        path.addCurve(to: splines[6][0], controlPoint1: splines[6][2], controlPoint2: splines[6][1]) // Top  Curve
        path.close()
        return path
    }

    func sixthPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[8][0])
        path.addQuadCurve(to: splines[8][2], controlPoint: splines[8][1])
        path.addLine(to: splines[8][3])
        path.close()
        return path
    }
    
    func openArcPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[9][0])
        path.addQuadCurve(to: splines[9][2], controlPoint: splines[9][1])
        path.addLine(to: splines[9][3])
        path.close()
        return path
    }
    
    func extendArcToBoundaries() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: splines[10][0])
        path.addLine(to: splines[10][2])
        path.addLine(to: splines[10][1])
        path.close()
        return path
    }
    
    func animate(_ position: positions){
        initPoints(position)
        
        let path1 = startingPath().cgPath
        let path2 = secondPath().cgPath
        let path3 = thirdPath().cgPath
        let path4 = fourthPath().cgPath
        let path5 = fifthPath().cgPath
        let path6 = sixthPath().cgPath
        
        //  Animation Durations
        let d1 = 0.3
        let d2 = 0.3
        let d3 = 0.3
        let d4 = 0.3
        let d5 = 0.4
        
        animationDuration = d1 + d2 + d3 + d5
        
        let startAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        startAnimation.fromValue = path1
        startAnimation.toValue = path2
        startAnimation.beginTime = 0.0
        startAnimation.duration = d1
        
        let secondAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        secondAnimation.fromValue = path2
        secondAnimation.toValue = path3
        secondAnimation.beginTime = startAnimation.beginTime + startAnimation.duration
        secondAnimation.duration = d2
        
        let thirdAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        thirdAnimation.fromValue = path3
        thirdAnimation.toValue = path4
        thirdAnimation.beginTime = secondAnimation.beginTime + secondAnimation.duration
        thirdAnimation.duration = d3
        
        let fourthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        fourthAnimation.fromValue = path4
        fourthAnimation.toValue = path5
        fourthAnimation.beginTime = thirdAnimation.beginTime + thirdAnimation.duration
        fourthAnimation.duration = d4
        
        let fifthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        fifthAnimation.fromValue = path5
        fifthAnimation.toValue = path6
        fifthAnimation.beginTime = fourthAnimation.beginTime + fourthAnimation.duration
        fifthAnimation.duration = d5
        
        let shrinkAnimationGroup : CAAnimationGroup = CAAnimationGroup()
        shrinkAnimationGroup.animations = [startAnimation, secondAnimation, thirdAnimation, fourthAnimation, fifthAnimation]
        shrinkAnimationGroup.duration = fifthAnimation.beginTime + fifthAnimation.duration
        shrinkAnimationGroup.fillMode = kCAFillModeForwards
        shrinkAnimationGroup.isRemovedOnCompletion = false
        add(shrinkAnimationGroup, forKey: nil)
    }
    
    func openAnimation(){
        let closedPath = sixthPath().cgPath
        let openPath = openArcPath().cgPath
        let extendedPath = extendArcToBoundaries().cgPath
        
        let d = 0.3
        let d2 = 0.3
        
        let openAnimation = CABasicAnimation(keyPath: "path")
        openAnimation.fromValue = closedPath
        openAnimation.toValue = extendedPath
        openAnimation.beginTime = CACurrentMediaTime()
        openAnimation.duration = d
        openAnimation.fillMode = kCAFillModeForwards
        openAnimation.isRemovedOnCompletion = false
        
        let extendAnimation = CABasicAnimation(keyPath: "path")
        extendAnimation.fromValue = openPath
        extendAnimation.toValue = extendedPath
        extendAnimation.beginTime = openAnimation.beginTime + openAnimation.duration
        extendAnimation.duration = d2
        
        let extendAnimationGroup = CAAnimationGroup()
        extendAnimationGroup.animations = [openAnimation, extendAnimation]
        extendAnimationGroup.duration = extendAnimation.beginTime + extendAnimation.duration
        extendAnimationGroup.fillMode = kCAFillModeForwards
        extendAnimationGroup.isRemovedOnCompletion = false
        
        add(openAnimation, forKey: nil)
        
    }

}
