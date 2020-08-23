//
//  Gallery.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

struct Gallery {
    let imageLink: String
    let views, ups, downs, commentCount: Int
}

extension Gallery {
    init?(from json: [String: Any]) {
        guard
            let images = json["images"] as? [[String: Any]],
            let views = json["views"] as? Int,
            let ups = json["ups"] as? Int,
            let downs = json["downs"] as? Int,
            let commentCount = json["comment_count"] as? Int
        else { return nil }
        
        let imageLink = images.compactMap({ $0["link"] })[0] as! String
        
        self.init(imageLink: imageLink, views: views, ups: ups, downs: downs, commentCount: commentCount)
    }
}
