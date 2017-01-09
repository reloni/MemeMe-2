//
//  Extensions.swift
//  MemeMe-1
//
//  Created by Anton Efimenko on 07.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension Notification {
	func keyboardHeight() -> CGFloat {
		return (userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
	}
}

extension UIViewController {
    func configureTextField(_ textField: UITextField, defaultTextAttributes: [String: Any] = [:], delegate: UITextFieldDelegate? = nil) {
        textField.defaultTextAttributes = defaultTextAttributes
        textField.textAlignment = .center
        textField.delegate = delegate
    }
    
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
	}
	
	func presentImagePicker(for sourceType: UIImagePickerControllerSourceType,
	                        delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? = nil) {
		let pickerController = UIImagePickerController()
		pickerController.allowsEditing = false
		pickerController.delegate = delegate
		pickerController.sourceType = sourceType
		present(pickerController, animated: true, completion: nil)
	}
	
	func presentActivities(with items: [Any], sourceView: UIView, completion: UIActivityViewControllerCompletionWithItemsHandler? = nil) {
		let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
		activityController.excludedActivityTypes = [UIActivityType.assignToContact,
		                                            UIActivityType.openInIBooks,
		                                            UIActivityType.postToVimeo,
		                                            UIActivityType.postToWeibo,
		                                            UIActivityType.copyToPasteboard]
		activityController.completionWithItemsHandler = completion
		activityController.popoverPresentationController?.sourceView = sourceView
		present(activityController, animated: true, completion: nil)
	}
	
	func saveMeme(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
		let _ = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage)
	}
}

extension MemeViewController {
	func reset() {
		topTextField.text = "TOP"
		bottomTextField.text = "BOTTOM"
		imageView.image = nil
		shareButton.isEnabled = false
	}
	
	func generateMemeImage() -> UIImage {
		topToolBar.isHidden = true
		bottomToolBar.isHidden = true
		
		UIGraphicsBeginImageContext(view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		
		topToolBar.isHidden = false
		bottomToolBar.isHidden = false
		
		return memedImage
	}
}

func requestPhotosAccess(completion: @escaping (Bool) -> ()) {
	PHPhotoLibrary.requestAuthorization { result in
		switch result {
		case .authorized: DispatchQueue.main.async { completion(true) }
		default: DispatchQueue.main.async { completion(false) }
		}
	}
}

func requestCameraAccess(completion: @escaping (Bool) -> ()) {
	AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { result in
		DispatchQueue.main.async { completion(result) }
	}
}
