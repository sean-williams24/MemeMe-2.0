//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by Sean Williams on 18/06/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import Foundation

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //Grab the saved memes from the array in the appdelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell")!
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + meme.bottomText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
//        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
//        navigationController!.pushViewController(detailController, animated: true)
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
        
    }
    


}
