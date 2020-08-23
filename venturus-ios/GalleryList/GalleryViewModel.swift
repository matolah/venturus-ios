//
//  GalleryViewModel.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewModel {
    //MARK: - Properties
    
    let imageLink: URL
    let upBalance: String
    let commentCount: String
    let viewCount: String
    
    init(gallery: Gallery) {
        func formatValue(_ value: Int) -> String {
            if value > 1000 {
                return "\(value / 1000)K"
            }
            
            return "\(value)K"
        }
        
        self.imageLink = URL(string: gallery.imageLink)!
        self.upBalance = formatValue(gallery.ups - gallery.downs)
        self.commentCount = formatValue(gallery.commentCount)
        self.viewCount = formatValue(gallery.views)
    }
}
