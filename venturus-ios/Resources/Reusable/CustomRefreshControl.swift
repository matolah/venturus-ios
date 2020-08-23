//
//  CustomRefreshControl.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 22/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift

final class CustomRefreshControl: UIControl {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.init(named: K.refreshImageName)
        
        imageView.image = image
        
        imageView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 18, y: 150, width: 36, height: 32)
        
        return imageView
    }()
    
    /// The initial value must be true so that the CollectionView setup doesn't trigger an animation.
    private var isChanged = true {
        didSet {
            switch self.isChanged {
            case true:
                startLayerAnimation()
            case false:
                stopLayerAnimation()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 200))
        self.addTarget(self, action: #selector(changeState), for: .valueChanged)
        addSubview(imageView)
        
        /// Auto centralize
        autoresizingMask =  [.flexibleLeftMargin, .flexibleRightMargin]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func changeState() {
        isChanged = !isChanged
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isChanged = false
        }
    }
    
    func containingScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -80 {
            self.sendActions(for: .valueChanged)
        }
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= -100, isChanged else { return }
        scrollView.contentOffset.y = -80
    }
    
    private func startLayerAnimation() {
        imageView.startRotating(withDuration: 0.5, repeatCount: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            self.imageView.startRotating(withDuration: 0.25, radii: -(CGFloat.pi * 2))
        }
    }
    
    private func stopLayerAnimation() {
        imageView.stopRotating()
    }
}
