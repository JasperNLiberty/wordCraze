//
//  ViewController.swift
//  wordCraze
//
//  Created by Li Zhang on 2/4/18.
//  Copyright © 2018 Li Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appId = "e28c1363"
        let appKey = "1b7bf2d9b08c9a6de6f1041bd2131cfe"
        let language = "en"
        let word = "serendipity"
        let word_id = word.lowercased() //word id is case sensitive and lowercase is required
        let filters = "pronunciations;regions=us"
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)/\(filters)")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response,
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
             {
                let results = jsonData!["results"] as! [[String: Any]]
                let a = results[0]
                let b = a["lexicalEntries"] as! [[String: Any]]
                let c = b[0]
                let d = c["pronunciations"] as! [[String: Any]]
                let e = d[0]
                let f = e["audioFile"] as! String
                print(f)
                
                                
                let url = URL(string: f)
                
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                self.player = AVPlayer(playerItem: playerItem)
                
                self.player!.play()
               
                
            } else {
                print(error)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



