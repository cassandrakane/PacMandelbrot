import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var xChange : CGFloat = 0.0
    var yChange : CGFloat = 0.0
    var score : Int = 0
    let marginX : CGFloat = 190
    let marginY : CGFloat = 50
    
    var timerLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
    
    var timerValue: Int = 0 {
        didSet {
            timerLabel.text = "SCORE: \(timerValue)"
        }
    }
    
    let player = SKSpriteNode(imageNamed: "Pacman")
    let monster = SKSpriteNode(imageNamed: "Ghost")
    let left = SKSpriteNode(imageNamed: "Left")
    let right = SKSpriteNode(imageNamed: "Right")
    let up = SKSpriteNode(imageNamed: "Up")
    let down = SKSpriteNode(imageNamed: "Down")
    let zoomIn = SKSpriteNode(imageNamed: "Zoom In")
    let zoomOut = SKSpriteNode(imageNamed: "Zoom Out")
    
    var mandel: MandelbrotLayer! = nil
    
    var dots = [SKSpriteNode]()
    let dotCount = 3;
    
    override func didMove(to view: SKView) {
        
        
        mandel = MandelbrotLayer(withScene: self);
        mandel.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: size.height))
        mandel.create()
        
        timerLabel.fontColor = SKColor.white
        timerLabel.fontSize = 30
        timerLabel.position = CGPoint(x: size.width - 120, y: size.height - 50)
        timerLabel.text = "SCORE: \(timerValue)"
        
        //let timerWait = SKAction.wait(forDuration: 1) //change countdown speed here
        //let timerBlock = SKAction.run({
        //    [unowned self] in
        //        //self.timerValue += 1
        //})
        //let timerSequence = SKAction.sequence([timerWait, timerBlock])
        //run(SKAction.repeatForever(timerSequence))

        let wait = SKAction.wait(forDuration: 0.05) //change countdown speed here
        let block = SKAction.run({
            [unowned self] in
            if !self.checkOutOfBounds() { //shift if it's not out of bounds
                self.player.position.x += self.xChange
                self.player.position.y += self.yChange
            }
        })
        
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence))
        
        player.size = CGSize(width: 30, height: 30)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        player.physicsBody?.affectedByGravity = false
        
        monster.size = CGSize(width: 50, height: 50)
        monster.position = CGPoint(x: size.width * 0.25, y: size.height * 0.25)
        monster.physicsBody = SKPhysicsBody(circleOfRadius: 21)
        monster.physicsBody?.affectedByGravity = false
        player.physicsBody?.contactTestBitMask = 1
        
        spawnMonster()
        
        left.size = CGSize(width: 80, height: 80)
        left.position = CGPoint(x: size.width - 150, y: 100)
        left.name = "left"
        right.size = CGSize(width: 80, height: 80)
        right.position = CGPoint(x: size.width - 50, y: 100)
        right.name = "right"
        up.size = CGSize(width: 80, height: 80)
        up.position = CGPoint(x: size.width - 100, y: 150)
        up.name = "down"
        down.size = CGSize(width: 80, height: 80)
        down.position = CGPoint(x: size.width - 100, y: 50)
        down.name = "up"
        
        zoomIn.size = CGSize(width: 70, height: 70)
        zoomIn.position = CGPoint(x: 140, y: 50)
        zoomIn.name = "zoomIn"
        zoomOut.size = CGSize(width: 70, height: 70)
        zoomOut.position = CGPoint(x: 50, y: 50)
        zoomOut.name = "zoomOut"
        
        addChild(player)
        addChild(monster)
        addChild(left)
        addChild(right)
        addChild(down)
        addChild(up)
        addChild(zoomIn)
        addChild(zoomOut)
        addChild(timerLabel)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(moveMonster),
                SKAction.wait(forDuration: 0.5)
                ])
        ))
        
        self.physicsWorld.contactDelegate = self
        
        for _ in 0..<dotCount{
            let dot = SKSpriteNode(imageNamed: "Coin")
            dot.size = CGSize(width: 10, height: 10)
            
            var pos = CGPoint(x: 0, y: 0)
            while(true){
                pos = CGPoint(x: Int(arc4random())%Int(size.width), y: Int(arc4random())%Int(size.height))
                if(mandel.isInMandy(screenP: pos)){
                    break
                }
            }
            
            dot.position = pos
            addChild(dot)
            dots.append(dot)
        }
    }
    
    
    
    func checkOutOfBounds() -> Bool {
        if(!isPlayerInMandy()) {
            // player loses
            let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
            let gameOverScene = GameOverScene(size: self.size, score: timerValue)
            self.view?.presentScene(gameOverScene, transition: reveal)
            return true
        }
        
        if monster.position.x < -monster.size.height || monster.position.x > size.width + monster.size.height || monster.position.y < -monster.size.height || monster.position.y > size.width + monster.size.height {
            spawnMonster()
        }
        
        
        /*
        for dot in dots {
            if dot.position.x < -10 || dot.position.x > size.width + 10 || dot.position.y < -10 || dot.position.y > size.width + 10 {
                var pos = CGPoint(x: 0, y: 0)
                while(true){
                    pos = CGPoint(x: Int(arc4random())%Int(size.width), y: Int(arc4random())%Int(size.height))
                    if(mandel.isInMandy(screenP: pos)){
                        break
                    }
                }
                dot.position = pos
            }
        }*/
        
        let newX : CGFloat = self.player.position.x + self.xChange
        let newY : CGFloat = self.player.position.y + self.yChange
        if newX < self.marginX {
            shiftBoard("left")
            self.player.position.x = size.width * 0.5
            self.monster.removeAllActions()
            self.monster.position.x += (size.width * 0.5 - self.marginX)
            dots.map({$0.position.x += (size.width * 0.5 - self.marginX)})
            return true
        }
        if newX > size.width - self.marginX {
            shiftBoard("right")
            self.player.position.x = size.width * 0.5
            self.monster.removeAllActions()
            self.monster.position.x -= (size.width * 0.5 - self.marginX)
            dots.map({$0.position.x -= (size.width * 0.5 - self.marginX)})
            return true
        }
        if newY < self.marginY {
            shiftBoard("down")
            self.player.position.y = size.height * 0.5
            self.monster.removeAllActions()
            self.monster.position.y += (size.height * 0.5 - self.marginY)
            dots.map({$0.position.y += (size.height * 0.5 - self.marginY)})
            return true
        }
        if newY > size.height - self.marginY {
            shiftBoard("up")
            self.player.position.y = size.height * 0.5
            self.monster.removeAllActions()
            self.monster.position.y -= (size.height * 0.5 - self.marginY)
            dots.map({$0.position.y -= (size.height * 0.5 - self.marginY)})
            return true
        }
        
        return false
    }
    
    
    func shiftBoard(_ direction: String) {
        if direction == "left" {
            mandel.moveLeft(marginX - size.width * 0.5)
        } else if direction == "right" {
            mandel.moveRight(marginX - size.width * 0.5)
        } else if direction == "up" {
            mandel.moveUp(marginY - size.height * 0.5)
        } else if direction == "down" {
            mandel.moveDown(marginY - size.height * 0.5)
        }
        mandel.redraw()
    }
    
    func getDistance(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist = p2.x - p1.x
        let yDist = p2.y - p1.y
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    func getRadiusPoint(_ pos: CGPoint, dest: CGPoint, radius: CGFloat) -> CGPoint {
        let vx = dest.x - pos.x
        let vy = dest.y - pos.y
        let unitV = getDistance(pos, p2: dest)
        
        let radiusPointX = pos.x + (radius * vx / unitV)
        let radiusPointY = pos.x + (radius * vy / unitV)
        return CGPoint(x: radiusPointX, y: radiusPointY)
    }
    
    func moveMonster() {
        let distance = getDistance(monster.position, p2: player.position)
        let speed = CGFloat(60)
        
        let chase = SKAction.move(to: player.position, duration: TimeInterval(distance/speed))
        monster.run(chase)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBegan(touches, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == "left" {
                    xChange = -7
                    yChange = 0
                    player.texture = SKTexture(imageNamed: "pacman2")
                } else if name == "right" {
                    xChange = 7
                    yChange = 0
                    player.texture = SKTexture(imageNamed: "Pacman")
                } else if name == "up" {
                    xChange = 0
                    yChange = -7
                    player.texture = SKTexture(imageNamed: "pacman4")
                } else if name == "down" {
                    xChange = 0
                    yChange = 7
                    player.texture = SKTexture(imageNamed: "pacman3")
                } else if name == "zoomIn" {
                    let oldP = mandel.fromScreenToPlane(monster.position)
                    let oldPP = mandel.fromScreenToPlane(player.position)
                    
                    var oldDotsP = [CGPoint]()
                    
                    for i in 0..<dots.count {
                        oldDotsP.append(mandel.fromScreenToPlane(dots[i].position))
                    }
                    //dots.map({oldDotsP.append(mandel.fromScreenToPlane($0.position))})
                    
                    
                    let newPoint =  mandel.fromScreenToPlane(CGPoint(x: self.player.position.x, y: self.player.position.y))
                    mandel.virtualCenter = CGPoint(x: -newPoint.x, y: -newPoint.y)
                    
                    mandel.zoomIn(1.5)
                    mandel.redraw()
                    
                    //self.player.position.x = size.width * 0.5
                    //self.player.position.y = size.height * 0.5
                    monster.removeAllActions()
                    monster.position = mandel.fromPlaneToScreen(oldP)
                    player.position = mandel.fromPlaneToScreen(oldPP)
                    
                    for i in 0..<dots.count {
                        dots[i].position = mandel.fromPlaneToScreen(oldDotsP[i])
                    }
                    //var i = 0;
                    //dots.map({$0.position = mandel.fromPlaneToScreen(oldDotsP[i]); i+=1;})
                } else if name == "zoomOut" {
                    let oldP = mandel.fromScreenToPlane(monster.position)
                    let oldPP = mandel.fromScreenToPlane(player.position)
                    
                    var oldDotsP = [CGPoint]()
                    dots.map({oldDotsP.append(mandel.fromScreenToPlane($0.position))})
                    
                    
                    let newPoint =  mandel.fromScreenToPlane(CGPoint(x: self.player.position.x, y: self.player.position.y))
                    mandel.virtualCenter = CGPoint(x: -newPoint.x, y: -newPoint.y)
                    mandel.zoomIn(1.0/1.5)
                    mandel.redraw()
                    
                    //self.player.position.x = size.width * 0.5
                    //self.player.position.y = size.height * 0.5
                    player.position = mandel.fromPlaneToScreen(oldPP)
                    monster.removeAllActions()
                    monster.position = mandel.fromPlaneToScreen(oldP)
                    
                    var i = 0;
                    dots.map({$0.position = mandel.fromPlaneToScreen(oldDotsP[i]); i+=1;})
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        xChange = 0
        yChange = 0
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(hypot(player.position.x - monster.position.x, player.position.y - monster.position.y) <= player.size.height/2 + monster.size.height/2) {
            let reveal = SKTransition.fade(with: UIColor.white, duration: 1.0)
            let gameOverScene = GameOverScene(size: self.size, score: timerValue)
            self.view?.presentScene(gameOverScene, transition: reveal)
            return
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        var hiddenCount = 0
        for dot in dots {
            if( dot.alpha == 1 && hypot(player.position.x - dot.position.x, player.position.y - dot.position.y) <= player.size.height/2 + dot.size.height/2 ) {
                //spawnDot(dot: dot)
                dot.alpha = 0
                timerValue += 1
            }
            if dot.alpha == 0 {
                hiddenCount += 1
            }
        }
        if hiddenCount == dots.count {
            for dot in dots{
                dot.alpha = 1
                spawnDot(dot: dot)
            }
        }
    }
    
    func isPlayerInMandy() -> Bool{
        
        let circleCenter = CGPoint(x: player.position.x, y: player.position.y)
        
        let circleTop = CGPoint(x: player.position.x, y: player.position.y + player.size.height/2)
        
        let circleRight = CGPoint(x: player.position.x  + player.size.width/2, y: player.position.y)
        
        let circleBottom = CGPoint(x: player.position.x, y: player.position.y - player.size.height/2)
        
        let circleLeft = CGPoint(x: player.position.x - player.size.width/2, y: player.position.y)
        
        
        
        if(mandel.isInMandy(screenP: circleCenter)) && (mandel.isInMandy(screenP: circleTop)) && (mandel.isInMandy(screenP: circleRight)) && (mandel.isInMandy(screenP: circleBottom)) && (mandel.isInMandy(screenP: circleLeft)){
            
            return true
            
        } else{
            
            return false
            
        }
        
    }
    
    
    
    func isMonsterInMandy() -> Bool{
        var checkpoints = [CGPoint]()
        let radius = monster.size.width/2
        var angles: [CGFloat] = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0]
        for a in angles {
            let rad = a*CGFloat.pi/180.0
            let checkPoint = CGPoint(x: monster.position.x + cos(rad)*radius,y: monster.position.y + sin(rad)*radius)
            if(!mandel.isInMandy(screenP: checkPoint)){
                return false
            }
        }
        return true
    }
    
    func spawnMonster(){
        monster.removeAllActions()
        
        //find a good position
        var pos = CGPoint(x: 0, y: 0)
        
        while(true){
            pos = CGPoint(x: Int(arc4random())%Int(size.width), y: Int(arc4random())%Int(size.height))
            
            if(hypot(player.position.x - pos.x, player.position.y - pos.y) < player.size.height + monster.size.height){
                continue
            }
            
            monster.position = pos
            
            if(isMonsterInMandy()){
                
                break
                
            }
        }
    }
    
    func spawnDot(dot: SKSpriteNode){
        var pos = CGPoint(x: 0, y: 0)
        while(true){
            pos = CGPoint(x: Int(arc4random())%Int(size.width), y: Int(arc4random())%Int(size.height))
            if(mandel.isInMandy(screenP: pos)){
                break
            }
        }
        dot.position = pos
    }
    
}
