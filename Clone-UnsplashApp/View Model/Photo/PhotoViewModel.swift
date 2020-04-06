//
//  PhotoViewModel.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol PhotoViewModelable {
    //MARK: input
    var photoTapped: PublishSubject<Void> { get }
    var searchTapped: PublishSubject<Void> { get }
    var searchBarText: BehaviorRelay<String?> { get }
    
    var endScroll: PublishSubject<Void> { get }
    var pagePhoto: BehaviorRelay<Int?> { get }
    
    var photoID: BehaviorRelay<String?> { get }
    var collectionID: BehaviorRelay<Int?> { get }
    var detailPhotoSubscription: ((_ photoID: String) -> Void)? { get set }
    
    var needLoading: PublishSubject<Bool> { get }
       
    //MARK: output
    var photoCollectionView: BehaviorRelay<[PhotoList?]> { get }
}

class PhotoViewModel: PhotoViewModelable {
    
    private let apiServiceProvider = MoyaProvider<ApiUnsplashService>()
    private let disposeBag = DisposeBag()
    
    var photoCollectionView = BehaviorRelay<[PhotoList?]>(value: [])
    var photoTapped = PublishSubject<Void>()
    var searchTapped = PublishSubject<Void>()
    let searchBarText = BehaviorRelay<String?>(value: "")
    let photoID = BehaviorRelay<String?>(value: "")
    let collectionID = BehaviorRelay<Int?>(value: nil)
    var endScroll = PublishSubject<Void>()
    let pagePhoto = BehaviorRelay<Int?>(value: 1)
    
    var detailPhotoSubscription: ((_ photoID: String) -> Void)?
    
    var searchPhoto = BehaviorRelay<Bool>(value: false)
    var loadPhotoCollection = BehaviorRelay<Bool>(value: false)
    var totalPages = BehaviorRelay<Int?>(value: 1)
    
    var needLoading = PublishSubject<Bool>()
    
    init(listPhotoColection: Bool, collectionID: Int) {
        if listPhotoColection == true {
            self.collectionID.accept(collectionID)
            self.getListCollectionPhoto(collectionID: collectionID, page: 1)
            self.loadPhotoCollection.accept(true)
        } else {
            self.getListPhoto(page: 1)
        }
        self.makeSubscription()
    }
    
    private func makeSubscription() {
        
        searchTapped.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.photoCollectionView.accept([])
            self.pagePhoto.accept(1)
            self.totalPages.accept(1)
            self.searchPhoto.accept(true)
            self.loadPhoto()
            })
        .disposed(by: disposeBag)
        
        photoTapped.subscribe(onNext: { [weak self] _ in
            guard let self =  self else { return }
            self.detailPhotoSubscription?(self.photoID.value!)
            })
        .disposed(by: disposeBag)
        
        endScroll.subscribe(onNext : { [weak self] _ in
            guard let self = self else { return }
            self.loadPhoto()
            })
        .disposed(by: disposeBag)

    }
    
    private func loadPhoto() {
        if searchPhoto.value == true {
            if pagePhoto.value! <= totalPages.value! {
                self.searchPhoto(keyword: self.searchBarText.value!, page: self.pagePhoto.value! + 1)
                self.pagePhoto.accept(self.pagePhoto.value! + 1)
            }
        } else {
            if loadPhotoCollection.value == true {
                self.getListCollectionPhoto(collectionID: collectionID.value!, page: self.pagePhoto.value! + 1)
                self.pagePhoto.accept(self.pagePhoto.value! + 1)
            } else {
                getListPhoto(page: self.pagePhoto.value! + 1)
                self.pagePhoto.accept(self.pagePhoto.value! + 1)
            }
        }
    }
    
    private func getListPhoto(page: Int) {
        self.needLoading.onNext(true)
        self.searchPhoto.accept(false)
        apiServiceProvider.request(.getListPhoto(clientID: clientID, page: page)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.needLoading.onNext(false)
                case .success(let response):
                    let photoData = try? JSONDecoder().decode([PhotoList].self, from: response.data)
                    print(response)
                    
                    self.photoCollectionView.accept(self.photoCollectionView.value + (photoData ?? []))
                    self.needLoading.onNext(false)
            }
        }
    }
    
    private func getListCollectionPhoto(collectionID: Int, page: Int) {
        self.needLoading.onNext(true)
        self.searchPhoto.accept(false)
        apiServiceProvider.request(.getDetailPhotoCollection(collectionPhotoID: collectionID, clientID: clientID, page: page)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.needLoading.onNext(false)
                case .success(let response):
                    let photoData = try? JSONDecoder().decode([PhotoList].self, from: response.data)
                    print(response)
                    
                    self.photoCollectionView.accept(self.photoCollectionView.value + (photoData ?? []))
                    self.needLoading.onNext(false)
            }
        }
    }
    
    private func searchPhoto(keyword: String?, page: Int) {
        self.needLoading.onNext(true)
        apiServiceProvider.request(.searchPhoto(query: keyword!, clientID: clientID, page: page)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.needLoading.onNext(false)
                case .success(let response):
                    let photoData = try? JSONDecoder().decode(SearchPhoto.self, from: response.data)
                    
                    self.totalPages.accept(photoData?.total_pages ?? 0)
                    self.photoCollectionView.accept(self.photoCollectionView.value + (photoData?.results ?? []))
                    self.needLoading.onNext(false)
            }
        }
    }
    
}
