//
//  FirstViewController.swift
//  sweatTimer
//
//  Created by Sam Parhizkar on 2017-11-16.
//  Copyright © 2017 Sam Parhizkar. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    var secondsTimer :Timer? = Timer()
    var audioPlayer : AVAudioPlayer?
    var mymodel  = workoutsModel()
    let userDefaults = UserDefaults()
    let userDefaultsKeyForMovesArray = "final moves array"
    var selectionOfMoves : [String] = []
    var accomplishedStatesLabelArray : [UILabel] = []
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
      var statesStackView: UIStackView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var nextWorkoutLabel: UILabel!
    var myUtterance = AVSpeechUtterance(string: "")
    let synth = AVSpeechSynthesizer()
    
    func initlabelsArray (){
        
        
         statesStackView = UIStackView()
        statesStackView.axis = .horizontal
        statesStackView.alignment = .center // .leading .firstBaseline .center .trailing .lastBaseline
        statesStackView.distribution = .fillEqually
        
        statesStackView.spacing = CGFloat(16)
        
        for  _ in 0..<selectionOfMoves.count {
            let newLabel = UILabel()
            newLabel.text = " "
            newLabel.alpha = 0.2
            newLabel.backgroundColor = UIColor.purple
            newLabel.textAlignment = .center
            newLabel.textColor = UIColor.white
            newLabel.font = UIFont(name: "Futura-Medium", size: 16.0)
            newLabel.widthAnchor.constraint(equalTo: newLabel.heightAnchor).isActive = true
            newLabel.layer.cornerRadius = 10
            newLabel.layer.masksToBounds = true
            statesStackView.addArrangedSubview(newLabel)
        }
        self.view.addSubview(statesStackView)
//        (stackView[0] as! UILabel).heightAnchor.constraint(equalToConstant: 40)
        statesStackView.translatesAutoresizingMaskIntoConstraints = false
        startButton.topAnchor.constraint(equalTo:statesStackView.bottomAnchor, constant: 50).isActive = true
        statesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    enum runningState {
        case getReady
        case workout
        case rest
    }
    struct tabataBundle {
        var moveType: runningState
        var workoutName: String
        var Duration : Int
    }
    
    var arrayOfTabataBundles:[tabataBundle] = []
    var tabataSequenceIndex = -1
    var tabataSecondsCountDown = 0
    @IBOutlet weak var textToSpeak: UITextField!
    
    
    @IBAction func startTabata(_ sender: UIButton) {
        
        let isInExcerciseMode = true
        switch isInExcerciseMode {
        case true:
            startWorkout()
        case false:
            stopWorkout()
            
            //        case "Pause":
            //            secondsTimer?.invalidate()
            //            startButton.isHidden = true
            
            //        default: // resume
            //            runTimer()
            ////            startButton.setTitle("I Give Up", for: UIControlState.normal)
        }
    }
    func initTabataValues() {
        tabataSequenceIndex = -1
        tabataSecondsCountDown = 0
    }
    
    func stopWorkout() {
        secondsTimer?.invalidate()
        workoutNameLabel.text = "Get Ready"
        DispatchQueue.global(qos: .background).async {
            self.initTabataValues()
            //            self.buildTabataSequence()
            DispatchQueue.main.async {
                self.startButton.setImage(UIImage(named:"stop"), for: UIControlState.normal)
                self.timerLabel.text = "5"
                
            }
        }
        startButton.isHidden = false
        //            nextWorkoutUpperLabel.isHidden = true
        timerLabel.isHidden = true
    }
    
    func startWorkout() {
        
        
        DispatchQueue.global(qos: .background).async {
            self.initTabataValues()
            //            self.buildTabataSequence()
            DispatchQueue.main.async {
                self.startButton.setImage(UIImage(named:"stop"), for: UIControlState.normal)
            }
        }
        runTimer()
        
    }
    
    func runTimer( ) {
        secondsTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) {timer in
            self.countDown()
        }
    }
    func buildTabataSequence(){
        arrayOfTabataBundles.append(tabataBundle(moveType: runningState.getReady, workoutName: "Get Ready", Duration: 5))
        for index in 0..<selectionOfMoves.count {
            arrayOfTabataBundles.append(tabataBundle(moveType: runningState.workout, workoutName: selectionOfMoves[index], Duration: 4))
            arrayOfTabataBundles.append(tabataBundle(moveType: runningState.rest, workoutName: "Relax", Duration: 4))
        }
        arrayOfTabataBundles.popLast() // pop the last rest
        
    }
    
    
    func countDown(){
        if tabataSecondsCountDown == 0 {
            if tabataSequenceIndex == (arrayOfTabataBundles.count - 1) {
                
                secondsTimer?.invalidate()
                workoutNameLabel.text = "Well done!"
                myUtterance = AVSpeechUtterance(string: "well done")
                synth.speak(myUtterance)
                return
            }
            tabataSequenceIndex += 1
            
            
            let currentTabata = arrayOfTabataBundles[tabataSequenceIndex]
            
            //            myUtterance.preUtteranceDelay = 0.02
            myUtterance.preUtteranceDelay = TimeInterval(0.02)
            DispatchQueue.global(qos: .background).async {
                let path = Bundle.main.path(forResource: "click", ofType: "mp3")
                let url = URL(fileURLWithPath: path!)
                
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                    
                    self.audioPlayer?.play()
                } catch {
                    // couldn't load file :(
                }
                //                print("This is run on the background queue")
                self.myUtterance = AVSpeechUtterance(string: currentTabata.workoutName)
                
                self.synth.speak(self.myUtterance)
                //                DispatchQueue.main.async {
                //                    print("This is run on the main queue, after the previous code in outer block")
                //                }
            }
            if (currentTabata.moveType == .getReady) || (currentTabata.moveType == .rest){
                nextWorkoutLabel.text = "Up Next: \(arrayOfTabataBundles[tabataSequenceIndex + 1].workoutName)"
                nextWorkoutLabel.isHidden = false
                //                nextWorkoutUpperLabel.isHidden = false
                
                
            }else {
                nextWorkoutLabel.isHidden = true
                //                nextWorkoutUpperLabel.isHidden = true
                print("tabata array number is:\(tabataSequenceIndex)")
                let lights = statesStackView.arrangedSubviews[tabataSequenceIndex/2] as! UILabel
                lights.text = "✔︎"
                lights.alpha = CGFloat(1)
            }
            
            tabataSecondsCountDown = currentTabata.Duration
            workoutNameLabel.text = arrayOfTabataBundles[tabataSequenceIndex].workoutName
        }
        timerLabel.text = String(tabataSecondsCountDown)
        tabataSecondsCountDown -= 1
        
    }
    override func viewDidLoad() {
//        selectionOfMoves =  mymodel.readWorkouts().selectedWorkoutIndices
        if let values =  userDefaults.array(forKey: userDefaultsKeyForMovesArray)  {
            selectionOfMoves = values as! [String]
        }else {
            let defaultValues = ["jumping lunges","dips","Press Ups","heavy bag combinations","Push Ups","jumping lunges","box jumps"]
            userDefaults.set(defaultValues, forKey: userDefaultsKeyForMovesArray)
            userDefaults.synchronize()
            selectionOfMoves = defaultValues
        }

//        selectionOfMoves =   userDefaults.array(forKey: userDefaultsKeyForMovesArray) as! [String]
        buildTabataSequence()
        initlabelsArray()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let testSubject : Timer? = secondsTimer
        
        if testSubject != nil{
            myUtterance = AVSpeechUtterance(string: "Resuming Workout")
            synth.speak(myUtterance)
            runTimer()
            startButton.setTitle("I Give Up", for: UIControlState.normal)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let testSubject : Timer? = secondsTimer
        if testSubject != nil{
            
            myUtterance = AVSpeechUtterance(string: "Pausing Workout")
            synth.speak(myUtterance)
            secondsTimer?.invalidate()
        }
    }
    
}

