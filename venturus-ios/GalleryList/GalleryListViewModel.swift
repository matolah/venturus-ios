//
//  GalleryListViewModel.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift

class GalleryListViewModel {
    //MARK: - Inputs
    
    /// Call to reload galleries.
    let reload: AnyObserver<Void>
    
    //MARK: - Outputs
    
    /// Emits an array of fetched galleries.
    let galleries: Observable<[GalleryViewModel]>
    
    /// Emits an error message to be shown.
    let errorMessage: Observable<String>
    
    init(imgurService: ImgurService = ImgurService()) {
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        /// Materialize the return so that the observable doesn't get disposed on an error.
        /// Elements in buffer immediately replayed.
        let result = _reload
            .flatMapLatest { _ in
                return imgurService.getWeeklyHotGalleries()
                    .materialize()
            }
            .share()
        
        self.galleries = result
            .compactMap { $0.element?.map(GalleryViewModel.init) }
        
        self.errorMessage = result
            .compactMap { $0.error?.localizedDescription }
    }
}
