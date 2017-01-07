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
		//let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		//return keyboardSize.cgRectValue.height
		return (userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
	}
}

extension UIViewController {
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
	}
	
	func presentImagePicker(for sourceType: UIImagePickerControllerSourceType) {
		let pickerController = UIImagePickerController()
		pickerController.allowsEditing = false
		pickerController.delegate = self as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
		pickerController.sourceType = sourceType
		present(pickerController, animated: true, completion: nil)
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
