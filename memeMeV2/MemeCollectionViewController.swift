//
//  MemeCollectionViewController.swift
//  memeMeV2
//
//  Created by Jean-Marc Kampol Mieville on 12/5/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    
    // active row from didSelectRow
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    //var memes: [Meme]!
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    var meme: Meme!
    var activeRow = -1
    // change FlowLayout
    func prepareFlowLayout() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        //memes = applicationDelegate.memes
        prepareFlowLayout()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
        
        prepareFlowLayout()
        
    }

    // count the meme in the collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    // -> display meme into the collection
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeView" {
            let memeV = segue.destination as! memeView
            let meme = memes[activeRow]
            let imageView = UIImageView(image: meme.memedImage)
            memeV.memeImage = imageView
            memeV.activeRow = activeRow
            print("A) Testing \(activeRow)")
            // hide buttom bar when showing memeView
            memeV.hidesBottomBarWhenPushed = true
        }
    }

    // display meme in full size when clicked in another page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reloadInputViews()
        activeRow = indexPath.row
        let controller = storyboard?.instantiateViewController(withIdentifier: "memeView") as! memeView
        controller.meme = memes[indexPath.row]
        controller.activeRow = activeRow
        navigationController?.pushViewController(controller, animated: true)
        print("B) Testing \(activeRow)")
        print("B) Testing Indexpath.row \(indexPath.row)")
    }
}
