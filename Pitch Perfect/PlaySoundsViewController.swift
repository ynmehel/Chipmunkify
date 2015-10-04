//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yunus Nedim Mehel on 02/10/2015.
//  Copyright (c) 2015 Yunus Nedim Mehel. All rights reserved.
//

import UIKit
import AVFoundation

let kMinAllowedPitch:Float = -2400
let kMaxAllowedPitch:Float = 2400
let kMinAllowedPowerForRate:Float = -5
let kMaxAllowedPowerForRate:Float = 5
let kDefaultPitch:Float = 1
let kDefaultPowerForRate:Float = 0

class PlaySoundsViewController: UIViewController {

    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var sliderForRate: UISlider!
    @IBOutlet weak var sliderForPitch: UISlider!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        sliderForPitch.minimumValue = kMinAllowedPitch
        sliderForPitch.maximumValue = kMaxAllowedPitch
        sliderForRate.minimumValue = kMinAllowedPowerForRate
        sliderForRate.maximumValue = kMaxAllowedPowerForRate
        
    }

    @IBAction func tappedPlayButton(sender: UIButton) {
        
        var rate = powf(2,sliderForRate.value) //See AVAudioUnitTimePitch.rate (1/32 <> 32)
        var pitch = sliderForPitch.value
        playAudio(rate: rate, pitch: pitch)
    }
    
    @IBAction func tappedSlowPlay(sender: UIButton) {

        playAudio(rate: -300, pitch: -900)
    }

    @IBAction func tappedChipmunk(sender: UIButton) {
        
        playAudio(rate: 1, pitch: 900)
    }
    
    @IBAction func tappedVader(sender: UIButton) {
        
        playAudio(rate: 1, pitch: -900)
    }
    
    @IBAction func tappedFastPlay(sender: AnyObject) {

        playAudio(rate: 500, pitch: -900)
    }
    
    @IBAction func stop(sender: AnyObject) {

        audioEngine.stop()
    }
    
    func playAudio(#rate: Float, pitch: Float){
    
        var audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attachNode(audioPlayerNode)
        
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        changeAudioUnitTime.rate = rate
        changeAudioUnitTime.pitch = pitch
        
        audioEngine.attachNode(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
