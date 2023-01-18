//
//  File.swift
//  MemeMe
//
//  Created by Deer on 22/10/1441 AH.
//  Copyright © 1441 Udacety. All rights reserved.
//

import UIKit

class MemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView!.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addMeme(_ sender: Any) {
        let editMeme = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
        
        self.navigationController!.pushViewController(editMeme, animated: true)
    }
    
    
}
