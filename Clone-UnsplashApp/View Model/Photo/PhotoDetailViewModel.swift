//
//  PhotoDetailViewModel.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/25/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import SVProgressHUD

protocol PhotoDetailPopulateable {
    func populatePhotoDetailViewEmpty()
    func populatePhotoDetailView(userPhotoProfile: String?, userUsername: String?, photo: String?, totalViewPhoto: Int?, totalLikePhoto: Int?, totalDownloadPhoto: Int?)
}

protocol PhotoDetailViewModelable {
    //MARK: output
    var userPhotoProfileImage: BehaviorRelay<UIImage?> { get }
    var photoImage: BehaviorRelay<UIImage?> { get }
    var userUsernameLabel: BehaviorRelay<String?> { get }
    var totalViewPhotoLabel: BehaviorRelay<String?> { get }
    var totalLikePhotoLabel: BehaviorRelay<String?> { get }
    var totalDownloadPhotoLabel: BehaviorRelay<String?> { get }
    
    var linkDownload: BehaviorRelay<String?> { get }
}

class PhotoDetailViewModel: PhotoDetailPopulateable, PhotoDetailViewModelable {
    private let apiServiceProvider = MoyaProvider<ApiUnsplashService>()
    private let disposeBag = DisposeBag()
    
    let userPhotoProfileImage = BehaviorRelay<UIImage?>(value: UIImage(named: "default"))
    let photoImage = BehaviorRelay<UIImage?>(value: UIImage(named: ""))
    let userUsernameLabel = BehaviorRelay<String?>(value: "")
    let totalViewPhotoLabel = BehaviorRelay<String?>(value: "")
    let totalLikePhotoLabel = BehaviorRelay<String?>(value: "")
    let totalDownloadPhotoLabel = BehaviorRelay<String?>(value: "")
    
    var linkDownload = BehaviorRelay<String?>(value: "")

    let photoID: String
    
    init(photoID: String) {
        self.photoID = photoID
        SVProgressHUD.show()
        getDetailPhoto()
    }
    
    //MARK: - Private Method
    
    private func getDetailPhoto() {
        apiServiceProvider.request(.getDetailPhoto(photoID: self.photoID, clientID: clientID)) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    self.populatePhotoDetailViewEmpty()
                    SVProgressHUD.dismiss()
                case .success(let response):
                    let photoDetailData = try? JSONDecoder().decode(DetailPhoto.self, from: response.data)
                    print(response)
                    self.populatePhotoDetailView(
                        userPhotoProfile: photoDetailData?.user.profile_image.small,
                        userUsername: photoDetailData?.user.username,
                        photo: photoDetailData?.urls.small,
                        totalViewPhoto: photoDetailData?.views,
                        totalLikePhoto: photoDetailData?.likes,
                        totalDownloadPhoto: photoDetailData?.downloads)
                    self.linkDownload.accept(photoDetailData?.urls.regular)
                    
                    SVProgressHUD.dismiss()
            }
        }
    }
    
    private func setMedia(from url: String?, to imageDatas: BehaviorRelay<UIImage?>) {
        
        guard let url = URL(string: url ?? "") else { return }
        let session = URLSession(configuration: .default)
        
        let downloadImageTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        var image = UIImage(data: imageData)
                        imageDatas.accept(image)
                        image = nil
                    }
                }
            }
            session.finishTasksAndInvalidate()
        }
        downloadImageTask.resume()
    }
    
    //MARK: - Protocol Conformance
    func populatePhotoDetailViewEmpty() {
        populatePhotoDetailView(userPhotoProfile: "", userUsername: "", photo: "", totalViewPhoto: 0, totalLikePhoto: 0, totalDownloadPhoto: 0)
    }
        
    func populatePhotoDetailView(userPhotoProfile: String?, userUsername: String?, photo: String?, totalViewPhoto: Int?, totalLikePhoto: Int?, totalDownloadPhoto: Int?) {
            
        setMedia(from: userPhotoProfile, to: self.userPhotoProfileImage)
        setMedia(from: photo, to: self.photoImage)
        userUsernameLabel.accept(userUsername)
        totalViewPhotoLabel.accept(totalViewPhoto == nil ? "0" : "👁 \(Int(totalViewPhoto!))")
        totalLikePhotoLabel.accept(totalLikePhoto == nil ? "0" : "🖤 \(Int(totalLikePhoto!))")
        totalDownloadPhotoLabel.accept(totalDownloadPhoto == nil ? "0" : "📥 \(Int(totalDownloadPhoto!))")
    }
    
}
