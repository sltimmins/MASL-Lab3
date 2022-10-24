//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //MARK: =====class variables=====
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    let calendar = Calendar.current
    let today = Date()
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.stepsSlider.setValue(newtotalSteps, animated: true)
                self.stepsLabel.text = "Steps: \(newtotalSteps)"
            }
        }
    }
    let defaults = UserDefaults.standard
    var stepsToday: Int = 0
    var stepsYesterday: Int = 0
    var goal = 0.0
    
    //MARK: =====UI Elements=====
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var isWalking: UILabel!
    @IBOutlet weak var yesterdaySteps: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var stepGoal: UILabel!
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var activitySymbol: UIImageView!
    @IBOutlet weak var playGame: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = self.defaults.object(forKey: "goal") {
            self.goal = self.defaults.double(forKey: "goal")
        } else {
            self.defaults.set(5000.0, forKey: "goal")
            self.goal = 5000.0
        }
        
        self.playGame.isHidden = true
        self.stepGoal.text = String("Step Goal: " + String(Int(self.goal)))
        self.stepsSlider.value = Float(self.goal)
        dates()
    }
    
    //MARK: =====View Lifecycle=====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.startMotionUpdates()
        
        Timer.scheduledTimer(timeInterval: 0.05, target: self,
            selector: #selector(self.dates),
            userInfo: nil,
            repeats: true)
    }
    
    //chaning the step goal for the current day
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.stepGoal.text = String("Step Goal: " + String(Int(sender.value)))
        self.goal = Double(sender.value)
        self.defaults.set(Double(sender.value), forKey: "goal")
    }
    
    @objc
    //setting up the current and previous days
    func dates(){
        let midnight = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: midnight)
        
        pedometer.queryPedometerData(from: yesterday!, to: midnight){
            (data, error) in self.stepsYesterday = (data?.numberOfSteps.intValue)!
        }
        pedometer.queryPedometerData(from: midnight, to: Date()){
            (data, error) in self.stepsToday = (data?.numberOfSteps.intValue)!
        }
        
        self.yesterdaySteps.text = String(self.stepsYesterday)
        self.stepsLabel.text = "Current Steps: " + String(self.stepsToday)
        self.defaults.set(self.stepsToday, forKey: "steps")
        
        var remaining = Int(goal) - stepsToday
        if(remaining < 0) {
            remaining = 0
        }
        
        //setting the progress wheel for the current days steps out of the customly set goal
        CircularProgress.setprogress(Double(stepsToday) / goal, UIColor.systemBlue, String(remaining), "Steps Remaining")
        
        if(Double(stepsToday) >= self.goal) {
            self.playGame.isHidden = false
        } else {
            self.playGame.isHidden = true
        }
//        CircularProgress.animate(0.9, duration: 2)
    }
    
    // MARK: =====Raw Motion Functions=====
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device 
        
        // TODO: should we be doing this from the MAIN queue? You will need to fix that!!!....
        if self.motion.isDeviceMotionAvailable{
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main,
                                                 withHandler: self.handleMotion)
        }
    }
    
    //handling motion
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            let rotation = atan2(gravity.x, gravity.y) - Double.pi
//            self.isWalking.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
    }
    
    // MARK: =====Activity Methods=====
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    //handling activity
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                if(unwrappedActivity.unknown) {
                    self.activitySymbol.image = UIImage(systemName: "questionmark")
                } else if(unwrappedActivity.stationary) {
                    self.activitySymbol.image = UIImage(systemName: "figure.stand")
                } else if(unwrappedActivity.walking) {
                    self.activitySymbol.image = UIImage(systemName: "figure.walk")
                } else if(unwrappedActivity.running) {
                    self.activitySymbol.image = UIImage(systemName: "figure.run")
                } else if(unwrappedActivity.cycling) {
                    self.activitySymbol.image = UIImage(systemName: "figure.outdoor.cycle")
                } else if(unwrappedActivity.automotive) {
                    self.activitySymbol.image = UIImage(systemName: "car.fill")
                }
            }
        }
    }
    
    // MARK: =====Pedometer Methods=====
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date(),
                                   withHandler: handlePedometer)
        }
    }
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }


}

