//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yunus Nedim Mehel on 02/10/2015.
//  Copyright (c) 2015 Yunus Nedim Mehel. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    @IBAction func tappedSlowPlay(sender: UIButton) {

        player.rate = 0.2
        player.play()
    }

    @IBAction func tappedChipmunk(sender: UIButton) {
        
//        commonAudioFunction(1000, typeOfChange: "pitch")
        commonAudioFunction(900, typeOfChange: "pitch")
    }
    
    @IBAction func tappedVader(sender: UIButton) {
        
        //        commonAudioFunction(1000, typeOfChange: "pitch")
        commonAudioFunction(-900, typeOfChange: "pitch")
    }
    
    @IBAction func tappedFastPlay(sender: AnyObject) {

        player.rate = 2.5
        player.play()
        
    }
    @IBAction func stop(sender: AnyObject) {
        player.stop()
    }
    
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attachNode(audioPlayerNode)
        
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (typeOfChange == "rate") {
            
            changeAudioUnitTime.rate = audioChangeNumber
            
        } else {
            
            changeAudioUnitTime.pitch = audioChangeNumber
        }
        
        audioEngine.attachNode(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
}
