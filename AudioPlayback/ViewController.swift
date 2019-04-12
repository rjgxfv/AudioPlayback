//
//  ViewController.swift
//  AudioPlayback
//
//  Created by Robert on 4/12/19.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIBarButtonItem!
    @IBOutlet weak var button2: UIBarButtonItem!
    
    var recorder : AVAudioRecorder!
    var session : AVAudioSession!
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.title = "Record"
        button1.image = UIImage(named: "record")
        button2.title = "Play"
        button2.image = UIImage(named: "play")
        button2.isEnabled = false
    }
    @IBAction func buttonClicked1(_ sender: Any) {
        button2.title = "Stop"
        button2.image = UIImage(named: "stop")
        button2.isEnabled = true
        button1.isEnabled = false
        
        session = AVAudioSession.sharedInstance()

        do{
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in DispatchQueue.main.async {
                if allowed {
                    let settings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                    AVEncoderBitRateKey: 16,
                                    AVNumberOfChannelsKey: 2,
                                    AVSampleRateKey: 44100.0] as [String : Any]
                    let file = "recording.caf"
                    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let fileURL = dir!.appendingPathComponent(file)
                    do{
                        self.recorder = try AVAudioRecorder(url: fileURL, settings: settings)
                        self.recorder.record()
                    }catch{
                        print("Recordign failed")
                    }
                }else{
                    print("Recordign Failed")
                }
                }}
        }catch{
                print("Recording Failed")
        }
        
    }
    @IBAction func buttonClicked2(_ sender: Any) {
        if button2.title == "Play"{
            button2.title = "Pause"
            button2.image = UIImage(named: "pause")
            button1.isEnabled = false
            do{
                player = try AVAudioPlayer(contentsOf: (recorder?.url)!)
            }
            catch{
                print("error")
            }
            
            
        }else if button2.title == "Pause"{
            button1.isEnabled = true
            button2.title = "Play"
            button2.image = UIImage(named: "play")
            player.stop()
            
        }else if button2.title == "Stop"{
            button2.title = "Play"
            button2.image = UIImage(named: "play")
            button1.isEnabled = true
            recorder.stop()
            
        }
    }
    

}

