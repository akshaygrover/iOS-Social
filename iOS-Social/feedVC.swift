//
//  feedVC.swift
//  iOS-Social
//
//  Created by akshay Grover on 2017-07-07.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class feedVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addImage: customImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var captionField: customField!
    var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            // print(snapshot.value!)
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                  //  print("snap: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postkey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
      //  print("post caption: \(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell{
            
            if let img = feedVC.imageCache.object(forKey: post.imageUrl as NSString ){
                cell.configureCell(post: post, img: img)
                
            }else{
                cell.configureCell(post: post)
                
            }
            return cell
            
        } else{
            return PostCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
            
        }else{
            print("valid image is not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImageClicked(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonClicked(_ sender: customButton) {
        
        guard let caption = captionField.text, caption != "" else{
            print("caption must be entered")
            return
        }
        guard let image = addImage.image, imageSelected == true  else {
            print("An image must be selected")
            return
        }
        
        if let imgData =  UIImageJPEGRepresentation(image, 0.2){
            
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData){ (metaData, error) in
                if error != nil{
                    print("unable to upload image to firebase")
                }else{
                    print("image uploaded to firebase successfully")
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    if let finalUrl = downloadUrl{
                        self.postToFirebase(imgUrl: finalUrl)
                    }
                    
                }
            }
        }
    }
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, AnyObject> = [
            "caption" : captionField.text! as AnyObject,
            "imageUrl" : imgUrl as AnyObject,
            "likes" : 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func signOutBtnClicked(_ sender: UIButton) {
        
        let keychainRemoveResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("keychain removed - \(keychainRemoveResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
        
    }
    
}
