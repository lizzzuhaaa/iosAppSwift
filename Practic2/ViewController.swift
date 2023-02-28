//
//  ViewController.swift
//  Practic2
//
//  Created by лізушка лізушкіна on 24.02.2023.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var upperLabel: UILabel!
   
    @IBOutlet weak var imageWeb: UIImageView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet private weak var savingButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var background: UIView!
    var reddit: GetInfoReddit = GetInfoReddit(subreddit:"ios", limit: 1)
    
    override func viewDidLoad() {
        setUpPage()
        super.viewDidLoad()
    }
    
    func setUpPage()
    {
        if let saved = reddit.savedReddit{
            if !saved
            {
                self.savingButton.setImage(UIImage(systemName:"bookmark"), for: .normal)
            }
            else
            {
                self.savingButton.setImage(UIImage(systemName:"bookmark.fill"), for: .normal)
            }
        }
        
        if let info = reddit.pageInfo
        {
            self.upperLabel.text = info["UpperLabel"]
            self.titleLable.text = info["Title"]
            self.commentsButton.setTitle(info["Comments"], for: .normal)
            self.likeButton.setTitle(info["Rating"], for: .normal)
        }
        
        if let urlimg = reddit.imageURL
        {
            if let url = URL(string: urlimg) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        self.imageWeb.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
    }
    
    @IBAction func onShareClickBtn(_ sender: Any) {
    }
    
    @IBAction func onCommentClickBtn(_ sender: Any) {
    }
    
    @IBAction func onSaveClickBtn(_ sender: Any) {
        if let saved = reddit.savedReddit{
            if saved
            {
                self.savingButton.setImage(UIImage(systemName:"bookmark"), for: .normal)
                reddit.savedReddit = !saved
            }
            else
            {
                self.savingButton.setImage(UIImage(systemName:"bookmark.fill"), for: .normal)
                reddit.savedReddit = !saved
            }
        }
    }
    
    @IBAction func onLikeClickBtn(_ sender: Any) {
    }
}
