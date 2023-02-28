//
//  GetInfoReddit.swift
//  Practic2
//
//  Created by лізушка лізушкіна on 24.02.2023.
//

import Foundation
public class GetInfoReddit: Codable
{
    var subreddit: String
    var limit: Int
    var savedReddit :Bool?
    var imageURL : String?
    var pageInfo: [String:String]?
    //var after
    
    init(subreddit: String, limit: Int)
    {
        self.subreddit = subreddit
        self.limit = limit
        parseJSON()
        makeSaving()
    }
    
    private func makeSaving ()
    {
        self.savedReddit = true
    }
    
    private func timeElapsed(createdDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let currentTime = Date()
        let timeElapsed = currentTime.timeIntervalSince(createdDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        let formattedString = formatter.string(from: timeElapsed)!
        return formattedString
    }
    
    private func parseJSON()
    {
        var info: [String:String] = [:]
        guard let url = URL(string:"https://www.reddit.com/r/"+self.subreddit+"/top.json?limit="+String(self.limit))
        else
        {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else
            {
                print("Invalid JSON")
                return
            }
            if let data = json["data"] as? [String:Any],
               let children = data["children"] as? [[String:Any]],
               let firstChild = children.first,
               let childData = firstChild["data"] as? [String:Any],
               let domain = childData["domain"] as? String,
               let authorFullName = childData["author_fullname"] as? String,
               let title = childData["title"] as? String,
               let ups = childData["ups"] as? Int,
               let downs = childData["downs"] as? Int,
               let commentsNum = childData["num_comments"] as? Int,
               let createdUTC = childData["created_utc"] as? Double
            {
                let createdDate = Date(timeIntervalSince1970: createdUTC)
                let time = self.timeElapsed(createdDate: createdDate)
                let rating = ups+downs
                info["UpperLabel"] = authorFullName + " • " + time + " • " + domain
                info["Title"]=title
                info["Rating"] = String(rating)
                info["Comments"] = String(commentsNum)
                self.pageInfo=info
                if let image = childData["url_overridden_by_dest"] as? String{
                    self.imageURL = image
                }
            }
            else {
                print("Error: Could not extract values")
                return
            }
            
        }
        task.resume()
    }
    
}
