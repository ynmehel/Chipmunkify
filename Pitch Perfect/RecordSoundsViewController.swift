//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yunus Nedim Mehel on 02/10/2015.
//  Copyright (c) 2015 Yunus Nedim Mehel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.stopButton.hidden = true
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        self.infoLabel.hidden = true
        self.stopButton.hidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        self.infoLabel.hidden = false
        self.stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let fileName = "x" + ".wav"
        let pathArray = [dirPath, fileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: [:], error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // MARK: - Audio Delegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(!flag) {return}
            
        recordedAudio = RecordedAudio()
        recordedAudio.title = recorder.url.lastPathComponent
        recordedAudio.filePathUrl = recorder.url
        
        self .performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            
            var nextVC = segue.destinationViewController as! PlaySoundsViewController
            var audio = sender as! RecordedAudio
            nextVC.receivedAudio = audio
            
        }
    }

}

