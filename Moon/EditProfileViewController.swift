//
//  EditProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import Action
import RAReorderableLayout
import Fusuma
import SwiftOverlays

class EditProfileViewController: UIViewController, BindableType, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UIScrollViewDelegate, UITextFieldDelegate, FusumaDelegate {

    var viewModel: EditProfileViewModel!
    var bag = DisposeBag()
    var cancelButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var offSet: CGFloat!
    var keyboardHeight: CGFloat!
    let fusuma = FusumaViewController()
    fileprivate var index: NSIndexPath!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bioTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Profile"

        prepareNavigationButtons()
        prepareCollectionView()
        prepareFirstNameTextField()
        prepareLastNameTextField()
        prepareBioTextField()
        prepareScrollView()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.onBack()
        
        let saveAction = viewModel.onSave()
        saveButton.rx.action = saveAction
        saveAction.executing.do(onNext: {
            if $0 {
                SwiftOverlays.showBlockingWaitOverlayWithText("Updating Profile")
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
            }
        })
        .subscribe()
        .addDisposableTo(bag)
        
        viewModel.firstNameText.asObservable().bind(to: firstNameTextField.rx.text).addDisposableTo(bag)
        viewModel.lastNameText.asObservable().bind(to: lastNameTextField.rx.text).addDisposableTo(bag)
        viewModel.bioText.asObservable().bind(to: bioTextField.rx.text).addDisposableTo(bag)
        
        firstNameTextField.rx.text.bind(to: viewModel.firstName).addDisposableTo(bag)
        lastNameTextField.rx.text.bind(to: viewModel.lastName).addDisposableTo(bag)
        bioTextField.rx.textInput.text.bind(to: viewModel.bio).addDisposableTo(bag)
        
        viewModel.profilePictures.asObservable().do(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).subscribe().addDisposableTo(bag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        calculateOffset()
        moveViewUp()
    }
    
    fileprivate func moveViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = self.offSet
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func moveViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = 0
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func prepareCollectionView() {
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func calculateOffset() {
        let screenHeight = self.view.frame.size.height
        let bioY = screenHeight - bioTextField.y
        let keyboardShift = keyboardHeight - bioY
        let extraShift = CGFloat(10) + bioTextField.frame.size.height
        
        offSet = extraShift + keyboardShift
    }
    
    fileprivate func prepareNavigationButtons() {
        cancelButton = UIBarButtonItem()
        cancelButton.image = Icon.cm.close
        cancelButton.tintColor = UIColor.moonRed
        self.navigationItem.leftBarButtonItem = cancelButton
        
        saveButton = UIBarButtonItem()
        saveButton.image = Icon.cm.check
        saveButton.tintColor = UIColor.moonGreen
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func prepareFirstNameTextField() {
        firstNameTextField.delegate = self
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.isClearIconButtonEnabled = true
        firstNameTextField.dividerActiveColor = .moonBlue
        firstNameTextField.dividerNormalColor = .moonBlue
        firstNameTextField.placeholderActiveColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        firstNameTextField.leftView = leftView
        firstNameTextField.leftViewActiveColor = .moonBlue
    }
    
    fileprivate func prepareLastNameTextField() {
        lastNameTextField.delegate = self
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.isClearIconButtonEnabled = true
        lastNameTextField.dividerActiveColor = .moonBlue
        lastNameTextField.dividerNormalColor = .moonBlue
        lastNameTextField.placeholderActiveColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        lastNameTextField.leftView = leftView
        lastNameTextField.leftViewActiveColor = .moonBlue
    }
    
    fileprivate func prepareBioTextField() {
        bioTextField.delegate = self
        bioTextField.placeholder = "Bio"
        bioTextField.isClearIconButtonEnabled = true
        bioTextField.dividerActiveColor = .moonPurple
        bioTextField.dividerNormalColor = .moonPurple
        bioTextField.placeholderActiveColor = .moonPurple
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.edit
        bioTextField.leftView = leftView
        bioTextField.leftViewActiveColor = .moonPurple
    }
    
    fileprivate func prepareScrollView() {
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
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
    
    // MARK: FUSUMA DELEGATES for image cropping
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        //let i  = image.crop(toWidth: 200, toHeight: 200) // circle image
        viewModel.profilePictures.value[index.item] = image
        collectionView.reloadData()
        
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

// TextField Delegate Functions
extension EditProfileViewController {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bioTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        self.moveViewDown()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}

// RAReorderableLayout delegate datasource
extension EditProfileViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        
        return CGSize(width: threePiecesWidth, height: threePiecesWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 2.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? RACollectionViewCell)!
        cell.imageView.image = viewModel.profilePictures.value[(indexPath as NSIndexPath).item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as? RACollectionViewCell
        if cell?.imageView.image == #imageLiteral(resourceName: "AddMorePicsIcon") {
            return false
        }
        if collectionView.numberOfItems(inSection: (indexPath as NSIndexPath).section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, willMoveTo toIndexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = (collectionView.cellForItem(at: indexPath) as? RACollectionViewCell)!
        self.index = indexPath as NSIndexPath
        self.prepareFusuma()
        present(fusuma, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var photo: UIImage
 
        photo = viewModel.profilePictures.value.remove(at: (atIndexPath as NSIndexPath).item)
        viewModel.profilePictures.value.insert(photo, at: (toIndexPath as NSIndexPath).item)
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, canMoveTo: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: canMoveTo) as? RACollectionViewCell
        if cell?.imageView.image == #imageLiteral(resourceName: "AddMorePicsIcon") {
            return false
        }
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
            return 0.3
    }
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.contentInset.top, left: 0, bottom: collectionView.contentInset.bottom, right: 0)
    }
}
