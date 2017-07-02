//
//  GameScene.swift
//  LunarGolfMobile
//
//  Created by Jacob Bryon on 7/2/17.
//  Copyright © 2017 TwoNerdsGamesCo. All rights reserved.
//

//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var rocket:SKSpriteNode!
    var planet:SKSpriteNode!
    var moon:SKSpriteNode!
    var blackhole:SKSpriteNode!
    var spaceColor:SKColor!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    
    let rocketCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let planetCategory: UInt32 = 1 << 2
    let gravityCategory: UInt32 = 0x1 << 0
    
    
    override func didMove(to view: SKView) {
        
        canRestart = false
        
        // setup physics
        //note I am note sure how to get the contact delagate to really work
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        spaceColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        self.backgroundColor = spaceColor
        
        // setup rocket and planet
        let planetTexture = SKTexture(imageNamed: "planet")
        planet = SKSpriteNode(texture: planetTexture)
        planet.setScale(0.15)
        planet.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.5)
        
        planet.physicsBody = SKPhysicsBody(circleOfRadius: planet.size.height / 2.0)
        planet.physicsBody?.isDynamic = true
        planet.physicsBody?.allowsRotation = true
        planet.physicsBody?.mass = 10000
        planet.physicsBody?.affectedByGravity = true
        // add gravity to planet
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = 15
        gravity.categoryBitMask = gravityCategory
        planet.addChild(gravity)
        
        let rocketTexture = SKTexture(imageNamed: "rocket")
        rocket = SKSpriteNode(texture: rocketTexture)
        rocket.setScale(0.15)
        rocket.position = CGPoint(x: planet.position.x + 1.1*planet.size.width/2 + rocket.size.width/2, y:planet.position.y)
        rocket.zRotation = CGFloat(-1*Double.pi/2)
        
        rocket.physicsBody = SKPhysicsBody(circleOfRadius: rocket.size.height / 2.0)
        rocket.physicsBody?.isDynamic = true
        rocket.physicsBody?.allowsRotation = true
        rocket.physicsBody?.mass = 1
        rocket.physicsBody?.affectedByGravity = true
        rocket.physicsBody?.restitution = 10
        rocket.physicsBody?.linearDamping = 0
        
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.collisionBitMask = worldCategory | planetCategory
        rocket.physicsBody?.contactTestBitMask = worldCategory | planetCategory
        
        self.addChild(planet)
        self.addChild(rocket)
        
        
        
        // create score tracker
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"Arial")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches { // do we need all touches?
            rocket.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            rocket.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
    }
    //figure out different gestures
    func rotateGesture(sender: UIRotationGestureRecognizer){
        sender.view?.transform = (sender.view?.transform)!.rotated(by: sender.rotation)
        sender.rotation = 0
        print("rotate gesture")
    }
    func pinchGesture(sender: UIPinchGestureRecognizer){
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
        print("pinch gesture")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // put stuff here
    }
    
}

