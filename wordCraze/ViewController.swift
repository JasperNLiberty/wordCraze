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
    
    let tunnelURL = "http://635e10cc.ngrok.io"
    
    @IBOutlet weak var currentWordLabel: UILabel!
    @IBOutlet weak var sen1: UILabel!
    @IBOutlet weak var sen2: UILabel!
    @IBOutlet weak var sen3: UILabel!
    
    @IBAction func generateRandomNewWord(_ sender: Any) {
        let randomId = Int(arc4random_uniform(UInt32(wordArray!.count)))
        let newWord:String = wordArray![randomId]
        currentWordLabel.text = newWord
        
        readWord(word: newWord)
        getSen(word: newWord)
        
//        getSen(word: newWord)
//        serveRandomWord()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "words3", ofType: "txt"){
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


    func getSen(word: String) -> Void {
        
        let url = URL(string: tunnelURL + "/retrieveSen" + "?word=" + word)!
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let resDictionary = response.result.value! as! NSDictionary
                    let senCol = resDictionary["senCol"]! as! [String]
                    
                    self.sen1.text = senCol[0]
                    self.sen2.text = senCol[1]
                    self.sen3.text = senCol[2]
                    
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
        
    }
    
    
    
    func readWord(word: String) -> Void {
        
        let url = URL(string: tunnelURL + "/retrieveMp3" + "?word=" + word)!

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let resDictionary = response.result.value! as! NSDictionary
                    let wordURL = resDictionary["mp3link"]!
                    let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: wordURL as! String)!)
                    self.player = AVPlayer(playerItem: playerItem)
                    self.player!.play()
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    
}



