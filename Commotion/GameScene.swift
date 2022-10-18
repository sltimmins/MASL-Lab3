//
//  GameScene.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {

    //@IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: CGFloat(9.8*gravity.y))
        }
    }
    
    // MARK: View Hierarchy Functions
//    let spinBlock = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        // add some stationary modelos
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.85))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.366, y: size.height * 0.85))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.633, y: size.height * 0.85))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.85))
        
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.233, y: size.height * 0.75))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.75))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.766, y: size.height * 0.75))

        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.65))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.366, y: size.height * 0.65))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.633, y: size.height * 0.65))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.65))
        
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.233, y: size.height * 0.55))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.55))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.766, y: size.height * 0.55))
        
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.45))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.366, y: size.height * 0.45))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.633, y: size.height * 0.45))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.45))
        
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.233, y: size.height * 0.35))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.766, y: size.height * 0.35))
        
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.25))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.366, y: size.height * 0.25))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.633, y: size.height * 0.25))
        self.addStaticPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.25))
        
        
        // add a spinning block
//        self.addBlockAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        
        self.addSpriteBottle()
        
        self.addScore()
        
        self.score = 0
    }
    
    // MARK: Create Sprites Functions
    func addScore(){
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY)
        
        addChild(scoreLabel)
    }
    
    
    func addSpriteBottle(){
        let spriteA = SKSpriteNode(imageNamed: "larson") // this is literally Dr. Larson
        
        spriteA.size = CGSize(width:size.width*0.1,height:size.height * 0.06)
        
        let randNumber = random(min: CGFloat(0.1), max: CGFloat(0.9))
        spriteA.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        
        spriteA.physicsBody = SKPhysicsBody(rectangleOf:spriteA.size)
        spriteA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        spriteA.physicsBody?.isDynamic = true
        spriteA.physicsBody?.contactTestBitMask = 0x00000001
        spriteA.physicsBody?.collisionBitMask = 0x00000001
        spriteA.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(spriteA)
    }
    
//    func addBlockAtPoint(_ point:CGPoint){
//
//        spinBlock.color = UIColor.red
//        spinBlock.size = CGSize(width:size.width*0.15,height:size.height * 0.05)
//        spinBlock.position = point
//
//        spinBlock.physicsBody = SKPhysicsBody(rectangleOf:spinBlock.size)
//        spinBlock.physicsBody?.contactTestBitMask = 0x00000001
//        spinBlock.physicsBody?.collisionBitMask = 0x00000001
//        spinBlock.physicsBody?.categoryBitMask = 0x00000001
//        spinBlock.physicsBody?.isDynamic = true
//        spinBlock.physicsBody?.pinned = true
//
//        self.addChild(spinBlock)
//
//    }
    
    func addStaticBlockAtPoint(_ point:CGPoint){
        let 🔲 = SKSpriteNode()
        
        🔲.color = UIColor.red
        🔲.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        🔲.position = point
        
        🔲.physicsBody = SKPhysicsBody(rectangleOf:🔲.size)
        🔲.physicsBody?.isDynamic = true
        🔲.physicsBody?.pinned = true
        🔲.physicsBody?.allowsRotation = true
        
        self.addChild(🔲)
        
    }
    
    func addStaticPegAtPoint(_ point:CGPoint){
        let modelo = SKSpriteNode(imageNamed: "modelo")
        
//        modelo.color = UIColor.init(red: 210/255, green: 180/255, blue: 140/255, alpha: 1)
        modelo.size = CGSize(width:size.width*0.07,height:size.height * 0.035)
        modelo.position = point
        
        modelo.physicsBody = SKPhysicsBody(circleOfRadius:modelo.size.height/3)
        modelo.physicsBody?.isDynamic = true
        modelo.physicsBody?.pinned = true
        modelo.physicsBody?.allowsRotation = false
        
        self.addChild(modelo)
        
    }
    
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        for obj in [left,right,top]{
            obj.color = UIColor.init(red: 210/255, green: 180/255, blue: 140/255, alpha: 1)
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    // MARK: =====Delegate Functions=====
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addSpriteBottle()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.node == spinBlock || contact.bodyB.node == spinBlock {
//            self.score += 1
//        }
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
