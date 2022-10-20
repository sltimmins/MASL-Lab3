//
//  GameViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
protocol GameViewControllerDelegate : NSObjectProtocol {
    func setShareButtonHidden(hidden: Bool)
}
class GameViewController: UIViewController, GameViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var wagerLabel: UILabel!
    @IBOutlet weak var wagerSlider: UISlider!
    @IBOutlet weak var wagerButton: UIButton!
    
    var currSteps = 0
    var wager = 0
    
    var scene = GameScene()
//    if scene.madeContact()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currSteps = self.defaults.integer(forKey: "steps")
        
        wagerSlider.value = 0
        wagerSlider.maximumValue = Float(currSteps)
        wagerSlider.minimumValue = 0
        
        stepsLabel.text = "You have " + String(currSteps) + " steps to wager.";
        stepsLabel.textColor = UIColor.black
        
        wagerLabel.textColor = UIColor.black
        wagerLabel.text = "I want to wager " + String(Int(wagerSlider.value)) + " steps!"
        
        wagerButton.setTitle("Free Drop!", for: .normal)
        
        wager = Int(wagerSlider.value)
        
        //setup game scene
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView // the view in storyboard must be an SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        scene.gameVCDelegate = self
    }

        
    @IBAction func sliderMove(_ sender: Any) {
        wager = Int(wagerSlider.value)
        wagerLabel.text = "I want to wager " + String(Int(wagerSlider.value)) + " steps!"
        wagerButton.setTitle("Wager!", for: .normal)
        if(wagerSlider.value == 0){
            wagerButton.setTitle("Free Drop!", for: .normal)
        }
    }
    
    @IBAction func wagerButtonPress(_ sender: Any) {
        currSteps -= wager;
        stepsLabel.text = "You have " + String(currSteps) + " steps to wager!";
        wagerSlider.maximumValue = Float(currSteps)
        wagerSlider.value = 0
        wagerLabel.text = "I want to wager " + String(Int(wagerSlider.value)) + " steps!"
        
        scene.updateScene(wager)
        wager = 0
        wagerButton.setTitle("Free Drop!", for: .normal)
//        wagerButton.isHidden = true
        setShareButtonHidden(hidden: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func setShareButtonHidden(hidden: Bool){
        print("in this bitch")
        self.wagerButton.isHidden = hidden
    }
}
