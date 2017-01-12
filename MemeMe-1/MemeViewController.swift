//
//  MemeViewController.swift
//  MemeMe-1
//
//  Created by Anton Efimenko on 07.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class MemeViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var topToolBar: UIToolbar!
	@IBOutlet weak var bottomToolBar: UIToolbar!
	
	var editingTextField: UITextField?
	
	var editMeme: Meme? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		let memeTextAttributes:[String:Any] = [
			NSStrokeColorAttributeName: UIColor.black,
			NSForegroundColorAttributeName: UIColor.white,
			NSFontAttributeName: UIFont(name: "Impact", size: 44)!,
			NSStrokeWidthAttributeName: -4.0]
        
			configureTextField(topTextField, defaultTextAttributes: memeTextAttributes, delegate: self)
			configureTextField(bottomTextField, defaultTextAttributes: memeTextAttributes, delegate: self)
		
		if let editMeme = editMeme {
			topTextField.text = editMeme.topText
			bottomTextField.text = editMeme.bottomText
			imageView.image = editMeme.originalImage
			shareButton.isEnabled = true
		}
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
		let activityImage = generateMemeImage()
		
		presentActivities(with: [activityImage], sourceView: self.view) { result in
			if result.1 {
				self.saveMeme(topText: self.topTextField.text ?? "",
				         bottomText: self.bottomTextField.text ?? "",
				         originalImage: self.imageView.image!,
				         memedImage: activityImage)
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func cancel(_ sender: Any) {
		if appDelegate.memes.count == 0 {
			reset()
		} else {
			dismiss(animated: true, completion: nil)
		}
	}
}

extension MemeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		
		imageView.image = image
		
		shareButton.isEnabled = true
	}
}

extension MemeViewController : UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		editingTextField = textField
		return true
	}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.text == "TOP" || textField.text == "BOTTOM" {
			textField.text = ""
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		editingTextField = nil
		if textField.text?.characters.count == 0 {
			if textField.tag == 1 {
				textField.text = "TOP"
			} else if textField.tag == 2 {
				textField.text = "BOTTOM"
			}
		}
	}
}
