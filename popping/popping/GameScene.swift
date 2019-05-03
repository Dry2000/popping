//
//  GameScene.swift
//  popping
//
//  Created by 洞井僚太 on 2019/04/27.
//  Copyright © 2019 洞井僚太. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
class GameScene: SKScene,SKPhysicsContactDelegate{
    var motionManager:CMMotionManager!
    var acceleration:CGFloat = 0.0
    var player1 = SKSpriteNode(imageNamed: "down")
    var background = SKSpriteNode(imageNamed: "prof")
    var frameSprite = SKSpriteNode(imageNamed: "invisible")
    var scoreFrameSprite = SKSpriteNode(imageNamed: "score")
    let pointLabel = SKLabelNode(fontNamed: "PixelMplus12-Regular")
    let highScoreLabel = SKLabelNode(fontNamed: "PixelMplus12-Regular")
    let charaSprite = SKSpriteNode(imageNamed:"up")
    var charaYpos:CGFloat = 0.0
    var charaYposition:CGFloat = 0.0
    var charaXposition:Double = 0.0
    var contactFrag = true
    var floorSprite = SKSpriteNode()
    var blocksNode:[SKNode] = []
    let blockSprite = SKSpriteNode(imageNamed: "ground")
    let gameoverSprite = SKSpriteNode(imageNamed: "gameover")
    var gameoverFlag = false
    let giftSprite = SKSpriteNode(imageNamed: "paper20")
    var point:Int = 0
    let charaCategory:UInt32 = 0b0001
    let blockCategory:UInt32 = 0b0101
    override func didMove(to view: SKView) {
        layoutObjects()
        background.xScale = frame.width/background.frame.width
        background.yScale = frame.height/background.frame.height
        addChild(background)
        background.zPosition = -1
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        self.physicsWorld.contactDelegate = self
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){(data,_) in
            guard let data = data else{return}
            let accel = data.acceleration
            self.acceleration = CGFloat(accel.x)*0.75+self.acceleration*0.25
        }
        
    }
    
    
    override func didSimulatePhysics() {
        let nextposition = self.charaSprite.position.x+self.acceleration*50
        self.charaSprite.position.x = nextposition
        if charaSprite.position.x+charaSprite.frame.width/2>self.frame.width/2{
            player1.position = CGPoint(x:-(self.frame.width/2)-player1.frame.width/2,y:charaSprite.position.y)
            if charaSprite.position.x-player1.frame.width/2>self.frame.width/2{
                charaSprite.position.x = player1.position.x
                player1.removeFromParent()
            }
        }
        if charaSprite.position.x-charaSprite.frame.width/2 < -self.frame.width/2{
            player1.position = CGPoint(x:self.frame.width/2+player1.frame.width/2,y:charaSprite.position.y)
            if charaSprite.position.x+charaSprite.frame.width/2 < -self.frame.width/2{
                //print("a")
                charaSprite.position.x = player1.position.x
                player1.removeFromParent()
            }
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.bodyA.categoryBitMask)
        print(contact.bodyB.categoryBitMask)
        if contactFrag{
            let moveA = SKAction.moveBy(x:0, y: -100, duration: 0.5)
            for i in 0..<1000{
                blocksNode[i].run(moveA)
            }
            charaSprite.physicsBody?.velocity = CGVector(dx:0.0,dy:300)
            if contact.bodyA.node?.name == "floor"||contact.bodyB.node?.name == "floor"{
                gameoverSprite.isHidden = false
                self.gameover()
            }else{
                point += 1
                pointLabel.text = "\(point)"
            }
            let changeTexture = SKAction.animate(with: [SKTexture(imageNamed: "up"),SKTexture(imageNamed: "down")], timePerFrame: 0.2)
            charaSprite.run(changeTexture)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if charaSprite.position.y < charaYpos{
            contactFrag = true
            charaSprite.physicsBody?.collisionBitMask = blockCategory
            charaSprite.physicsBody?.contactTestBitMask = blockCategory
        }else{
            contactFrag = false
            charaSprite.physicsBody?.collisionBitMask = 0
            charaSprite.physicsBody?.contactTestBitMask = 0
        }
        charaYpos = charaSprite.position.y
        if charaYpos < -self.frame.height/2{
            self.gameover()
        }
    }
    func gameover(){
        gameoverSprite.isHidden = false
        gameoverFlag = true
        self.isPaused = true
        charaSprite.texture = SKTexture(imageNamed:"miss")
    }
    func layoutObjects(){
        charaSprite.anchorPoint = CGPoint(x:0.5,y:0.0)
        charaSprite.position = CGPoint(x:160,y:100)
        charaSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:2,height:2))
        charaSprite.physicsBody?.linearDamping = 0
        charaSprite.physicsBody?.allowsRotation = false
        charaSprite.physicsBody?.categoryBitMask = charaCategory
        charaSprite.physicsBody?.collisionBitMask = blockCategory
        charaSprite.physicsBody?.contactTestBitMask = blockCategory
        charaSprite.physicsBody?.velocity = CGVector(dx:0,dy:500)
        charaSprite.zPosition = 3
        addChild(charaSprite)
       // self.addChild(blocksNode)
       // blocksNode.zPosition = 2
        var x:CGFloat = 0
        var y:CGFloat = 0
        for i in 0..<1000{
            let blockSprite = SKSpriteNode(imageNamed:"ground")
            blockSprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:87,height:2))
            blockSprite.physicsBody?.categoryBitMask = blockCategory
            blockSprite.physicsBody?.contactTestBitMask = charaCategory
            blockSprite.physicsBody?.collisionBitMask = charaCategory
            blockSprite.physicsBody?.isDynamic = false
            blockSprite.physicsBody?.allowsRotation = false
            /*blockSprite.xScale = 2
            blockSprite.yScale = 2*/
            var randIntX = arc4random_uniform(UInt32(frame.width/2))
            var randIntY = arc4random_uniform(UInt32(100))
            var markX = arc4random_uniform(2)
            var markY = arc4random_uniform(2)
            if markX>0{
                x = CGFloat(randIntX)
            }else{
                x = -CGFloat(randIntX)
            }
                y += CGFloat(randIntY)+50
            blockSprite.position = CGPoint(x:x,y:y)
            self.addChild(blockSprite)
            blocksNode.append(blockSprite)
        }
        frameSprite.xScale = self.frame.width
        frameSprite.position = CGPoint(x:0,y:-self.frame.height/2)
        frameSprite.physicsBody?.isDynamic = false
        frameSprite.physicsBody?.categoryBitMask = 0b0011
        frameSprite.physicsBody?.contactTestBitMask = charaCategory
        frameSprite.physicsBody?.collisionBitMask = charaCategory
        self.addChild(frameSprite)
    }
}
