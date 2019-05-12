//
//  ViewController.swift
//  MemeMe
//
//  Created by David Lang on 4/26/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Outlet properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var mediaToolbar: UIToolbar!
    @IBOutlet weak var actionToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: - Nonoutlet properties
    let memeDelegate = MemeTextFieldDelegate()
    
    let memeTextAttributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    //var memedImage:UIImage = UIImage()
    var originalImage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfield(field: topTextField)
        configureTextfield(field: bottomTextField)
    }
    
    /// Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        actionButton.isEnabled = (imageView.image != nil)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func openMediaFromAlbum(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func openMediaFromCamera(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareMemeController = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        
        /* Based on replies from
          https://stackoverflow.com/questions/27454467/uiactivityviewcontroller-uiactivityviewcontrollercompletionwithitemshandler
         -see Hardik Thakkar and Joel Márquez replies
         */
        
        shareMemeController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, items: [Any]?, error: Error?) in
            if completed {
                self.saveMeme(memedImage: memedImage)
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(shareMemeController, animated: true, completion: nil)

    }
    
    /// Reset steps for a new attempt
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        actionButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            actionButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Keyboard functions and notification un/subscriptions
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return CGFloat(keyboardFrame.cgRectValue.height)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Textfield Configuration
    /// UITextField configuration
    ///
    /// - Parameter field: UITextField to be configured
    func configureTextfield(field: UITextField) {
        field.delegate = memeDelegate
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .center
        field.borderStyle = .none
        field.adjustsFontSizeToFitWidth = true
    }
    
    /// Create the meme and save the the savedMeme property
    func saveMeme(memedImage: UIImage) {
    
        if let topText = topTextField.text,
            let bottomText = bottomTextField.text,
            let originalImage = imageView.image {
                let meme = Meme(topTextField: topText, bottomTextField: bottomText, originalImage: originalImage, memedImage: memedImage)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)
        }
        
    }
    
    func generateMemedImage() -> UIImage {
        
        actionToolbar.isHidden = true
        mediaToolbar.isHidden = true
        
        // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        actionToolbar.isHidden = false
        mediaToolbar.isHidden = false
        
        return memedImage
    }
    
    
}

