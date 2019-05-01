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
    var player=SKSpriteNode(imageNamed:"down") //playerのNodeの画像は上昇中、下降中およびGAMEOVER時の３つからなる
    var player1 = SKSpriteNode(imageNamed: "down")
    var background = SKSpriteNode(imageNamed: "background")
    let frameSprite = SKSpriteNode(imageNamed: "frame")
    var scoreFrameSprite = SKSpriteNode(imageNamed: "score")
    let pointLabel = SKLabelNode(fontNamed: "PixelMplus12-Regular")
    let highScoreLabel = SKLabelNode(fontNamed: "PixelMplus12-Regular")
    let charaSprite = SKSpriteNode(imageNamed:"up")
    var charaYpos:CGFloat = 0.0
    var charaYposition:CGFloat = 0.0
    var charaXposition:Double = 0.0
    var contactFrag = true
    var floorSprite = SKSpriteNode()
    let blocksNode = SKNode()
    let blockSprite = SKSpriteNode(imageNamed: "ground")
    let gameoverSprite = SKSpriteNode(imageNamed: "gameover")
    var gameoverFlag = false
    let giftSprite = SKSpriteNode(imageNamed: "paper20")
    var point:Int = 0
    override func didMove(to view: SKView) {
        addChild(player)
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
        let nextposition = self.player.position.x+self.acceleration*50
        self.player.position.x = nextposition
        if player.position.x+player.frame.width/2>self.frame.width/2{
            player1.position = CGPoint(x:-(self.frame.width/2)-player1.frame.width/2,y:player.position.y)
            if player.position.x-player1.frame.width/2>self.frame.width/2{
                player.position.x = player1.position.x
                player1.removeFromParent()
            }
        }
        if player.position.x-player.frame.width/2 < -self.frame.width/2{
            player1.position = CGPoint(x:self.frame.width/2+player1.frame.width/2,y:player.position.y)
            if player.position.x+player.frame.width/2 < -self.frame.width/2{
                //print("a")
                player.position.x = player1.position.x
                player1.removeFromParent()
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
