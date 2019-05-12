//
//  SentMemesCollectionCollectionViewController.swift
//  MemeMe
//
//  Created by David Lang on 5/5/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit


class SentMemesCollectionVC: UICollectionViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let cellIdentifier = "MemeCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.navigationItem.title = "Sent Memes"
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        // Configure the cell
        let meme = memes[indexPath.row]
        cell.memedImageView.contentMode = .scaleAspectFit
        cell.memedImageView.image = meme.memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
        
        return true
    }
    

}
