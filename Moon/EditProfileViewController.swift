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

class EditProfileViewController: UIViewController, BindableType, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UIImagePickerControllerDelegate {

    var viewModel: EditProfileViewModel!
    var cancelButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var index: NSIndexPath!
    
    //fake data
    var fakeImages = [#imageLiteral(resourceName: "pp2.jpg"), #imageLiteral(resourceName: "pp1.jpg"), #imageLiteral(resourceName: "pp3.jpg"), #imageLiteral(resourceName: "pp4.jpg"), #imageLiteral(resourceName: "pp5.jpg"), #imageLiteral(resourceName: "p1.jpg")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationButtons()
        prepareCollectionView()
        
        imagePicker.delegate = self
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.onBack()
        saveButton.rx.action = viewModel.onSave()
    }
    
    func prepareCollectionView() {
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func prepareNavigationButtons() {
        cancelButton = UIBarButtonItem()
        cancelButton.image = Icon.cm.close
        cancelButton.tintColor = UIColor.moonRed
        self.navigationItem.leftBarButtonItem = cancelButton
        
        saveButton = UIBarButtonItem()
        saveButton.image = Icon.cm.check
        saveButton.tintColor = UIColor.moonGreen
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
    }
}

extension EditProfileViewController {
    // RAReorderableLayout delegate datasource
    
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
        cell.imageView.image = fakeImages[(indexPath as NSIndexPath).item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
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
        self.imageTouched()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var photo: UIImage

        photo = fakeImages.remove(at: (atIndexPath as NSIndexPath).item)
        fakeImages.insert(photo, at: (toIndexPath as NSIndexPath).item)
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
            return 0.3
    }
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.contentInset.top, left: 0, bottom: collectionView.contentInset.bottom, right: 0)
    }
}

//Image Picker Delegates and Functions
extension EditProfileViewController {
    func imageTouched() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            fakeImages[index].autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            imageView.image.contentMode = .scaleAspectFill
            fakeImages[index.item] = pickedImage
            collectionView.reloadData()
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
