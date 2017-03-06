import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let menuScreen = SKSpriteNode(imageNamed: "Circle")
    let gameMode = SKSpriteNode(imageNamed: "Circle")
    
    init(size: CGSize, score: Int) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let title = "SCORE: \(score)"
        let mainLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        mainLabel.text = title
        mainLabel.fontSize = 40
        mainLabel.fontColor = SKColor.white
        mainLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(mainLabel)
        
        let playAgainText = "PLAY AGAIN"
        let playAgainLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        playAgainLabel.text = playAgainText
        playAgainLabel.fontSize = 25
        playAgainLabel.fontColor = SKColor.white
        playAgainLabel.position = CGPoint(x: size.width * 0.5 + 100, y: size.height * 0.5 - 75)
        addChild(playAgainLabel)
        
        let menuText = "MENU"
        let menuLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        menuLabel.text = menuText
        menuLabel.fontSize = 25
        menuLabel.fontColor = SKColor.white
        menuLabel.position = CGPoint(x: size.width * 0.5 - 100, y: size.height * 0.5 - 75)
        addChild(menuLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameMode.size = CGSize(width: 140, height: 70)
        gameMode.position = CGPoint(x: size.width * 0.5 + 100, y: size.height * 0.5 - 75)
        gameMode.name = "gameMode"
        gameMode.alpha = 0.01
        menuScreen.size = CGSize(width: 140, height: 70)
        menuScreen.position = CGPoint(x: size.width * 0.5 - 100, y: size.height * 0.5 - 75)
        menuScreen.name = "menuScreen"
        menuScreen.alpha = 0.01
        addChild(gameMode)
        addChild(menuScreen)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == "gameMode" {
                    let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                } else if name == "menuScreen" {
                    let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
                    let menuScene = MenuScene(size: self.size)
                    self.view?.presentScene(menuScene, transition: reveal)
                }
            }
        }
    }
}
