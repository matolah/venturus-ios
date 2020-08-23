//
//  GalleryCell.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import Nuke

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var upBalanceLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    private var isLoadingImage: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 6
        
        infoContainerView.layer.cornerRadius = 6
        
        infoContainerView.alpha = 0
        photoView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            self.infoContainerView.alpha = 1.0
            self.photoView.alpha = 1.0
        }
    }
    
    func setUpBalance(to upBalance: String) {
        upBalanceLabel.text = upBalance
    }
    
    func setCommentCount(to commentCount: String) {
        commentCountLabel.text = commentCount
    }
    
    func setViewCount(to viewCount: String) {
        viewCountLabel.text = viewCount
    }
}

//MARK: - Animation Handler

extension GalleryCell {
    /// Nuke will check if the image exists in the memory cache,
    /// if it does, will instantly display it.
    /// If not, the image data will be loaded, decoded, processed, and decompressed in the background.
    func setPhoto(from url: URL) {
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: K.reloadImageName),
            failureImage: UIImage(named: K.reloadImageName),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )
        
        Nuke.loadImage(
            with: url,
            options: options,
            into: photoView,
            progress: { [weak self] _, completed, total in
                guard let self = self else { return }
                
                if self.isLoadingImage == false {
                    self.isLoadingImage = true
                    self.photoView.backgroundColor = .clear
                    self.photoView.startRotating(withDuration: 1)
                }
            },
            completion: { [weak self] result in
                guard let self = self else { return }
                
                self.isLoadingImage = false
                
                self.photoView.stopRotating()
                
                switch result {
                case .success(_):
                    self.photoView.backgroundColor = .clear
                    break
                case .failure(_):
                    self.photoView.backgroundColor = UIColor.init(named: K.failureImageColorName)
                    break
                }
            }
        )
    }
}
