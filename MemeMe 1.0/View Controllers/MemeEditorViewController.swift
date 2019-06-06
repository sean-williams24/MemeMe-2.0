//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Sean Williams on 30/05/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var fontButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!

    
    var pickerData: [String] = [String]()
    var fontData: [String] = [String]()
    var font: String = "HelveticaNeue-CondensedBlack"
    
    struct Meme {
        var topText: String
        var bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.isHidden = true
        
        if imageView.image == nil {
            shareButton.isEnabled = false
            } else {
            shareButton.isEnabled = true
        }
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        resetScreen()

        // - Check to see if the device has a camera available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        navigationController?.hidesBarsOnTap = true
        
        // - Set VC as delegate for pickerview and declare font data arrays
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["HelveticaNeue-CondensedBlack", "HelveticaNeue-Bold", "MyanmarSangamMN-Bold", "Noteworthy-Bold", "MarkerFelt-Wide", "SnellRoundhand", "Chalkduster"]
        fontData = ["Helvetica Neue 1", "Helvetica Neue 2", "Myanmar Sangam", "Noteworthy", "Markerfelt", "Snell Roundhand", "Chalk Duster"]
    }
    
    
    //MARK: - Pickerview setup
    // - Set number of columns and rows and connect font data
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        font = pickerData[row]
        formatFont(font: font)
        picker.isHidden = true
    }
    
    
    
    // Subscribe and unsubscribe from keyboard notifications
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: - Textfield functions
    // - Clear default text from both text fields when tapped and hide keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && topTextField.text == "TOP" {
            topTextField.text = ""
        } else if textField == bottomTextField && bottomTextField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Image selection functions
    
    // - Grab image from storage and assign to imageview - add .originalimage to grab the original image selected

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Pick image from photo album
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }

    
    //MARK: - Open camera
    
    @IBAction func newImageFromCamera(_ sender: Any) {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        present(cameraPicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    
    //MARK: - Share meme function
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
        // Send meme to activity controller
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success) {
                self.saveMeme()
                }
            }
        }
    
    
    //MARK: - Reset screen
    
    @IBAction func cancelButton(_ sender: Any) {
        resetScreen()
    }
    
    func resetScreen() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        formatFont(font: "HelveticaNeue-CondensedBlack")
        imageView.image = nil
    }
    
    
    //MARK: - Format font
    
    func formatFont(font: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: font, size: 40)!,
            NSAttributedString.Key.strokeWidth: -2,
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    @IBAction func fontSelection(_ sender: UIPickerView) {
        picker.isHidden = false
        picker.backgroundColor = UIColor.white
    }

}

