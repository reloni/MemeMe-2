//
//  MemeDetailsController.swift
//  MemeMe-2
//
//  Created by Anton Efimenko on 14.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit

final class MemeDetailsController : UIViewController {
	@IBOutlet weak var imageView: UIImageView!

	var meme: Meme!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = meme.memedImage
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
	}
	
	func editMeme() {
		presentMemeEditController(withMeme: meme)
		_ = navigationController?.popViewController(animated: false)
	}
}
