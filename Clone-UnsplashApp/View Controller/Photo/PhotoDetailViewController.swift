//
//  PhotoDetailViewController.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/25/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var userPhotoProfileImage: UIImageView!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var totalViewPhotoLabel: UILabel!
    @IBOutlet weak var totalLikePhotoLabel: UILabel!
    @IBOutlet weak var totalDownloadPhotoLabel: UILabel!
    
    
    var viewModelPhotoDetail: PhotoDetailViewModelable
    let disposeBag = DisposeBag()
    
    init(viewModel: PhotoDetailViewModelable) {
        self.viewModelPhotoDetail = viewModel
        super.init(nibName: "PhotoDetail", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage()
        bindData()
        
        //title navigation
        navigationItem.title = "Detail Photo"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.tabBarController?.tabBar.barTintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.tabBarController?.tabBar.barTintColor = UIColor.white
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        getDataFromUrl(url: imageUrl) { data, _, _ in
            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func downloadButton(_ sender: Any) {
        downloadImage(url: viewModelPhotoDetail.linkDownload.value!)
        print(viewModelPhotoDetail.linkDownload.value!)
    }
    
    
    //MARK: - Private Method
    
    private func profileImage() {
        userPhotoProfileImage.layer.borderWidth = 0
        userPhotoProfileImage.layer.masksToBounds = false
        userPhotoProfileImage.layer.borderColor = UIColor.black.cgColor
        userPhotoProfileImage.layer.cornerRadius = userPhotoProfileImage.frame.height/2
        userPhotoProfileImage.clipsToBounds = true
    }
    
    private func bindData() {
        
        //Bind Attribute
        viewModelPhotoDetail.userPhotoProfileImage
            .asObservable()
            .map{ $0 }
            .bind(to: self.userPhotoProfileImage.rx.image)
            .disposed(by: disposeBag)
        
        viewModelPhotoDetail.photoImage
            .asObservable()
            .map{ $0 }
            .bind(to: self.photoImage.rx.image)
            .disposed(by: disposeBag)
        
        viewModelPhotoDetail.userUsernameLabel
            .asObservable()
            .map{ $0 }
            .bind(to: self.userUsernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModelPhotoDetail.totalViewPhotoLabel
            .asObservable()
            .map{ $0 }
            .bind(to: self.totalViewPhotoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModelPhotoDetail.totalLikePhotoLabel
            .asObservable()
            .map{ $0 }
            .bind(to: self.totalLikePhotoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModelPhotoDetail.totalDownloadPhotoLabel
            .asObservable()
            .map{ $0 }
            .bind(to: self.totalDownloadPhotoLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
