//
//  CollectionViewController.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PhotoCollectionViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var photoClCollectionView: UICollectionView!
    
    var customView = CustomView()
    let loading = SVProgressHUD.self
    
    var photoCollectionViewModel: PhotoCollectionViewModelable
    let disposeBag = DisposeBag()
    
    init(viewModel: PhotoCollectionViewModelable) {
        self.photoCollectionViewModel = viewModel
        super.init(nibName: "PhotoCollection", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = photoClCollectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        self.photoClCollectionView.delegate = self
        
        self.photoClCollectionView.register(UINib(nibName: "PhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionCell")
        
        bindData()
        makeSearchButton()

        navigationItem.title = "Photo Collections"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.photoClCollectionView.reloadData()
        self.photoCollectionViewModel.searchBarText.accept(searchBar.text)
        self.photoCollectionViewModel.searchTapped.onNext(())
        navigationItem.title = "Collections - \(searchBar.text!)"
    }
    
    @objc func showSearchButton(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    //MARK: - Private Method
    
    private func bindData() {
        
        //Need Loading
        photoCollectionViewModel.needLoading
            .subscribe{ [weak self] needLoading in
                guard let self = self else { return }
                if needLoading.element ?? false {
                    self.loading.show(withStatus: "Load image..")
                } else {
                    self.loading.dismiss()
                }
        }.disposed(by: disposeBag)
        
        //CollectionView
        photoCollectionViewModel.photoClCollectionView
            .asObservable()
            .bind(to: photoClCollectionView.rx.items(cellIdentifier: "PhotoCollectionCell", cellType: PhotoCollectionCollectionViewCell.self)) { (row,data,cell) in
                cell.populateCell(mediaUrl: data?.cover_photo.urls.thumb, collectionTitle: data?.title)
        }.disposed(by: disposeBag)
        
        //Cell Tapped
        self.photoClCollectionView.rx.modelSelected(PhotoCollection.self)
            .subscribe(onNext: { (photoCollection) in
//                print(photoCollection.id)
                self.photoCollectionViewModel.collectionID.accept(photoCollection.id)
                self.photoCollectionViewModel.collectionTapped.onNext(())
        }).disposed(by: disposeBag)
        
    }
    
    private func makeSearchButton() {
        //add button in right navigation bar
        let searchColelctionButton = UIBarButtonItem(image: customView.resizeImage(image: UIImage(named: "search")!, targetSize: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(showSearchButton))
        self.navigationItem.rightBarButtonItem  = searchColelctionButton
    }
    
}

extension PhotoCollectionViewController: CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = UIScreen.main.bounds.size.width / 2
        return cellWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= photoCollectionViewModel.photoClCollectionView.value.count - 2/* && isLoading */ {
            self.photoCollectionViewModel.endScroll.onNext(())
        }
    }
    
}
