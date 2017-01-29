//
//  memeView.swift
//  memeMeV2
//
//  Created by Jean-Marc Kampol Mieville on 12/11/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation
import UIKit

class memeView: UIViewController {
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    var meme: Meme!
    
    var activeRow = -1
    
    
    @IBAction func editMeme(_ sender: Any) {
        openEditor()
        //self.dismiss(animated: true, completion: nil)
        print("editBtn pressed")

    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
           print("doneBtn pressed")
    }
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        memeImage.image = memes[activeRow].memedImage
        reloadInputViews()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //memeImage.image = memeImage.image
        //memeImage.image = memes[activeRow].memedImage
        navigationItem.title = "MemeMe Gallery"
        //navigationItem.backBarButtonItem =
        
    }
    
    
    func openEditor(){
        print("This is the activeRow:\(activeRow)")

        
        var controller: MemeMeViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeMeViewController") as! MemeMeViewController
        controller.meme = self.meme
        controller.activeRow = self.activeRow
        
        // Present the view Controller
        present(controller, animated: true, completion: nil)
        controller.navigationItem.hidesBackButton = true

 

    }
    
}
