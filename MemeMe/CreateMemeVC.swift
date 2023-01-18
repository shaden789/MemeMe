//
//  ViewController.swift
//  MemeMe
//
//  Created by Deer on 05/10/1441 AH.
//  Copyright © 1441 Udacety. All rights reserved.
//

import UIKit

class CreateMemeVC:  UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(textField: topText, defaultText:"TOP")
        prepareTextField(textField: bottom, defaultText:"BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        share.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.photoLibrary)
        share.isEnabled = true
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.camera)
        share.isEnabled = true
    }
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3
    ]
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.delegate = self
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if topText.text=="TOP" && textField == topText {
            topText.text=""
        }
        if bottom.text=="BOTTOM" && textField == bottom {
            bottom.text=""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottom.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y=0
    }
    
    
    func hideToolbars(_ hide: Bool){
        navbar.isHidden = hide
        toolbar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        
        let meme = Meme(topText: topText.text!, bottomText: bottom.text!, orginalImage: imageView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        
        let memed = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memed], applicationActivities: nil)
        self.present(controller, animated: true, completion:nil )
        
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success) {
                self.save()
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        share.isEnabled = false
        imageView.image = nil
        topText.text = "TOP"
        bottom.text = "BOTTOM"
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}//class
