//
//  HolderView.swift
//  SplashAnimation
//
//  Created by Connor Reid on 1/11/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
    func animateLabel()
}

class HolderView: UIView {
    
    weak var delegate:HolderViewDelegate?
    
    let topPiece = Slice()
    let topRightPiece = Slice()
    let topLeftPiece = Slice()
    let bottomLeftPiece = Slice()
    let bottomRightPiece = Slice()
    let bottomPiece = Slice()
    
    var ovalLayer = OvalLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colours.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPieces() {
        layer.addSublayer(topPiece)
        layer.addSublayer(topRightPiece)
        layer.addSublayer(topLeftPiece)
        layer.addSublayer(bottomLeftPiece)
        layer.addSublayer(bottomRightPiece)
        layer.addSublayer(bottomPiece)
        
        topPiece.frame = self.frame
        topRightPiece.frame = self.frame
        topLeftPiece.frame = self.frame
        bottomLeftPiece.frame = self.frame
        bottomRightPiece.frame = self.frame
        bottomPiece.frame = self.frame
        
        topPiece.animate(Slice.positions.top)
        topRightPiece.animate(Slice.positions.topRight)
        topLeftPiece.animate(Slice.positions.topLeft)
        bottomLeftPiece.animate(Slice.positions.bottomLeft)
        bottomRightPiece.animate(Slice.positions.bottomRight)
        bottomPiece.animate(Slice.positions.bottom)
        Timer.scheduledTimer(timeInterval: topRightPiece.animationDuration-0.4, target: self, selector: #selector(self.beginCircleTwirl), userInfo: nil, repeats: false)
    }
    
    func beginCircleTwirl() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 0.9
            animate.repeatCount = 3
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * -2.0)
            animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.layer.add(animate, forKey: kAnimationKey)
        }
        
        Timer.scheduledTimer(timeInterval: 0.9*3, target: self, selector: #selector(self.stopRotating), userInfo: nil, repeats: false)
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        ovalLayer.frame = self.frame
        layer.addSublayer(ovalLayer)
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
        
        ovalLayer.expand()
        topPiece.openAnimation()
        topLeftPiece.openAnimation()
        bottomLeftPiece.openAnimation()
        bottomPiece.openAnimation()
        bottomRightPiece.openAnimation()
        topRightPiece.openAnimation()
        
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.endSplash), userInfo: nil, repeats: false)
    }
    
    func endSplash(){
        delegate?.animateLabel()    //   Takes 1 second
        //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.contractCircle), userInfo: nil, repeats: false)
    }
    
    func contractCircle(){
        ovalLayer.contract()
    }
}
