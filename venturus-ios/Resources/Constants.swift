//
//  Constants.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

struct K {
    static let galleryCellName = "GalleryCell"
    
    static let reloadImageName = "reload"
    static let refreshImageName = "refresh"
    
    static let failureImageColorName = "lightGreyColor"
    static let iconColorName = "iconColor"
    
    static let failureText = "Oh, failed to load galleries"
    
    struct Imgur {
        static let baseUrl = "https://api.imgur.com"
        static let clientId = "7206d825a7e308a"
        
        static let failedRequestDelay = 5.0
    }
}

enum HTTPHeaderField: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
