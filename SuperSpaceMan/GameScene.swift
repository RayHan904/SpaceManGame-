//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Rehan Ali. on 2023-05-24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
     Create the scene for the game
     */
    
    //MARK: - Sprites
    let playerNode = SKSpriteNode(imageNamed: "Player")
    let backgroundNode = SKSpriteNode(imageNamed: "Background")
    let enemyNode = SKSpriteNode(imageNamed: "BlackHole0")
    let powerUp = SKSpriteNode(imageNamed: "PowerUp")
    

    
    var scoreLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "BubbleGum")
        label.fontSize = 48
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Score: 1"
        return label
    }()
    
    var gameLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "BubbleGum")
        label.fontSize = 56
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Game Over"
        label.isHidden = true
        return label
    }()
    
    var score = 1
   
    
    var scaleDownAction:SKAction!
    var scaleAction: SKAction!
    var moveByAction: SKAction!
    var colourAction: SKAction!
    var rotateAction: SKAction!
    
    override init(size: CGSize) {
        super.init(size: size)
        //Initializing the game scene
        
        physicsWorld.contactDelegate = self
        ///Gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2)
        
        //MARK: - Add sprites into game scene
        
        scoreLabel.position = CGPoint(x: size.width / 2.0, y: size.height - 100)
        addChild(scoreLabel)
     
        gameLabel.position = CGPoint(x: size.width / 2.0, y: size.height - 400)
        addChild(gameLabel)
        
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        addChild(backgroundNode)
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: size.height - 100)
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width)
        playerNode.physicsBody?.contactTestBitMask = playerNode.physicsBody?.collisionBitMask ?? 0
        playerNode.physicsBody?.isDynamic = true
        playerNode.zPosition = 2
        playerNode.physicsBody?.node?.name = "player"
        addChild(playerNode)
        
        enemyNode.position = CGPoint(x: size.width / 2.0, y: size.height - 500)
        enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: enemyNode.size.width)
        enemyNode.physicsBody?.isDynamic = false
        enemyNode.physicsBody?.node?.name = "enemy"
    
        addChild(enemyNode)

        
        powerUp.position = CGPoint(x: size.width / 2.0, y: size.height - 650)
        powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width / 2)
        powerUp.physicsBody?.isDynamic = false
        powerUp.physicsBody?.node?.name = "power"
        
        addChild(powerUp)
        
        //MARK: - Actions
        scaleDownAction = SKAction.scale(to: 2, duration: 4.0)
         scaleAction = SKAction.scale(to: 3.0, duration: 5.0)
         moveByAction = SKAction.moveBy(x: 50.0, y: 0.0, duration: 5.0)
        colourAction = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 3.0)
        rotateAction = SKAction.rotate(byAngle: 45.0, duration: 3.0)
        
        //MARK: - Particle Effects
        let particle = SKEmitterNode(fileNamed: "Spark.sks")
        let health = SKEmitterNode(fileNamed: "Bokeh.sks")
        let gameDecision = SKEmitterNode(fileNamed: "Snow.sks")
        
        powerUp.addChild(health!)
        playerNode.addChild(particle!)
        gameLabel.addChild(gameDecision!)
        
        gameDecision?.position = CGPoint(x: (particle?.position.x)!, y: (particle?.position.y)! + 500 )
        gameDecision?.zPosition = 1
        
        particle?.position = CGPoint(x: (particle?.position.x)!, y: (particle?.position.y)! - 20)
        particle?.zPosition = 1
    
        health?.position = CGPoint(x: (health?.position.x)!, y: (health?.position.y)! - 20)
        health?.zPosition = 1
    }
    

    func collision(between player: SKNode, object: SKNode) {
        if object.name == "enemy" {
            if score >= 0 {
                score -= 1
                updateScore()

            } else if score < 0 {
                gameLabel.text = "Game Over"
                gameLabel.isHidden = false
                print("You Lose")
                player.removeFromParent()
            }
       
            
        } else if object.name == "power" {
            score += 1000
            gameLabel.text = "You Win"
            gameLabel.isHidden = false
            updateScore()
            print("You Win")
            player.removeFromParent()
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    override func didFinishUpdate() {
        if playerNode.position.y <= 0  {
             print("out on the Bottom of the screen")
            gameLabel.text = "Game Over"
            gameLabel.isHidden = false
            scoreLabel.text = "Out of Boundry"
            print("You Lose")
            playerNode.removeFromParent()
             //worked
        }
        if playerNode.position.y >= frame.height {
             print("out on the Top of the screen")
            gameLabel.text = "Game Over"
            gameLabel.isHidden = false
            scoreLabel.text = "Out of Boundry"
            print("You Lose")
            playerNode.removeFromParent()
             //worked
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
  
        
        if contact.bodyA.node?.name == "player" {
            collision(between: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "player" {
            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
        }
        
        if playerNode.position.y <= 0  {
             print("out on the Bottom of the screen")
            gameLabel.text = "Game Over"
            gameLabel.isHidden = false
            print("You Lose")
            playerNode.removeFromParent()
             //worked
        }
        if playerNode.position.y >= frame.height {
             print("out on the Top of the screen")
            gameLabel.text = "Game Over"
            gameLabel.isHidden = false
            print("You Lose")
            playerNode.removeFromParent()
             //worked
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //MARK: - When I tap the screen, the player's physics gets affected
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
        
        //MARK: - Actions - I can use them to move, scale, rotate and colour my sprites
     
        ///Sequence will do each action after each other
        enemyNode.run(SKAction.sequence([scaleAction, moveByAction, colourAction]))
        ///Will do the action forever
        enemyNode.run(SKAction.repeatForever(rotateAction))
        
        powerUp.run(SKAction.sequence([scaleDownAction]))
        

 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
