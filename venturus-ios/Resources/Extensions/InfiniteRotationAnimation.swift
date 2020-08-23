//
//  InfiniteRotationAnimation.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 22/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

extension UIView {
    func startRotating(withDuration duration: Double = 1, radii: CGFloat = CGFloat.pi * 2, repeatCount: Float = Float.infinity) {
        /// CABasicAnimation gives more control and easier implementation in a infinite rotation animation than UIView.Animate.
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = radii
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = repeatCount
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopRotating() {
        self.layer.removeAllAnimations()
        self.transform = .identity
    }
}
