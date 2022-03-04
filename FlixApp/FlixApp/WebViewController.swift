//
//  WebViewController.swift
//  FlixApp
//
//  Created by Tahamid on 3/1/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    var movieID: Int!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let APIURL = "https://api.themoviedb.org/3/movie/" + String(movieID) +  "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print(APIURL)
        let url = URL(string: APIURL)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(dataDictionary)
                    let movie = dataDictionary["results"]  as! [[String : Any]]
                
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                 let youtubeKey = movie[0]["key"] as! String
                 let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeKey)")
                 let request = URLRequest(url: youtubeURL!)
                    
                 self.webView.load(request)
             }
        }
        task.resume()
  
    }

}
