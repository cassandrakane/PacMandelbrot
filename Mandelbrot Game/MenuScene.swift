import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let gameMode = SKSpriteNode(imageNamed: "Circle")
    let viewMode = SKSpriteNode(imageNamed: "Circle")
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let title = "PACMANDELBROT"
        let label = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        label.text = title
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: 3 * size.height/4)
        addChild(label)
        
        let gameText = "PLAY"
        let gameLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        gameLabel.text = gameText
        gameLabel.fontSize = 25
        gameLabel.fontColor = SKColor.white
        gameLabel.position = CGPoint(x: size.width * 0.5 + 100, y: size.height * 0.5 + 20)
        addChild(gameLabel)
        
        let viewText = "VIEW"
        let viewLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        viewLabel.text = viewText
        viewLabel.fontSize = 25
        viewLabel.fontColor = SKColor.white
        viewLabel.position = CGPoint(x: size.width * 0.5 - 100, y: size.height * 0.5 + 20)
        addChild(viewLabel)
        
        var iconTexture : SKTexture = SKTexture(imageNamed: "Pacmandelbrot")
        iconTexture.filteringMode = .nearest
        let icon = SKSpriteNode(texture: iconTexture)
        icon.size = CGSize(width: 250, height: 250)
        icon.position = CGPoint(x: size.width * 0.15, y: 20)
        addChild(icon)
        
        var iconTexture2 : SKTexture = SKTexture(imageNamed: "Pacmandelbrot2")
        iconTexture2.filteringMode = .nearest
        let icon2 = SKSpriteNode(texture: iconTexture2)
        icon2.size = CGSize(width: 250, height: 250)
        icon2.position = CGPoint(x: size.width - size.width * 0.15, y: 30)
        addChild(icon2)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameMode.size = CGSize(width: 140, height: 70)
        gameMode.position = CGPoint(x: size.width * 0.5 + 100, y: size.height * 0.5 + 20)
        gameMode.name = "gameMode"
        gameMode.alpha = 0.01
        viewMode.size = CGSize(width: 140, height: 70)
        viewMode.position = CGPoint(x: size.width * 0.5 - 100, y: size.height * 0.5 + 20)
        viewMode.name = "viewMode"
        viewMode.alpha = 0.01
        addChild(gameMode)
        addChild(viewMode)
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
                } else if name == "viewMode" {
                    let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
                    let viewScene = ViewScene(size: self.size)
                    self.view?.presentScene(viewScene, transition: reveal)
                }
            }
        }
    }
}
