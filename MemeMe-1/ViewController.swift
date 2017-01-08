//
//  ViewController.swift
//  MemeMe-1
//
//  Created by Anton Efimenko on 07.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var topToolBar: UIToolbar!
	@IBOutlet weak var bottomToolBar: UIToolbar!
	
	var editingTextField: UITextField?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		let memeTextAttributes:[String:Any] = [
			NSStrokeColorAttributeName: UIColor.black,
			NSForegroundColorAttributeName: UIColor.white,
			NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 44)!,
			NSStrokeWidthAttributeName: -4.0]
		
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.textAlignment = .center
		topTextField.delegate = self
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
		bottomTextField.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWillShow(_ notification: Notification) {
		guard let textField = editingTextField else { return }

		let fieldYPosition = view.frame.height - (textField.frame.origin.y + textField.frame.height)
		let keyboardHeight = notification.keyboardHeight()
		
		// adjust frame only if keyboard hides text field
		guard keyboardHeight > fieldYPosition else {
			return
		}
		
		UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
			self.view.frame.origin.y = fieldYPosition - keyboardHeight
		})
	}
	
	func keyboardWillHide(_ notification: Notification) {
		UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
			self.view.frame.origin.y = 0
		})
	}

	@IBAction func chooseAlbumImage(_ sender: Any) {
		requestPhotosAccess { isGranted in
			guard isGranted else {
				self.showErrorAlert(message: "Photos permission denied. Go to setting to allow access")
				return
			}

			self.presentImagePicker(for: .photoLibrary, delegate: self)
		}
	}
	
	@IBAction func shootNewImage(_ sender: Any) {
		requestCameraAccess { isGranted in
			guard isGranted else {
				self.showErrorAlert(message: "Camera permission denied. Go to setting to allow access")
				return
			}
			
			self.presentImagePicker(for: .camera, delegate: self)
		}
	}
	
	@IBAction func share(_ sender: Any) {
		presentActivities(with: [generateMemeImage()]) { result in
			if result.1 {
				self.reset()
			}
		}
	}
	
	@IBAction func cancel(_ sender: Any) {
		reset()
	}
	
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

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		
		imageView.image = image
		
		shareButton.isEnabled = true
	}
}

extension ViewController : UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		editingTextField = textField
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.text == "TOP" || textField.text == "BOTTOM" {
			textField.text = ""
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		editingTextField = nil
		textField.resignFirstResponder()
		return true
	}
}
