//
//  MemeMeViewController.swift
//  memeMeV2
//
//  Created by Jean-Marc Kampol Mieville on 6/5/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var meme: Meme!
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    let imagePicker = UIImagePickerController()
    
    func prepareTextField(textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            //NSFontAttributeName : UIFont(name: "impact.ttf", size: 35)!,
            NSStrokeWidthAttributeName : -2.0
        ] as [String : Any]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.adjustsFontForContentSizeCategory = true
    }
    
    let sharedApplication = UIApplication.shared.delegate as! AppDelegate
    var memedImage: UIImage?
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    
    @IBOutlet weak var imageToMeme: UIImageView!
    
    // Take image from Album
    @IBAction func pickImageFromAlbum(_ sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Save memedImage
    
    func save() {
        let generatedImage = generateMemedImage()
        if imageToMeme.image != nil {
            let meme = Meme(top: textField1.text!, bottom: textField2.text!, image: imageToMeme.image!, memedImage: generatedImage)
            self.meme = meme
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(self.meme)
            
        } else {
        }
    }
    
    @IBOutlet weak var shareImageBtn: UIBarButtonItem!
    @IBAction func ShareImage(_ sender: Any) {
        
        // set up activity view controller
        let imageToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        // call save() after an action was done in the activity controller

        activityViewController.completionWithItemsHandler = {
            (s: UIActivityType?, ok: Bool, items: [Any]?, err: Error?) -> Void in
            if ok {
                self.save()
            } else {
                activityViewController.dismiss(animated: true, completion: nil )
            }
        }
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage{
        
        // hide toolbar before image generated
        toolbar.isHidden = true
        toolbarBottom.isHidden = true
        
        // generate image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // resurface tool bar after image generated
        toolbar.isHidden = false
        toolbarBottom.isHidden = false
        
        return memedImage
    }
    
    // Set Original image
    //var originalImage: UIImage?
    /*
    func setOriginalImage(pickedImage: UIImage) -> UIImage {
        originalImage = pickedImage
        return originalImage!
    }
    */
    
    // Image from Camera
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    // show the selected image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageToMeme.contentMode = .scaleAspectFit
            imageToMeme.image = pickedImage
            //setOriginalImage(pickedImage: pickedImage)
            shareImageBtn.isEnabled = true
            textField1.isEnabled = true
            textField2.isEnabled = true
            textField1.text = "Input your text here"
            textField2.text = "and here"
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //TextField Top & Bottom
    
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(textField: topTextField)
        prepareTextField(textField: bottomTextField)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)

        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        
        textField1.textAlignment = .center
        textField2.textAlignment = .center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField1.resignFirstResponder()
        textField2.resignFirstResponder()
        
        return true
    }
    
    // To do -> Keyboard moves the View up / down:
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // subscribe to keyboard notification
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // move frame on y axis for keyboard
    
    func keyboardWillShow(_ notification:Notification) {
        if textField2.isEditing == true {
            view.frame.origin.y -= getKeyboardHeight(notification)

        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if textField2.endEditing(true) {
            view.frame.origin.y = view.bounds.origin.y

        }
    }
}
