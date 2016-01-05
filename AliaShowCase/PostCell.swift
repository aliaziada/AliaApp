//
//  PostCell.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 1/4/16.
//  Copyright © 2016 Ntime. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descTxt: UITextView!
    
    var post: Post!
    
    var request: Request?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }

}
