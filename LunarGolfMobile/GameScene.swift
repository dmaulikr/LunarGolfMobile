//
//  GameScene.swift
//  LunarGolfMobile
//
//  Created by Jacob Bryon on 7/2/17.
//  Copyright © 2017 TwoNerdsGamesCo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var rocket:SKSpriteNode!
    var planet:SKSpriteNode!
    var moon:SKSpriteNode!
    var blackhole:SKSpriteNode!
    var spaceColor:SKColor!
    var canRestart = Bool()
    var RocketFire = Bool(false)
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    var powerAmount = CGFloat(10)
    
    let rotateRec = UIRotationGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    let holdRec = UILongPressGestureRecognizer()
    
    let rocketCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let planetCategory: UInt32 = 1 << 2
    let gravityCategory: UInt32 = 0x1 << 0
    
    
    override func didMove(to view: SKView) {
        
        rotateRec.addTarget(self, action: #selector(GameScene.rotateRocket(_:)))
        pinchRec.addTarget(self, action: #selector(GameScene.pinchGesture(_:)))
        holdRec.addTarget(self, action: #selector(GameScene.launchRocket(_:)))
        
        canRestart = false
        
        // setup rocket and planet
        let planetTexture = SKTexture(imageNamed: "planet")
        planet = SKSpriteNode(texture: planetTexture)
        planet.setScale(0.15)
        planet.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.5)
        
        
        let rocketTexture = SKTexture(imageNamed: "rocket")
        rocket = SKSpriteNode(texture: rocketTexture)
        rocket.setScale(0.15)
        rocket.position = CGPoint(x: planet.position.x + 1.1*planet.size.width/2 + rocket.size.width/2, y:planet.position.y)
        rocket.zRotation = CGFloat(-1*Double.pi/2)
    
        
        // setup background color
        spaceColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        self.backgroundColor = spaceColor
        
        self.addChild(planet)
        self.addChild(rocket)
        
        self.view!.addGestureRecognizer(rotateRec)
        self.view!.addGestureRecognizer(pinchRec)
        self.view!.addGestureRecognizer(holdRec)
        
        // create score tracker
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"Arial")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(describing: powerAmount)
        self.addChild(scoreLabelNode)
        
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for _ in touches { // do we need all touches?
////            rocket.physicsBody?.applyImpulse(CGVector(dx: 10*sin(rocket.zRotation), dy: 10*cos(rocket.zRotation)))
//        }
//    }
    
    //figure out different gestures

    func pinchGesture(_ sender: UIPinchGestureRecognizer){
        if (sender.state == .changed){
            rocket.position = CGPoint(x: planet.position.x + sin(sender.scale)*(1.1*planet.size.width/2 + rocket.size.width/2), y:planet.position.y + cos(sender.scale)*(1.1*planet.size.width/2 + rocket.size.width/2))
        }
    }
    
    func rotateRocket(_ sender:UIRotationGestureRecognizer){
        if (sender.state == .changed){
            print("rotation = ")
            print(rocket.zRotation)
            rocket.zRotation = -sender.rotation + CGFloat(-1*Double.pi/2)
        }
    }
    
    func launchRocket(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
        }
        if (sender.state == .changed) {
            powerAmount += 1
            if (powerAmount > 100) {
                powerAmount = 0
            }
            scoreLabelNode.text = String(describing: powerAmount)
        }
        if (sender.state == .ended) {
            print("fire!")
            RocketFire = true
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if RocketFire {
            // setup physics
            //note I am note sure how to get the contact delagate to really work
            self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
            self.physicsWorld.contactDelegate = self
            rocket.physicsBody = SKPhysicsBody(circleOfRadius: rocket.size.height / 2.0)
            
            // add gravity to planet
            let gravity = SKFieldNode.radialGravityField()
            gravity.strength = 5
            gravity.categoryBitMask = gravityCategory
            planet.addChild(gravity)
            
            rocket.physicsBody?.applyImpulse(CGVector(dx: -powerAmount*sin(rocket.zRotation), dy: -powerAmount*cos(rocket.zRotation)))
        }
        
    }
    
}

