//
//  SentMemesTableViewController.swift
//  MemeMe-2
//
//  Created by Anton Efimenko on 12.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit

final class SentMemesTableViewController: UIViewController {
	@IBOutlet weak var table: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		table.reloadSections(IndexSet(integer: 0), with: .fade)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		if appDelegate.memes.count == 0 {
			presentMemeController()
		}
	}
	
	@IBAction func newMeme(_ sender: Any) {
		presentMemeController()
	}
	
}

extension SentMemesTableViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appDelegate.memes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
		let meme = appDelegate.memes[indexPath.row]
		cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
		cell.imageView?.image = meme.memedImage
		return cell
	}
}

extension SentMemesTableViewController : UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let meme = appDelegate.memes[indexPath.row]
		presentMemeController(withMeme: meme)
	}
}
