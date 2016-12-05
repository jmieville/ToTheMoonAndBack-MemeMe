//
//  Meme.swift
//  memeMeV2
//
//  Created by Jean-Marc Kampol Mieville on 6/6/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var top = "TOP"
    var bottom = "BOTTOM"
    var image: UIImage!
    // memedImage with Image & Text
    var memedImage: UIImage!
    
    
    // initialize for ViewController
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
        
        
    }
}

