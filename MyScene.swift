
//  File: MyScene.swift
//  GAME: SpaceWorld
// Team: Ramandeep, Dalwinder Singh, Vishal Patel


import SpriteKit

class MyScene: SKScene {
    //decaring all variables
    var starfield:SKEmitterNode!
    var newgamebutton:SKSpriteNode!
    var difficultyButton:SKSpriteNode!
    var difficultyLabel:SKLabelNode!

    //overriding the didMove function
    override func didMove(to view: SKView) {
        starfield = self.childNode(withName: "starfield") as! SKEmitterNode
        starfield.advanceSimulationTime(10)
        
        newgamebutton = self.childNode(withName: "newButtton") as! SKSpriteNode
        
        difficultyButton = self.childNode(withName: "difficultyButton") as! SKSpriteNode
        
        difficultyButton.texture = SKTexture(imageNamed: "difficutyButton")

        difficultyLabel = self.childNode(withName: "difficultylabel") as! SKLabelNode
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hard")
        {
            difficultyLabel.text = "Hard"
        }else{
            difficultyLabel.text = "Easy"
        }
    }
    //overriding the touchesbegan function to perform action when user touchs the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newButtton"{
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            
            else if nodesArray.first?.name == "difficultyButton"{
                changeDifficulty()
            }
        }
    }
    
    //function to change the difficulty level of game time to time from easy to hard
    func  changeDifficulty() {
        let userDefaults = UserDefaults.standard
        
        if difficultyLabel.text == "Easy"{
            difficultyLabel.text == "Hard"
            userDefaults.set(true, forKey: "hard")
        }else{
            difficultyLabel.text == "Easy"
            userDefaults.set(false, forKey: "hard")
        }
        
        userDefaults.synchronize()
    }
}
