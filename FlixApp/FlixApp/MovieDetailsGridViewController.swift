//
//  MovieDetailsGridViewController.swift
//  FlixApp
//
//  Created by Tahamid on 3/1/22.
//

import UIKit

class MovieDetailsGridViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    var movie: [String: Any]!
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webView = segue.destination as! WebViewController
        webView.movieID = movie["id"] as! Int
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        posterView.layer.borderColor = UIColor.white.cgColor
        posterView.layer.borderWidth = 2
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        posterView.af.setImage(withURL: posterURL!)
        let backdropPath = movie["backdrop_path"] as! String
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdropView.af.setImage(withURL: backdropURL!)
    }

    
}
