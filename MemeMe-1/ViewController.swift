//
//  ViewController.swift
//  MemeMe-1
//
//  Created by Anton Efimenko on 07.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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
			let pickerController = UIImagePickerController()
			pickerController.allowsEditing = false
			pickerController.delegate = self
			self.present(pickerController, animated: true, completion: nil)
		}
		
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
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		
		imageView.image = image
	}
}
