//
//  Meme.swift
//  MemeMe 2.0
//
//  Created by Sean Williams on 04/06/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation
import UIKit


extension MemeEditorViewController {

    
//MARK: - Genrate meme from view

func generateMemedImage() -> UIImage {
    self.navigationController?.navigationBar.isHidden = true
    self.toolbar.isHidden = true
    
    //Render view to image
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    self.navigationController?.navigationBar.isHidden = false
    self.toolbar.isHidden = false
    return memedImage
}

//MARK: - Initialize meme object

func saveMeme() {
    //Create the meme
    let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    
    //Add meme to Memes array in the app delegate
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
}

}
