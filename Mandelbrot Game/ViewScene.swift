import SpriteKit

class ViewScene: SKScene, SKPhysicsContactDelegate {
    
    let left = SKSpriteNode(imageNamed: "Circle")
    let right = SKSpriteNode(imageNamed: "Circle")
    let up = SKSpriteNode(imageNamed: "Circle")
    let down = SKSpriteNode(imageNamed: "Circle")
    let zoomIn = SKSpriteNode(imageNamed: "Zoom In")
    let zoomOut = SKSpriteNode(imageNamed: "Zoom Out")
    let exit = SKSpriteNode(imageNamed: "Exit")
    
    var mandel: MandelbrotLayer! = nil
    
    override func didMove(to view: SKView) {
        
        mandel = MandelbrotLayer(withScene: self);
        mandel.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: size.height))
        mandel.create()
        
        left.size = CGSize(width: 150, height: size.height)
        left.position = CGPoint(x: 75, y: size.height/2)
        left.name = "right"
        right.size = CGSize(width: 150, height: size.height)
        right.position = CGPoint(x: size.width - 75, y: size.height/2)
        right.name = "left"
        up.size = CGSize(width: size.width-300, height: 150)
        up.position = CGPoint(x: 150 + (size.width - 300)/2, y: size.height-75)
        up.name = "down"
        down.size = CGSize(width: size.width-300, height: 150)
        down.position = CGPoint(x: 150 + (size.width - 300)/2, y: 75)
        down.name = "up"
        
        (left.alpha, right.alpha, up.alpha, down.alpha) = (0.01,0.01,0.01,0.01)
        
        zoomIn.size = CGSize(width: 70, height: 70)
        zoomIn.position = CGPoint(x: 140, y: 50)
        zoomIn.name = "zoomIn"
        zoomOut.size = CGSize(width: 70, height: 70)
        zoomOut.position = CGPoint(x: 50, y: 50)
        zoomOut.name = "zoomOut"
        
        exit.size = CGSize(width: 70, height: 70)
        exit.position = CGPoint(x: size.width - 50, y: size.height - 50)
        exit.name = "exit"
        
        addChild(left)
        addChild(right)
        addChild(down)
        addChild(up)
        addChild(zoomIn)
        addChild(zoomOut)
        addChild(exit)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == "zoomIn" {
                    mandel.zoomIn(1.5)
                    mandel.redraw()
                } else if name == "zoomOut" {
                    mandel.zoomIn(1.0/1.5)
                    mandel.redraw()
                } else if name == "exit" {
                    let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
                    let menuScene = MenuScene(size: self.size)
                    self.view?.presentScene(menuScene, transition: reveal)
                } else if name == "left" {
                    mandel.moveLeft(50)
                    mandel.redraw()
                }else if name == "right" {
                    mandel.moveRight(50)
                    mandel.redraw()
                }else if name == "up" {
                    mandel.moveUp(50)
                    mandel.redraw()
                }else if name == "down" {
                    mandel.moveDown(50)
                    mandel.redraw()
                }
            }
        }
    }

    
}
