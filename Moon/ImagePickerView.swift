//
//  ImagePickerView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/20/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerView: UIImageView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    fileprivate let imagePicker = UIImagePickerController()
    var viewController: UIViewController!
    
    func makeWith() {
        imagePicker.delegate = self
    }
    
    func imageTouched() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentMode = .scaleAspectFill
            self.image = pickedImage
            print("Image Set")
        } else {
            print("Something went wrong")
        }
        
       viewController.dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

