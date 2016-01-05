//
//  PostCell.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/4/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descTxt: UITextView!
    
    
    var post: Post!
    
    var request: Request?
    
    var likeRef : Firebase!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.bounds.width / 2
        profileImg.clipsToBounds = true
        
        showCaseImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (post: Post,img: UIImage?){
        self.post = post
        likeRef = DataService.ds.REF_CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        likesLbl.text = "\(post.likes)"
        //usernameLbl.text = post.username
        descTxt.text = post.postDescription
        
        if post.imgUrl != nil {
            if img != nil {
                self.showCaseImg.image = img
            }else{
                Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"]).response(completionHandler: {resquest, response,data,err in
                    if err == nil {
                        let image = UIImage(data: data!)!
                        FeedVC.imageCache.setObject(image, forKey: self.post.imgUrl!)
                        self.showCaseImg.hidden = false
                        self.showCaseImg.image = image
                    }
                })
            }
        }else{
            self.showCaseImg.hidden = true
        }
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-empty")
            }else{
                self.likeImg.image = UIImage(named: "heart-full")
            }
        
        })
    }
    func likeTapped (sender: UIGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            }else{
                self.likeImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
            
        })
    }
}
