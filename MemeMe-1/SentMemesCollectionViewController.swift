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
	
	let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
	let itemsPerRow: CGFloat = 3
	
	override func viewWillAppear(_ animated: Bool) {
		collection.reloadSections(IndexSet(integer: 0))
	}
	
	@IBAction func newMeme(_ sender: Any) {
		presentMemeEditController()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if (isViewLoaded && view.window != nil) {
			coordinator.animate(alongsideTransition: { _ in self.collection.reloadSections(IndexSet(integer: 0)) }, completion: nil)
		}
	}
}

extension SentMemesCollectionViewController : UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appDelegate.memes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collection.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionCell
		let meme = appDelegate.memes[indexPath.row]
		cell.memeImage.image = meme.memedImage
		cell.backgroundColor = UIColor.black
		return cell
	}
}

extension SentMemesCollectionViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let meme = appDelegate.memes[indexPath.row]
		presentMemeDetailsController(withMeme: meme)
	}
}

extension SentMemesCollectionViewController : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
}
