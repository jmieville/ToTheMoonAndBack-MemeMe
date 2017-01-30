//
//  SentMemeTableViewController.swift
//  memeMeV2
//
//  Created by Jean-Marc Kampol Mieville on 12/5/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import Foundation

class SentMemeTableViewController: UITableViewController {
    
    //var memes: [Meme]!
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    var meme: Meme!
    //activeRow for didSelectRow
    var activeRow = -1

    let tableCellIdentifier = "MemeTableViewCell"
    
    var canGoToAddMemeMe: Bool = true

    @IBOutlet var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        


        if let count = memes?.count {
            if count == 0 {
                canGoToAddMemeMe = true
            }
        }
  
    }
    
    
    // go to add memeMe page
    func goToAddMemeMe() {
        if canGoToAddMemeMe {
            canGoToAddMemeMe = false
            performSegue(withIdentifier: "goToAddMemeMe", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goToAddMemeMe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        //let imageView = UIImageView(image: meme.memedImage)
        
        cell.cellImage?.image = meme.memedImage
        cell.cellTitle?.text = "\(meme.top)"
        //cell.cellImage.image = UIImage(named: "block1.png")
        //cell.cellTitle?.text = "Hello"
        cell.cellDetail?.text = "\(meme.bottom)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeView" {
            
            let memeV = segue.destination as! memeView
            let meme = memes[activeRow]
            let imageView = UIImageView(image: meme.memedImage)
            memeV.memeImage = imageView
            memeV.activeRow = activeRow
            print("C) Testing \(activeRow)")

            
            // hide buttom bar when showing memeView
            memeV.hidesBottomBarWhenPushed = true
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
