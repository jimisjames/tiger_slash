//
//  ViewController.swift
//  tigerClaw
//
//  Created by DLM on 11/1/18.
//  Copyright © 2018 DLM. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
enum GamePhase{
    case Ready
    case InPlay
}

class ViewController: UIViewController {
    var motionManager: CMMotionManager?
    
    var musicEffect : AVAudioPlayer = AVAudioPlayer()
    var fruitTimer = Timer()
    var gamephase = GamePhase.Ready
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        fruitTimer.invalidate()
        let alert = UIAlertController(title: "Paused", message: "In waking a tiger, use a long stick. - Mao Zedong", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Menu", style: .default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "menu", sender: nil)
        })
        alert.addAction(UIAlertAction(title: "Play", style: .cancel, handler: { (_) in self.openGame()}))
        
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var greenSlash: UIImageView!
    
    @IBOutlet weak var yellowSlash: UIImageView!
    
    @IBOutlet weak var redSlash: UIImageView!
    
    
    let picTitles = [
        "scratchOne",
        "scratchTwo",
        "scratchThree",
        "scratchFour",
        "scratchFive",
        "scratchSix"
    ]
    
    let explosionTitles = [
        "explosion 1",
        "explosion 2",
        "explosion 3",
        "explosion 4",
        "explosion 5",
        "explosion 6",
        "explosion 7",
        "explosion 8",
        "explosion 9",
    ]
    
    func animateFruit (_ img: UILabel){
        var runCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            img.isHidden = false
            let pic = String(self.explosionTitles[runCount])
            let y = UIImage(named: pic)!
            img.backgroundColor = UIColor(patternImage: y)
            runCount += 1
            
            if runCount >= self.picTitles.count {
                timer.invalidate()
                img.isHidden = true
                img.backgroundColor = nil
            }
        }
        
    }
    func animateIt (_ img: UIImageView){
        var runCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            img.isHidden = false
            let pic = String(self.picTitles[runCount])
            img.image = UIImage(named: pic)
            runCount += 1
            
            if runCount >= self.picTitles.count {
                timer.invalidate()
                img.isHidden = true
                img.image = nil
            }
        }
        
    }
    
    var tigerMusic:AVAudioPlayer?
    
    override func viewDidLoad() {
        //fruit falling
        performSegue(withIdentifier: "menu", sender: nil)
        if gamephase == .Ready {
            gamephase = .InPlay
            openGame()
        }
        let musicFile = Bundle.main.path(forResource: "Coding Dojo", ofType: ".m4a")
        let tigerMusic = Bundle.main.path(forResource: "tiger_drums", ofType: ".mp3")
        do {
            try self.musicEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
            try self.tigerMusic = AVAudioPlayer(contentsOf: URL (fileURLWithPath: tigerMusic!))
        }
        catch  {
            print("error")
        }
        self.tigerMusic?.play()
        
        
        
        super.viewDidLoad()
        motionManager = CMMotionManager()
        if let manager = motionManager {
            if manager.isAccelerometerAvailable {
                let myq = OperationQueue()
                manager.accelerometerUpdateInterval = 1.0 / 60.0
                manager.startAccelerometerUpdates(to: myq, withHandler: {
                    (data: CMAccelerometerData?, error:Error?) in
                if let data = self.motionManager?.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    if abs(x) + abs(y) + abs(z) >= 10 {
                        
                        guard let fruit = self.fruit else {
                            return
                        }

                        if fruit.frame.origin.y + fruit.bounds.size.height > 300 && fruit.frame.origin.y < 320 {
                            print("GREEN GREEN GREEN GREEN")
                            print(fruit.frame.origin.y)
                            print(fruit.bounds.size.height)
                            DispatchQueue.main.async(){
                                
                                self.greenSlash.frame.origin.x = fruit.frame.origin.x - 60
                                //fruit.isHidden = true
                                self.animateFruit(self.fruit!)
                                self.animateIt(self.greenSlash)
                                
                             
                                self.musicEffect.play()
                                
                            }
                        } else if fruit.frame.origin.y + fruit.bounds.size.height > 600 && fruit.frame.origin.y < 650 {
                            print("YELLOW YELLOW YELLOW YELLOW")
                            print(fruit.frame.origin.y)
                            print(fruit.bounds.size.height)
                            DispatchQueue.main.async(){
                                self.yellowSlash.frame.origin.x = fruit.frame.origin.x - 60
                                self.animateFruit(self.fruit!)
                                self.animateIt(self.yellowSlash)
                                self.musicEffect.play()
                            
                            }
                        } else if fruit.frame.origin.y + fruit.bounds.size.height > 800 && fruit.frame.origin.y < 1000 {
                            print("RED RED RED RED RED RED")
                            print(fruit.frame.origin.y)
                            print(fruit.bounds.size.height)
                            DispatchQueue.main.async(){
                                self.redSlash.frame.origin.x = fruit.frame.origin.x - 60
                                self.animateFruit(self.fruit!)
                                self.animateIt(self.redSlash)
                                self.musicEffect.play()
                               
                            }
                        }
                    }
                    DispatchQueue.main.async(){
                    }
                    }
                    else {
                        print("error")
                        // present error message
                        manager.stopDeviceMotionUpdates()
                    }
                }
            )
            }
            
        }
    }
    
    
    
    
   
    var fruitImageArray = [
        "fruity 1",
        "fruity 2",
        "fruity 3",
        "fruity 4",
        "fruity 5",
        "fruity 6",
        "fruity 7",
        "fruity 8",
        "fruity 9",
        "fruity 10"
    ]
    
    
   
    
    var fruitCount = 0
    
    func openGame() {
        
        fruitTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: {_ in
            if self.fruitCount < self.fruitImageArray.count - 1 {
                self.fruitCount += 1
            }
            else {
                self.fruitCount = 0
            }
            self.createFruits()})
        
    }
    
    var image_org_frame: CGRect?
    
    var fruit:UILabel?
    var gameOver = 0
    
    func createFruits() {
//        if gameOver >= 10 {
//            performSegue(withIdentifier: "gameOver", sender: nil)
//            self.gameOver = 0
//        }
//        gameOver += 1
        let xSize = Int.random(in: 10...320)
        fruit = UILabel(frame: CGRect(x: xSize,y:25,width:60,height:60))
        greenSquare = fruit
        //greenSquare?.backgroundColor = UIColor.green
        //let x = String(self.fruitImageArray[self.fruitCount])
        let y = UIImage(named: "fruity 1")!
        //square.backgroundColor = UIColor(patternImage: y)
        greenSquare?.backgroundColor = UIColor(patternImage: y)
        
        
//        dimen = UILabel(frame: CGRect(x:130,y:25,width:90,height:90))
//        redSquare = dimen
//        redSquare?.backgroundColor = UIColor.red
        
        
        self.view.addSubview(greenSquare!)
      
        
//        self.view.addSubview(redSquare!)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //add gravity
        let gravity = UIGravityBehavior(items:[greenSquare!])
        let direction = CGVector(dx:0.0, dy:1.0)
        gravity.gravityDirection = direction
        
        let boundries = UICollisionBehavior(items: [greenSquare!])
        boundries.translatesReferenceBoundsIntoBoundary = true
        
        let bounce = UIDynamicItemBehavior(items: [greenSquare!])
        bounce.elasticity = 0.4
        
        //        animator?.addBehavior(bounce)
        //        animator?.addBehavior(boundries)
        animator?.addBehavior(gravity)
        
        //let musicFile = Bundle.main.path(forResource: "Coding Dojo", ofType: ".m4a")
        
        //do {
            //try musicEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
        //}
        //catch  {
        //    print("error")
        //}
        //musicEffect.play()
    }
    
    
    var greenSquare: UIView?
    
    var animator: UIDynamicAnimator?

}
