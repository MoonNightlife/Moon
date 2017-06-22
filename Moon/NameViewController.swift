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

class NameViewController: UIViewController, BindableType, UIImagePickerControllerDelegate {
    
    var viewModel: NameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    var navBackButton: UIBarButtonItem!
    var progressView: MDCProgressView!
    fileprivate let imagePicker = UIImagePickerController()
    let tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        prepareFirstNameTextField()
        prepareLastNameTextField()
        prepareNavigationBackButton()
        prepareProgressView()
        prepareNextScreenButton()
        prepareProfilePic()
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonPurple
        self.navigationController?.navigationBar.backgroundColor = .moonPurple
        progressView.progress = 0.0
    }
    
    func bindViewModel() {
        firstNameTextField.rx.textInput.text.orEmpty.bind(to: viewModel.firstName).addDisposableTo(disposeBag)
        lastNameTextField.rx.textInput.text.orEmpty.bind(to: viewModel.lastName).addDisposableTo(disposeBag)
        
        viewModel.dataValid.drive(nextScreenButton.rx.isEnabled).addDisposableTo(disposeBag)

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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("working")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = pickedImage
            print("Image picked")
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    @objc fileprivate func imageTouched() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
