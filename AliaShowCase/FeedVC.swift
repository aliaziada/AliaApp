//
//  FeedVC.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/4/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        tableView.estimatedRowHeight = 346
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary <String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            cell.request?.cancel()
            let post = posts[indexPath.row]
            var img : UIImage?
            if let url = post.imgUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            cell.configureCell(post, img: img)
            return cell
        }else{
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  posts[indexPath.row].imgUrl == nil {
            return 180
        }else{
            return tableView.estimatedRowHeight
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelectorImage.tag = 1
    }
    
    @IBAction func selectImageTapped(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func makePostTapped(sender: AnyObject) {
        if let postTxt = postField.text where postTxt != "" {
            if let img = imageSelectorImage.image where imageSelectorImage.tag == 1 {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imageData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "234BLNTY030fc245b7485f84d77388dadf16f783".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    }) { encodingResult in
                        switch encodingResult {
                        case .Success(let upload , _ , _):
                            upload.responseJSON(completionHandler: { response in
                                if let info = response.result.value as? Dictionary<String,AnyObject> {
                                    if let links = info["links"] as? Dictionary<String,AnyObject> {
                                        if let imageLink = links["image_link"] as? String {
                                            self.postToFirebase(imageLink)
                                        }
                                    }
                                }
                            })
                        case .Failure(let err):
                            print(err)
                        }
                }
            }else{
                postToFirebase(nil)
            }
        }
    }
    func postToFirebase(imgUrl: String?){
        var post : Dictionary<String,AnyObject> = [
            "description":postField.text!,
            "likes":0
        ]
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        postField.text = ""
        imageSelectorImage.tag = 0
        imageSelectorImage.image = UIImage(named: "camera")
        tableView.reloadData()
    }
}
