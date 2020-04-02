//
//  CollectionViewModel.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SVProgressHUD

protocol PhotoCollectionViewModelable {
    
    //MARK: input
    var searchTapped: PublishSubject<Void> { get }
    var searchBarText: BehaviorRelay<String?> { get }
    
    var endScroll: PublishSubject<Void> { get }
    var pageCollectionPhoto: BehaviorRelay<Int?> { get }
    
    var needLoading: PublishSubject<Bool> { get }
    
    //MARK: output
    var photoClCollectionView: BehaviorRelay<[PhotoCollection?]> { get }
}

class PhotoCollectionViewModel: PhotoCollectionViewModelable {
    
    private let apiServiceProvider = MoyaProvider<ApiUnsplashService>()
    private let disposeBag = DisposeBag()
    
    var photoClCollectionView = BehaviorRelay<[PhotoCollection?]>(value: [])
    var searchTapped = PublishSubject<Void>()
    let searchBarText = BehaviorRelay<String?>(value: "")
    var endScroll = PublishSubject<Void>()
    let pageCollectionPhoto = BehaviorRelay<Int?>(value: 1)
    
    var searchCollectionPhoto = BehaviorRelay<Bool>(value: false)
    var totalPages = BehaviorRelay<Int?>(value: 1)
    
    var needLoading = PublishSubject<Bool>()
    
    init() {
        getListCollectionPhoto(page: 1)
        makeSubscription()
    }
    
    private func makeSubscription() {
        
        searchTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.photoClCollectionView.accept([])
            self.pageCollectionPhoto.accept(1)
            self.totalPages.accept(1)
            self.searchCollectionPhoto.accept(true)
            self.addCollectionPhotoPage()
            })
        .disposed(by: disposeBag)
        
        endScroll.subscribe(onNext : { [weak self] _ in
            guard let self = self else { return }
            self.addCollectionPhotoPage()
            })
        .disposed(by: disposeBag)

    }
    
    private func addCollectionPhotoPage() {
        if searchCollectionPhoto.value == true {
            if pageCollectionPhoto.value! <= totalPages.value! {
                self.searchCollectionPhoto(keyword: self.searchBarText.value!, page: self.pageCollectionPhoto.value! + 1)
                self.pageCollectionPhoto.accept(self.pageCollectionPhoto.value! + 1)
            }
        } else {
            getListCollectionPhoto(page: self.pageCollectionPhoto.value! + 1)
            self.pageCollectionPhoto.accept(self.pageCollectionPhoto.value! + 1)
        }
    }
    
    private func getListCollectionPhoto(page: Int) {
        self.needLoading.onNext(true)
        self.searchCollectionPhoto.accept(false)
        apiServiceProvider.request(.getListPhotoCollection(clientID: clientID, page: page)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.needLoading.onNext(false)
                case .success(let response):
                    let photoColelctionData = try? JSONDecoder().decode([PhotoCollection].self, from: response.data)
                    print(response)
                    
                    self.photoClCollectionView.accept(self.photoClCollectionView.value + (photoColelctionData ?? []))
                    self.needLoading.onNext(false)
            }
        }
    }
    
    private func searchCollectionPhoto(keyword: String?, page: Int) {
        self.needLoading.onNext(true)
        apiServiceProvider.request(.searchPhotoCollection(query: keyword!, clientID: clientID, page: page)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.needLoading.onNext(false)
                case .success(let response):
                    let photoCollectionData = try? JSONDecoder().decode(SearchPhotoCollection.self, from: response.data)
                    
                    self.totalPages.accept(photoCollectionData?.total_pages ?? 0)
                    self.photoClCollectionView.accept(self.photoClCollectionView.value + (photoCollectionData?.results ?? []))
                    self.needLoading.onNext(false)
            }
        }
    }
    
}
