//
//  ViewController.swift
//  SeinfeldShufflePhone
//
//  Created by Robert Deans on 3/6/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    var seinfeldEpisodes = [Episode]()
    
    var tvImageView: UIImageView!
    var seinfeldButton: UIButton!
    var randomEpisode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
        
        EpisodeData.getEpisodeDataJSON(with: "Seinfeld") { (seinfeldData) in
            guard let seinfeld = seinfeldData["Seinfeld"] as? [String:Any] else { print("trouble unwrapping dictionary (seinfeld)"); return }
            
            guard let episodes = seinfeld["episodes"] as? [[String:Any]] else { print("trouble unwrapping dictionary (episodes)"); return }
            
            for episode in episodes {
                guard let season = episode["Season"] as? Int, let number = episode["Episode"] as? Int, let code = episode["Code"] as? Int, let title = episode["Name"] as? String else { print("trouble unwrapping dictionary (for loop)"); return }
                
                
                let newEpisode = Episode(season: season, episode: number, title: title, code: code)
                
                self.seinfeldEpisodes.append(newEpisode)
                
            }
            self.seinfeldEpisodes.sort {
                return $0.0.seasonEpisode < $0.1.seasonEpisode
            }
            
        }
        
    }
    
    func configure() {
        
        tvImageView = UIImageView()
        tvImageView.image = #imageLiteral(resourceName: "retrotv")
        tvImageView.contentMode = .scaleAspectFit
        
        seinfeldButton = UIButton()
        seinfeldButton.setImage(#imageLiteral(resourceName: "Seinfeld"), for: .normal)
        seinfeldButton.addTarget(self, action: #selector(shuffleEpisodes), for: .touchUpInside)
        seinfeldButton.contentMode = .scaleAspectFit
        
    }
    
    func constrain() {
        
        view.addSubview(tvImageView)
        tvImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalToSuperview().multipliedBy(0.9)
        }
        
        view.addSubview(seinfeldButton)
        seinfeldButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-35)
            $0.centerY.equalToSuperview().offset(-10)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(4)
        }
        
    }
    
    func shuffleEpisodes() {
        let randomIndex = Int(arc4random_uniform(173))
        randomEpisode = seinfeldEpisodes[randomIndex]
        print("Random episode is \(randomEpisode?.title)")
        if let randomEpisode = randomEpisode {
            let urlString = URL(string: randomEpisode.hyperlink)
            
            if let urlunwrapped = urlString {
                UIApplication.shared.open(urlunwrapped, options: [:]) { (didFinish) in
                    if didFinish {
                        print("SUCCESS")
                    } else {
                        
                        print("error...")
                    }
                }
            }
            
        }
    }
    
    func openOutsideApp() {
        print("Open App tapped")
        
        /*
 
         hulu:// brings you to the app but not the episode
         http:// brings you to website (which DOES forward you to the correct episode, but with different link!)
 
         
         let netflix = "nflx://www.netflix.com/watch/70224484"
         let huluWeb = "http://hulu.com/w/OKGJ"
         
         
        */
        
        let hulu = "hulu://w/807443"
        
        /*
            FOR WHATEVER REASON, MR. URL(fileURLWithPath) DOESNT WORK BUT MRS URLSTRING IS A FUCKING CHAMP!!!
        */
        
        let urlString = URL(string: hulu)

        print("CanOpenURL = \(UIApplication.shared.canOpenURL(urlString!))")
        
        if let urlunwrapped = urlString {
            UIApplication.shared.open(urlunwrapped, options: [:]) { (didFinish) in
                if didFinish {
                    print("SUCCESS")
                } else {
                    
                    print("error...")
                }
            }
        }
        
        
        
    }
    
    
    
    
}

