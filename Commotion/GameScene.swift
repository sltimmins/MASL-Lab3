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

    let defaults = UserDefaults.standard
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
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: -5.0)
        }
    }
    
    // MARK: View Hierarchy Functions
    
    // FOR GOAL BOX
    let doubleBox = SKSpriteNode()
    let halfBox = SKSpriteNode()
    let tripleBox = SKSpriteNode()
    let divThreeBox = SKSpriteNode()
    
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    //used for collision scoring
    let doubleBoxLabel = SKLabelNode(fontNamed: "Chalkduster")
    let halfBoxLabel = SKLabelNode(fontNamed: "Chalkduster")
    let tripleBoxLabel = SKLabelNode(fontNamed: "Chalkduster")
    let divThreeBoxLabel = SKLabelNode(fontNamed: "Chalkduster")

    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    //to show and unshow button
    var gameVCDelegate: GameViewControllerDelegate?
    var wager:Int = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        //adding all the modelos
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
        
        //add the scoring shoots
        self.addStaticShootAtPoint(CGPoint(x: size.width * 0.25, y: size.height * 0.05))
        self.addStaticShootAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.05))
        self.addStaticShootAtPoint(CGPoint(x: size.width * 0.75, y: size.height * 0.05))
        
        // add THE SCORING BLOCKS
        self.addScoringBlockAtPoint(CGPoint(x: size.width * 0.125, y: size.height * 0.01), doubleBox)
        self.addScoringBlockAtPoint(CGPoint(x: size.width * 0.375, y: size.height * 0.01), divThreeBox)
        self.addScoringBlockAtPoint(CGPoint(x: size.width * 0.625, y: size.height * 0.01), tripleBox)
        self.addScoringBlockAtPoint(CGPoint(x: size.width * 0.875, y: size.height * 0.01), halfBox)
        
        //self.addSpriteBottle()
        
        self.addScore()
        
        //SET SCORE TO STEPS
        self.score = 0
        
        //adding scoring identifiers
        doubleBoxLabel.text = "x2"
        doubleBoxLabel.fontSize = 20
        doubleBoxLabel.fontColor = SKColor.blue
        doubleBoxLabel.position = CGPoint(x: frame.minX + 55, y: frame.minY + 40)
        
        divThreeBoxLabel.text = "1/3"
        divThreeBoxLabel.fontSize = 20
        divThreeBoxLabel.fontColor = SKColor.blue
        divThreeBoxLabel.position = CGPoint(x: frame.minX + 150, y: frame.minY + 40)
        
        halfBoxLabel.text = "1/2"
        halfBoxLabel.fontSize = 20
        halfBoxLabel.fontColor = SKColor.blue
        halfBoxLabel.position = CGPoint(x: frame.maxX - 55, y: frame.minY + 40)
        
        tripleBoxLabel.text = "x3"
        tripleBoxLabel.fontSize = 20
        tripleBoxLabel.fontColor = SKColor.blue
        tripleBoxLabel.position = CGPoint(x: frame.maxX - 150, y: frame.minY + 40)
        
        addChild(doubleBoxLabel)
        addChild(divThreeBoxLabel)
        addChild(halfBoxLabel)
        addChild(tripleBoxLabel)
    }
    
    //change wager amount and drop the token for it
    func updateScene(_ wager:Int){
        self.wager = wager
        self.addToken()
    }
    
    // MARK: Create Sprites Functions
    func addScore(){
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(scoreLabel)
    }
    
    //adding the plinko token (face)
    func addToken(){
        let spriteA = SKSpriteNode(imageNamed: "larson") // this is literally Dr. Larson
        
        spriteA.size = CGSize(width:size.width*0.1,height:size.height * 0.06)
        
        _ = random(min: CGFloat(0.1), max: CGFloat(0.9))
        spriteA.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        
        spriteA.physicsBody = SKPhysicsBody(rectangleOf:spriteA.size)
        spriteA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        spriteA.physicsBody?.isDynamic = true
        spriteA.physicsBody?.contactTestBitMask = 0x00000001
        spriteA.physicsBody?.collisionBitMask = 0x00000001
        spriteA.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(spriteA)
    }
    
    // FOR MULTIPLIERS
    func addScoringBlockAtPoint(_ point:CGPoint, _ node:SKSpriteNode){
        node.color = UIColor.white
        node.size = CGSize(width:size.width*0.1,height:size.height * 0.01)
        node.position = point

        node.physicsBody = SKPhysicsBody(rectangleOf:node.size)
        node.physicsBody?.contactTestBitMask = 0x00000001
        node.physicsBody?.collisionBitMask = 0x00000001
        node.physicsBody?.categoryBitMask = 0x00000001
        node.physicsBody?.isDynamic = true
        node.physicsBody?.pinned = true
        node.physicsBody?.allowsRotation = false

        self.addChild(node)

    }
    
    //adding shoots for scoring
    func addStaticShootAtPoint(_ point:CGPoint){
        let shoot = SKSpriteNode()
        
        shoot.color = UIColor.init(red: 210/255, green: 180/255, blue: 140/255, alpha: 1)
        shoot.size = CGSize(width:size.width*0.01,height:size.height * 0.1)
        shoot.position = point
        
        shoot.physicsBody = SKPhysicsBody(rectangleOf:shoot.size)
        shoot.physicsBody?.isDynamic = true
        shoot.physicsBody?.pinned = true
        shoot.physicsBody?.allowsRotation = false
        
        self.addChild(shoot)
        
    }
    
    //adding modelo plinko pegs
    func addStaticPegAtPoint(_ point:CGPoint){
        let modelo = SKSpriteNode(imageNamed: "modelo")
        
        modelo.size = CGSize(width:size.width*0.07,height:size.height * 0.035)
        modelo.position = point
        
        modelo.physicsBody = SKPhysicsBody(circleOfRadius:modelo.size.height/3)
        modelo.physicsBody?.isDynamic = true
        modelo.physicsBody?.pinned = true
        modelo.physicsBody?.allowsRotation = false
        
        self.addChild(modelo)
        
    }
    
    //adding the side and top constraints
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
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.addSpriteBottle()
//    }
    
    //do the scoring handling
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == doubleBox || contact.bodyB.node == doubleBox {
            self.score += wager * 2
            contact.bodyB.node?.removeFromParent()
            self.gameVCDelegate?.setShareButtonHidden(hidden: false)
        }
        if contact.bodyA.node == divThreeBox || contact.bodyB.node == divThreeBox {
            self.score += wager / 3
            contact.bodyB.node?.removeFromParent()
            self.gameVCDelegate?.setShareButtonHidden(hidden: false)
        }
        if contact.bodyA.node == halfBox || contact.bodyB.node == halfBox {
            self.score += wager / 2
            contact.bodyB.node?.removeFromParent()
            self.gameVCDelegate?.setShareButtonHidden(hidden: false)
        }
        if contact.bodyA.node == tripleBox || contact.bodyB.node == tripleBox {
            self.score += wager * 3
            contact.bodyB.node?.removeFromParent()
            self.gameVCDelegate?.setShareButtonHidden(hidden: false)
        }
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    func madeContact(){
        
    }
}
