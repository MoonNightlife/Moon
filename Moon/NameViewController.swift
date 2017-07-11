//
//  NameViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift
import Action
import MaterialComponents.MaterialProgressView
import Fusuma

class NameViewController: UIViewController, BindableType, FusumaDelegate {
    var viewModel: NameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    var navBackButton: UIBarButtonItem!
    var progressView: MDCProgressView!
    let imagePicker = UIImagePickerController()
    let fusuma = FusumaViewController()
    let tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        prepareFirstNameTextField()
        prepareLastNameTextField()
        prepareNavigationBackButton()
        prepareProgressView()
        prepareNextScreenButton()
        prepareProfilePic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonPurple
        self.navigationController?.navigationBar.backgroundColor = .moonPurple
        progressView.progress = 0.0
    }
    
    func bindViewModel() {
        
        firstNameTextField.rx.textInput.text.bind(to: viewModel.firstName).addDisposableTo(disposeBag)
        lastNameTextField.rx.textInput.text.bind(to: viewModel.lastName).addDisposableTo(disposeBag)
        
        viewModel.firstNameText.bind(to: firstNameTextField.rx.text).addDisposableTo(disposeBag)
        viewModel.lastNameText.bind(to: lastNameTextField.rx.text).addDisposableTo(disposeBag)
        
        viewModel.dataValid.drive(nextScreenButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        viewModel.image.asObservable().bind(to: profilePic.rx.image).addDisposableTo(disposeBag)

        nextScreenButton.rx
            .controlEvent(.touchUpInside)
            .do(onNext: { [weak self] in
                self?.progressView.setProgress(0.25, animated: true, completion: nil)
            })
            .subscribe(onNext: { [weak self] in
                self?.viewModel.nextSignUpScreen().execute()
            })
            .addDisposableTo(disposeBag)
        
        navBackButton.rx.action = viewModel.onBack()
        
    }
    
    func progressAction() -> Action<Void, Void> {
        return Action(workFactory: { [unowned self] _ in
            return Observable.create({ (observer) -> Disposable in
                self.progressView.setProgress(0.25, animated: true, completion: { (completed) in
                    if completed {
                        return observer.onNext()
                    }
                    return observer.onCompleted()
                })
                return Disposables.create()
            })
        })
    }
    
    // MARK: FUSUMA DELEGATES for image cropping
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        //let i  = image.crop(toWidth: 200, toHeight: 200) // circle image
        profilePic.image = image
        viewModel.selectedImage.value = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Multiple Images Selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
}
extension NameViewController {
    
    fileprivate func prepareFirstNameTextField() {
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.isClearIconButtonEnabled = true
        firstNameTextField.dividerActiveColor = .moonPurple
        firstNameTextField.dividerNormalColor = .moonPurple
        firstNameTextField.placeholderActiveColor = .moonPurple
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        firstNameTextField.leftView = leftView
        firstNameTextField.leftViewActiveColor = .moonPurple
    }
    
    fileprivate func prepareLastNameTextField() {
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.isClearIconButtonEnabled = true
        lastNameTextField.dividerActiveColor = .moonPurple
        lastNameTextField.dividerNormalColor = .moonPurple
        lastNameTextField.placeholderActiveColor = .moonPurple
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        lastNameTextField.leftView = leftView
        lastNameTextField.leftViewActiveColor = .moonPurple
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareNextScreenButton() {
        nextScreenButton.backgroundColor = .moonPurple
        nextScreenButton.setTitle("Next", for: .normal)
        nextScreenButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
        nextScreenButton.tintColor = .white
        nextScreenButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareProgressView() {
        
        progressView = MDCProgressView()
        progressView.trackTintColor = .moonGreenLight
        progressView.progressTintColor = .moonGreen
        
        let progressViewHeight = CGFloat(3)
        progressView.setHidden(false, animated: true)
        progressView.frame = CGRect(x: 0, y: 65, width: view.bounds.width, height: progressViewHeight)
        view.addSubview(progressView)
        
    }
    
    fileprivate func prepareFusuma() {
        fusuma.delegate = self
        fusuma.hasVideo = false
        fusumaTintColor = .moonPurple
        fusumaBaseTintColor = .moonPurple
        fusumaBackgroundColor = .white
        fusumaCropImage = true
        fusuma.cropHeightRatio = CGFloat(1)
        fusuma.allowMultipleSelection = false
    }
    
    @objc fileprivate func imageTouched() {
        prepareFusuma()
        self.present(fusuma, animated: true, completion: nil)
    }
    
    fileprivate func prepareProfilePic() {
        profilePic.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(imageTouched))
        profilePic.addGestureRecognizer(tap)
        profilePic.layer.cornerRadius = profilePic.frame.size.height  / 2
        profilePic.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profilePic.contentMode = UIViewContentMode.scaleAspectFill
        profilePic.clipsToBounds = true
    }

}
