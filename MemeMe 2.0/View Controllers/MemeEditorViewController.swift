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

    
    let pickerData = ["HelveticaNeue-CondensedBlack", "HelveticaNeue-Bold", "MyanmarSangamMN-Bold", "Noteworthy-Bold", "MarkerFelt-Wide", "SnellRoundhand", "Chalkduster"]
    let fontData = ["Helvetica Neue 1", "Helvetica Neue 2", "Myanmar Sangam", "Noteworthy", "Markerfelt", "Snell Roundhand", "Chalk Duster"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.isHidden = true
        
        // Share button only enabled if image is present (ternary operator)
        shareButton.isEnabled = imageView.image == nil ? false : true
        
        configureTextField(topTextField, text: "TOP", font: pickerData[0])
        configureTextField(bottomTextField, text: "BOTTOM", font: pickerData[0])
        

        // - Check to see if the device has a camera available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // - Set VC as delegate for pickerview and declare font data arrays
        self.picker.delegate = self
        self.picker.dataSource = self
        
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
        configureTextField(topTextField, text: "TOP", font: pickerData[row])
        configureTextField(bottomTextField, text: "BOTTOM", font: pickerData[row])
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
        return textField.resignFirstResponder()
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
        pickAnImage(.photoLibrary)
//        imagePicker.allowsEditing = true
    }

    //MARK: - Open camera
    
    @IBAction func newImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)
    }
    
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
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
        configureTextField(topTextField, text: "TOP", font: pickerData[0])
        configureTextField(bottomTextField, text: "BOTTOM", font: pickerData[0])
        imageView.image = nil
    }

    
    func configureTextField(_ textField: UITextField, text: String, font: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = [
            .font: UIFont(name: font, size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -4.0,
            ]
        textField.textAlignment = .center
    }
    
    @IBAction func fontSelection(_ sender: UIPickerView) {
        picker.isHidden = false
        picker.backgroundColor = UIColor.white
    }

}

