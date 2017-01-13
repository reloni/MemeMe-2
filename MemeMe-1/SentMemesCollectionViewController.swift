//
//  SentMemesCollectionViewController.swift
//  MemeMe-2
//
//  Created by Anton Efimenko on 13.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit

final class SentMemesCollectionViewController : UIViewController {
	@IBOutlet weak var collection: UICollectionView!
	
}

extension SentMemesCollectionViewController : UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appDelegate.memes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collection.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath)
		//let meme = appDelegate.memes[indexPath.row]
		//cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
		//cell.imageView?.image = meme.memedImage
		return cell
	}
}

extension SentMemesCollectionViewController : UICollectionViewDelegate {
	
}
