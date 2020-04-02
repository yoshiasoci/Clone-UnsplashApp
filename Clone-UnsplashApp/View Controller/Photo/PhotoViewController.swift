//
//  PhotoViewController.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PhotoViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var customView = CustomView()
    let loading = SVProgressHUD.self
    
    var photoViewModel: PhotoViewModelable
    let disposeBag = DisposeBag()
    
    init(viewModel: PhotoViewModelable) {
        self.photoViewModel = viewModel
        super.init(nibName: "Photo", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = photoCollectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        self.photoCollectionView.delegate = self
        
        self.photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
        self.photoViewModel.needLoading.onNext(true)
        bindData()
        makeSearchButton()
        
        navigationItem.title = "Photos"

    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.photoCollectionView.reloadData()
        self.photoViewModel.searchBarText.accept(searchBar.text)
        self.photoViewModel.searchTapped.onNext(())
        navigationItem.title = "Photos - \(searchBar.text!)"
        
    }
    
    @objc func showSearchButton(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    //MARK: - Private Method
    
    private func bindData() {
        
        //Need Loading
        photoViewModel.needLoading
            .subscribe{ [weak self] needLoading in
                guard let self = self else { return }
                if needLoading.element ?? false {
                    self.loading.show(withStatus: "Load image..")
                } else {
                    self.loading.dismiss()
                }
        }.disposed(by: disposeBag)
        
//        CollectionView
        photoViewModel.photoCollectionView
            .asObservable()
            .bind(to: photoCollectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCollectionViewCell.self)) { (row,data,cell) in
                cell.populateCell(mediaUrl: data?.urls.small)
        }.disposed(by: disposeBag)
        
////        animation cell
//        photoCollectionView.rx.willDisplayCell
//            .subscribe(onNext: ({ (cell,indexPath) in
//                cell.alpha = 0
//                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
//                cell.layer.transform = transform
//                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                    cell.alpha = 1
//                    cell.layer.transform = CATransform3DIdentity
//                }, completion: nil)
//            })).disposed(by: disposeBag)
        
        //binding cell tapable
        self.photoCollectionView.rx.modelSelected(PhotoList.self)
            .subscribe(onNext: { (photo) in
                //print(photo.id)
                self.photoViewModel.photoID.accept(photo.id)
                self.photoViewModel.photoTapped.onNext(())
        }).disposed(by: disposeBag)
    }
    
    private func makeSearchButton() {
        //add button in right navigation bar
        let searchPhotoButton = UIBarButtonItem(image: customView.resizeImage(image: UIImage(named: "search")!, targetSize: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(showSearchButton))
        self.navigationItem.rightBarButtonItem  = searchPhotoButton
    }
    
}


extension PhotoViewController: CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let photoHeight: Int = photoViewModel.photoCollectionView.value[indexPath.item]!.height
        let photoWidth: Int = photoViewModel.photoCollectionView.value[indexPath.item]!.width

        let cellWidth: CGFloat = UIScreen.main.bounds.size.width / 2
        let height: CGFloat = cellWidth / CGFloat(photoWidth) * CGFloat(photoHeight)
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= photoViewModel.photoCollectionView.value.count - 2/* && isLoading */ {
            self.photoViewModel.endScroll.onNext(())
        }
    }
    
}
