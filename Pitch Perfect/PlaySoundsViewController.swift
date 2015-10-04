//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yunus Nedim Mehel on 02/10/2015.
//  Copyright (c) 2015 Yunus Nedim Mehel. All rights reserved.
//

import UIKit
import AVFoundation

let kDefaultPitch:Float = 1
let kDefaultPowerForRate:Float = 0

class PlaySoundsViewController: UIViewController {

    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var sliderForRate: UISlider!
    @IBOutlet weak var sliderForPitch: UISlider!

    @IBOutlet weak var playStopButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    @IBAction func tappedReset(sender: UIButton) {
        
        self.sliderForPitch.value = kDefaultPitch
        self.sliderForRate.value = kDefaultPowerForRate
    }

    @IBAction func tappedPlayButton(sender: UIButton) {

        audioEngine.stop()
        var rate = powf(2,sliderForRate.value) //See AVAudioUnitTimePitch.rate (1/32 - 32)
        var pitch = sliderForPitch.value
        playAudio(rate: rate, pitch: pitch)
    }
    
    @IBAction func tappedStopButton(sender: UIButton) {
        
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
    
    // MARK: - Quick Buttons
    @IBAction func tappedSlowPlay(sender: UIButton) {
        
        playAudio(rate: 0.25, pitch:1)
    }
    
    @IBAction func tappedChipmunk(sender: UIButton) {
        
        playAudio(rate: 1.30, pitch: 1200)
    }
    
    @IBAction func tappedVader(sender: UIButton) {
        
        playAudio(rate: 0.80, pitch: -900)
    }
    
    @IBAction func tappedFastPlay(sender: AnyObject) {
        
        playAudio(rate: 2, pitch:1)
    }
}
