//
//  ViewController.swift
//  wordCraze
//
//  Created by Li Zhang on 2/4/18.
//  Copyright © 2018 Li Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var wordArray: [String]?
    
    @IBOutlet weak var currentWordLabel: UILabel!
    
    
    @IBAction func generateRandomNewWord(_ sender: Any) {
        let randomId = Int(arc4random_uniform(UInt32(wordArray!.count)))
        let newWord:String = wordArray![randomId]
        currentWordLabel.text = newWord
        readWord(word: newWord)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "words", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                wordArray = data.components(separatedBy: "\n")
            }
        } catch let err as NSError {
            // do something with Error
            print(err)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func readWord(word: String) {
        let appId = "e28c1363"
        let appKey = "1b7bf2d9b08c9a6de6f1041bd2131cfe"
        let language = "en"
        let word = word
        let word_id = word.lowercased() //word id is case sensitive and lowercase is required
        let filters = "pronunciations;regions=us"
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)/\(filters)")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
//        let params : [String : String] = ["app_id" : appId, "app_key": appKey]
        
//        Alamofire.request(url, method: .get, parameters: params).responseString {
//            response in
//            if response.result.isSuccess {
//                print("Success! Got the weather data")
//
//                let weatherJSON : JSON = JSON(response.result.value!)
//                print("ok")
////                self.updateWeatherData(json: weatherJSON)
//            }
//            else {
//                print("Error \(response.result.error)")
////                self.cityLabel.text = "Connection Issues"
//            }
//        }
        
        
        let session = URLSession.shared

        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response,
                let data = data
//                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            {
                let f = JSON(data)
                var g = f["results"][0]["lexicalEntries"][0]["pronunciations"][1]["audioFile"].rawString()!
                if g == "null" {
                    g = f["results"][0]["lexicalEntries"][0]["pronunciations"][0]["audioFile"].rawString()!
                }
                
                let url = URL(string: g)
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                self.player = AVPlayer(playerItem: playerItem)
                self.player!.play()
            } else {
                print(error)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
    }
}



