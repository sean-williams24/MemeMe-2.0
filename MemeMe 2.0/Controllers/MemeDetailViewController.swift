//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Sean Williams on 19/06/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Properties
    
    var meme: Meme!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = meme.memedImage
        tabBarController?.tabBar.isHidden = true
    }
}
