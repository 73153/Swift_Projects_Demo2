//
//  GameViewController.swift
//  Match Game
//
//  Created by Gabriel Nica on 14/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {
	
	var level: Level?
	var scene: GameScene?
	
	var movesLeft: UInt = 0
	var score: UInt = 0
	
	@IBOutlet var targetLabel : UILabel
	@IBOutlet var movesLabel : UILabel
	@IBOutlet var scoreLabel : UILabel
	@IBOutlet var gameOverPanel : UIImageView
	@IBOutlet var shuffleButton : UIButton
	
	var backgroundMusic: AVAudioPlayer?
	
	var tapGestureRecogniser: UITapGestureRecognizer?
	

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
					skView.multipleTouchEnabled = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
			
						level = Level(filename: "Level_3")
						scene.level = level
						scene.addGridTiles()
						scene.swipeHandler = {
							(swap: TileSwap) in
							
							self.view.userInteractionEnabled = false
							
							if self.level!.isPossibleSwap(swap)
							{
								self.level!.performSwap(swap)
								self.scene!.animateSwap(swap) {
									self.handleMatches()
								}
							} else {
								self.scene!.animateInvalidSwap(swap) {
									self.view.userInteractionEnabled = true
								}					
							}
							
						}
						
						gameOverPanel.hidden = true
									skView.presentScene(scene)
						self.scene = scene
						
						let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
						backgroundMusic = AVAudioPlayer(contentsOfURL: url, error: nil)
						backgroundMusic!.numberOfLoops = -1
						backgroundMusic!.play()
						
						beginGame()
        }
    }
	
	func beginGame() {
		movesLeft = level!.maximumMoves
		score = 0
		updateLabels()
		level!.resetComboMultiplier()
		
		scene!.animateBeginGame()
		shuffle()
	}
	
	func shuffle()
	{
		scene!.removeAllTileSprites()
		
		let newTiles = level!.shuffle()
		
		scene!.addSprites(newTiles)
	}
	
	func decrementMoves() {
		movesLeft--
		updateLabels()
		
		if score >= level!.targetScore
		{
			gameOverPanel.image = UIImage(named: "LevelComplete")
			showGameOver()
		} else if movesLeft == 0 {
			gameOverPanel.image = UIImage(named: "GameOver")
			showGameOver()
		}
	}
	
	@IBAction func shuffleButtonPressed(sender : UIButton) {
		shuffle()
		decrementMoves()
	}
	
	func handleMatches()
	{
		var chains = level!.removeMatches()
		
		if chains.count == 0 {
			beginNextTurn()
			return
		}
		
		scene!.animateMatchedTiles(chains) {
			for chain in chains
			{
				self.score += chain.score
			}
			self.updateLabels()
			
			let columns = self.level!.fillHoles()
			self.scene!.animateFallingTiles(columns) {
				let newColumns = self.level!.topUpTiles()
				self.scene!.animateNewTiles(newColumns) {
					self.handleMatches()
				}
			}			
		}
	}
	
	func beginNextTurn()
	{
		level!.resetComboMultiplier()
		level!.detectPossibleSwaps()
		view.userInteractionEnabled = true
		decrementMoves()		
	}
	
	func updateLabels()
	{
		targetLabel.text = "\(level!.targetScore)"
		movesLabel.text = "\(movesLeft)"
		scoreLabel.text = "\(score)"
	}
	
	func showGameOver() {
		scene!.animateGameOver()
		gameOverPanel.hidden = false
		scene!.userInteractionEnabled = false
		shuffleButton.hidden = true
		
		tapGestureRecogniser = UITapGestureRecognizer(target: self, action: "hideGameOver")
		view.addGestureRecognizer(tapGestureRecogniser)
	}
	
	func hideGameOver() {
		view.removeGestureRecognizer(tapGestureRecogniser)
		tapGestureRecogniser = nil
		
		gameOverPanel.hidden = true
		scene!.userInteractionEnabled = true
		shuffleButton.hidden = false
		
		beginGame()
	}
	

    override func shouldAutorotate() -> Bool {
        return true
    }
	
	override func prefersStatusBarHidden() -> Bool
	{
		return true
	}

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
