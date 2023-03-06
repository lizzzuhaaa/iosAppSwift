//
//  PostListViewController.swift
//  Practic2
//
//  Created by лізушка лізушкіна on 03.03.2023.
//

import Foundation
import UIKit

class PostListViewController: UIViewController
{
    var mainReddit: GetInfoReddit = GetInfoReddit(subreddit:"ios", limit: 10, after: "")
    @IBOutlet private weak var subredName: UILabel!
    @IBOutlet private weak var savingFilter: UIButton!
    @IBOutlet private var tableView: UITableView!
    var saved:Bool = false
    
    var allRedditList : [[String:String]] = [[:]]
    var currentReddit: [String:String] = [:]
    var postsLimit:Int = 10
    var isLoad:Bool = false
    var page:Int = 0
    
    
    private var numberOfCells: [Int] = []
    
    struct Const
    {
        static let cellReuseIndendifier = "my_custom_cell"
        static let goToPost = "go_to_post"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let posts = mainReddit.pageInfoList{
            self.allRedditList = posts
            self.mainReddit.parseJSON()
        }
        self.numberOfCells = Array(0..<(self.postsLimit))
        self.tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case Const.goToPost:
            let nextVC = segue.destination as! PostDetailsViewController
            nextVC.redditMake(redditCurrent: self.currentReddit)
        default:
            break
        }
    }
    
    @IBAction func onSavinClick(_ sender: Any) {
        
        if self.saved
        {
            self.savingFilter.setImage(UIImage(systemName:"bookmark"), for: .normal)
            self.saved = false
        }
        else
        {
            self.savingFilter.setImage(UIImage(systemName:"bookmark.fill"), for: .normal)
            self.saved = true
        }
    }
    
    func upLoad()
    {
        if !isLoad {
            isLoad = true
            self.mainReddit.parseJSON()
            if let nextPage = mainReddit.pageInfoList
            {
                self.allRedditList += nextPage
                self.mainReddit.pageInfoList = nil
                self.postsLimit+=10
                self.numberOfCells=Array(0..<self.postsLimit)
                self.tableView.reloadData()
            }
            self.isLoad = false
            
        }
    }
}

extension PostListViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIndendifier, for: indexPath) as! MyCustomCell
        self.page = indexPath.row
        if allRedditList != [[:]]
        {
            let particularPost = allRedditList[self.page]
            cell.config(reddit: particularPost)
        }
        return cell
    }
}

extension PostListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allRedditList != [[:]]
        {
            self.currentReddit = allRedditList[indexPath.row]
            self.performSegue(withIdentifier: Const.goToPost, sender: nil)
        }
    }
}

extension PostListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height
        {
            if ((self.page + 1) % 10 == 0)
            {
                self.upLoad()
            }
        }
    }
}
