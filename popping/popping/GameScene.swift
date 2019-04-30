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
    var player=SKSpriteNode(imageNamed:"player")
   // var player1 = SKSpriteNode(imageNamed: "down")
    override func didMove(to view: SKView) {
        addChild(player)
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
