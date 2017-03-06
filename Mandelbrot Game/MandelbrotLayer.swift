//
//  MandelbrotLayer.swift
//  TestScreenDrawer
//
//  Created by Aaron Kaufer on 3/5/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit
import SpriteKit

class MandelbrotLayer: CALayer {

    var increment = CGFloat(5);
    var iterations = 100;
    var pixels : [SKSpriteNode] = [SKSpriteNode]()
    var zoom = CGFloat(200);
    var virtualCenter = CGPoint.zero
    var scene: SKScene;
    
    init(withScene: SKScene) {
        scene = withScene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create(){
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        while(x < bounds.size.width) {
            
            y = CGFloat(0)
            while(y < bounds.size.height) {
                let grad = SKSpriteNode(color: mandelbrot(fromScreenToPlane(CGPoint(x: x, y: y))) , size: CGSize(width: increment, height: increment))
                //grad.frame = CGRectMake(x, y, INCREMENT, INCREMENT)
                //grad.backgroundColor = mandelbrot(fromScreenToPlane(CGPointMake(x, y))).CGColor
                pixels.append(grad)
                //view.layer.insertSublayer(grad, atIndex: 0)
                grad.position = CGPoint(x: x, y: y)
                scene.addChild(grad)
                
                
                y += increment;
            }
            x += increment;
        }
    }
    
    func redraw(){
        for p in pixels {
            let x = p.frame.origin.x
            let y = p.frame.origin.y
            p.color = mandelbrot(fromScreenToPlane(CGPoint(x: x, y: y)));
        }
    }
    
    func mandelbrot(_ p: CGPoint) -> UIColor {
        
        let c = p
        
        if(abs(c.x) < 1 && p.y == 385){
            var d = 6;
            d += 1;
        }
        
        var z = CGPoint.zero
        for i in 0...iterations {
            z = CGPoint(x: z.x*z.x - z.y*z.y + c.x, y: 2 * z.x * z.y + c.y)
            
            if(hypot(z.x, z.y) > 10){
                return iterationsToColor(i);
            }
        }
        return UIColor.black;
        
    }
    
    func iterationsToColor(_ i: Int) -> UIColor{
        let it = CGFloat(i)
        return UIColor(red: sin(it*3), green: ((3*it).truncatingRemainder(dividingBy: 256))/256, blue: ((15*it).truncatingRemainder(dividingBy: 256))/256, alpha: 1);
    }
    
    
    func fromScreenToPlane(_ p: CGPoint) -> CGPoint{
        var new = CGPoint(x: p.x - bounds.size.width/2, y: p.y - bounds.size.height/2)
        new = CGPoint(x: new.x/zoom, y: new.y/zoom)
        new = CGPoint(x: new.x - virtualCenter.x, y: new.y - virtualCenter.y)
        return new
    }
    
    func fromPlaneToScreen(_ p: CGPoint) -> CGPoint{
        var new = CGPoint(x: p.x + virtualCenter.x, y: p.y + virtualCenter.y)
        new = CGPoint(x: new.x*zoom, y: new.y*zoom)
        new = CGPoint(x: new.x + bounds.size.width/2, y: new.y + bounds.size.height/2)
        return new
    }
    
    func moveRight(_ amount: CGFloat){
        virtualCenter = CGPoint(x: virtualCenter.x + amount/zoom, y: virtualCenter.y)
        
    }
    func moveLeft (_ amount: CGFloat){
        virtualCenter = CGPoint(x: virtualCenter.x - amount/zoom, y: virtualCenter.y)
        
    }
    func moveUp (_ amount: CGFloat){
        virtualCenter = CGPoint(x: virtualCenter.x , y: virtualCenter.y + amount/zoom)
        
    }
    func moveDown (_ amount: CGFloat){
        virtualCenter = CGPoint(x: virtualCenter.x, y: virtualCenter.y - amount/zoom)
        
    }
    func zoomIn (_ factor: CGFloat){
        zoom *= factor;
    }
    
    func isInMandy(screenP: CGPoint) -> Bool{
        return (mandelbrot(fromScreenToPlane(screenP)) == UIColor.black)
    }

}
