
//  File: EndScene.swift
//  GAME: SpaceWorld
// Team: Ramandeep, Dalwinder Singh, Vishal Patel

import UIKit
import SpriteKit

class EndScene: SKScene {
    
    // declaration and initialization of variables
    var score : Int = 0
    var scoreLabel : SKLabelNode!
    var newGameButtonNode : SKSpriteNode!
    
    //performing the action on didmove function
    override func didMove(to view: SKView) {
      scoreLabel = self.childNode(withName: "scorelabel") as! SKLabelNode
      scoreLabel.text = "\(score)"
        
       newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
       newGameButtonNode.texture = SKTexture(imageNamed: "newButton")
       
        
    }
    
    //performing the action on when touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //initialize the variable
        let touch = touches.first
        if let location = touch?.location(in: self){
            let node = self.nodes(at: location)
            if node[0].name == "newGameButton"{
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
    
}
