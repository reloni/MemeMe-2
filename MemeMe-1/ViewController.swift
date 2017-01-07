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
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func chooseAlbumImage(_ sender: Any) {
		requestPhotosAccess { isGranted in
			guard isGranted else {
				self.showErrorAlert(message: "Photos permission denied. Go to setting to allow access")
				return
			}

			self.presentImagePicker(for: .photoLibrary)
		}
	}
	
	@IBAction func shootNewImage(_ sender: Any) {
		requestCameraAccess { isGranted in
			guard isGranted else {
				self.showErrorAlert(message: "Camera permission denied. Go to setting to allow access")
				return
			}
			
			self.presentImagePicker(for: .camera)
		}
	}
	
	
	func presentImagePicker(for sourceType: UIImagePickerControllerSourceType) {
		let pickerController = UIImagePickerController()
		pickerController.allowsEditing = false
		pickerController.delegate = self
		pickerController.sourceType = sourceType
		self.present(pickerController, animated: true, completion: nil)
	}
	
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
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
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		
		imageView.image = image
	}
}
