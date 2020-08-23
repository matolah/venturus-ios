//
//  ImgurService.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case cannotParse
}

final class ImgurService {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// - Returns: All Imgur galleries listed in the top section from the current week.
    func getWeeklyHotGalleries() -> Observable<[Gallery]> {
        let url = URL(string: K.Imgur.baseUrl + "/3/gallery/hot/viral/week")!
        
        var request = URLRequest(url: url)
        
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue("Client-ID \(K.Imgur.clientId)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        
        return session.rx
            .json(request: request)
            .flatMap { json throws -> Observable<[Gallery]> in
                guard
                    let json = json as? [String: Any],
                    let dataJSON = json["data"] as? [[String: Any]]
                else { return Observable.error(ServiceError.cannotParse) }
                
                let galleries = dataJSON.compactMap(Gallery.init)
                
                return Observable.just(galleries)
        }
    }
}
