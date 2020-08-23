//
//  ViewController.swift
//  venturus-ios
//
//  Created by mateus henrique lino santos on 20/08/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryListViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var reloadImageView: UIImageView!
    
    private lazy var refreshControl = CustomRefreshControl()
    
    private let viewModel = GalleryListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        collectionView.delegate = self
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func setupUI() {
        collectionView.register(UINib(nibName: K.galleryCellName, bundle: nil), forCellWithReuseIdentifier: K.galleryCellName)
        collectionView.addSubview(refreshControl)
    }
    
    private func setupBindings() {
        viewModel.galleries
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] result in self?.emptyView.isHidden = true})
            .bind(to: collectionView.rx.items(cellIdentifier: K.galleryCellName, cellType: GalleryCell.self)) { [weak self] (_, gallery, cell) in
                guard let self = self else { return }
                
                self.setupGalleryCell(cell, gallery: gallery)
        }
        .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.emptyView.isHidden = false
                self.collectionView.reloadData()
                
                self.reloadImageView.startRotating()
                
                /// Auto-reload after failed request
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.viewModel.reload.onNext(())
                    
                    self.reloadImageView.stopRotating()
                }
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
    }
    
    private func setupGalleryCell(_ cell: GalleryCell, gallery: GalleryViewModel) {
        cell.setPhoto(from: gallery.imageLink)
        cell.setUpBalance(to: gallery.upBalance)
        cell.setCommentCount(to: gallery.commentCount)
        cell.setViewCount(to: gallery.viewCount)
    }
}

//MARK: - Refresh Control

/// Subscriptions for the below methods weren't firing properly.
extension GalleryListViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControl.containingScrollViewDidEndDragging(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.didScroll(scrollView)
    }
}
