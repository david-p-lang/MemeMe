//
//  DetailViewController.swift
//  MemeMe
//
//  Created by David Lang on 5/6/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            imageView.image = meme.memedImage

        }
    }
    

}
