// File: GameScene.swift
// GAME: SpaceWorld
// Team: Ramandeep, Dalwinder Singh, Vishal Patel

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    //declaring the variables
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var gameTimer:Timer!

    
    //regular set to set the score
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //array of aliens
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    //bit adjustment
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    //calling motion manager to keep move around the frame
    let motionManger = CMMotionManager()
       var xAcceleration:CGFloat = 0
    
    //creating an array to displaying the life of the player
    var liveArray:[SKSpriteNode]!
    
    
    override func didMove(to view: SKView) {
        //calling the addLives function
        addLives()
        
        //adding background
        starfield = SKEmitterNode(fileNamed: "Starfield")
               starfield.position = CGPoint(x: 0, y: 1472)
               starfield.advanceSimulationTime(10)
               self.addChild(starfield)
        //setting the z position (at back) of backround
               starfield.zPosition = -1
        
        //adding player
        player = SKSpriteNode(imageNamed: "Player")
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //adjustment of score level in screen
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
        
        //setting the game timer
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        //motion manager
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.50  + self.xAcceleration * 0.50
            }
        }
    }
    
    //function to add lives of player
    func addLives(){
        liveArray = [SKSpriteNode]()
        
        for live in 1 ... 3{
            let livenode = SKSpriteNode(imageNamed: "shuttle")
            livenode.position = CGPoint(x:self.frame.size.width - CGFloat(4 - live) * livenode.size.width, y:self.frame.size.height - 60)
            self.addChild(livenode)
            liveArray.append(livenode)
        }
    }
    
    //function to add aliens
    @objc func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        //setting the position of aleins
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        self.addChild(alien)
        
        //setting the animation interval
        let animationDuration:TimeInterval = 6
        
        
        //creating an action array to perform action on colision of player with aliens
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
       
        actionArray.append(SKAction.run {
            //creating s sound on collision
            self.run(SKAction.playSoundFileNamed("yay.mp3", waitForCompletion: false))
            
            if self.liveArray.count > 0{
                let liveNode = self.liveArray.first
                liveNode!.removeFromParent()
                self.liveArray.removeFirst()
                
              if self.liveArray.count == 0{
                //moving back to Game scene if game is over
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                
                }
                
            }
        })
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    //overriding the touchesEnded function
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //calling function to fire
       fireTorpedo()
    }
    
    //definition of above called function fuction
    func fireTorpedo() {
        //setting a sound of fire
           self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
           
           let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
           torpedoNode.position = player.position
         //if player fired the alien then 5 scores will be added in player's account
           torpedoNode.position.y += 5
           
           torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
           torpedoNode.physicsBody?.isDynamic = true
           
           torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
           torpedoNode.physicsBody?.contactTestBitMask = alienCategory
           torpedoNode.physicsBody?.collisionBitMask = 0
           torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
           self.addChild(torpedoNode)
           
           let animationDuration:TimeInterval = 0.3
           
           //action array
           var actionArray = [SKAction]()
           
           actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
           actionArray.append(SKAction.removeFromParent())
           
           torpedoNode.run(SKAction.sequence(actionArray))
           
           
           
       }
    
    //didBegin fuction (to know which body is contacting with player )
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
           torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    //fucntion to prodce sound on collision
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
       
          let explosion = SKEmitterNode(fileNamed: "Explosion")!
                  explosion.position = alienNode.position
                  self.addChild(explosion)
                  
                  self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
                  
                  torpedoNode.removeFromParent()
                  alienNode.removeFromParent()
                  
                  
                  self.run(SKAction.wait(forDuration: 2)) {
                      explosion.removeFromParent()
                  }
                  
                  score += 5
           
       }
       //function to simulatePhysics to move the player
       override func didSimulatePhysics() {
           
           player.position.x += xAcceleration * 50
           
           if player.position.x < -20 {
               player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
           }else if player.position.x > self.size.width + 20 {
               player.position = CGPoint(x: -20, y: player.position.y)
           }
           
       }
       
    override func update(_ currentTime: TimeInterval) {
        
    }
}
