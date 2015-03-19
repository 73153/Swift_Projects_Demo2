// Playground - noun: a place where people can play
// Think as below as your Main class, basically the Stage

// this imports higher level APIs like Starling
import Cocoa
import SpriteKit
import XCPlayground

func decodeBase64ToImage(string: String) -> NSImage {
    var data = NSData(base64Encoding: string)
    var image = NSImage(data: data)
    return image
}

let space = 100.0
let fieldWidth = 800.0
let fieldHeight = 800.0

var levelData = [
    "eewwwwwe",
    "wwweeewe",
    "weseweww",
    "weweehew",
    "weeeewew",
    "wwswheew",
    "ewpeewww",
    "ewwwwwee"
]

// our main logic inside this class
class GameScene: SKScene {
    
    // properties initialization
    // note that the spriteNode property below is not initialized
    // we initialize it through the init initializer below
    var playerNode: SKSpriteNode
    var levelNodes: SKSpriteNode[]
    var osci = 0.0
    
    // this is our initializer, called once when the scene is created
    // we do our initialization/setup here
    init(size: CGSize){
        playerNode = SKSpriteNode()
        levelNodes = SKSpriteNode[]()
        var dx = 0.0
        var dy = 0.0
        for line in levelData {
            for var j = 0; j < line.length; j++ {
                var symbol = line.substrFrom(j, len: 1)!
                var entity: NSString
                switch symbol {
                case "e":
                    entity = "empty"
                case "w":
                    entity = "wall"
                case "s":
                    entity = "stone"
                case "h":
                    entity = "hole"
                case "p":
                    entity = "player"
                default:
                    entity = ""
                }
                var propSprite = SKSpriteNode(imageNamed:
                    "/Users/admin/dev/SwiftSokoban/\(entity).png")
                propSprite.anchorPoint = CGPoint(x: 0, y: 0)
                propSprite.position = CGPoint(x:dx, y:dy)
                levelNodes.append(propSprite)
                switch entity {
                case "player":
                    playerNode = propSprite
                default:nil
                }
                dx += space
            }
            dy += space
            dx = 0
        }
        
        // we complete the initialization by initializating the superclass
        super.init(size: size)
    }
    
    // this gets triggered automtically when the scene is presented by the view
    override func didMoveToView(view: SKView) {
        // let's add it to the display list
        for prop in levelNodes {
            self.addChild(prop)
        }
    }
    
    // we override update, which is like an Event.ENTER_FRAME or advanceTime in Starling
    override func update(currentTime: CFTimeInterval) {

    }
}

// we create our scene (from our GameScene above), like a main canvas
let scene = GameScene(size: CGSize(width: fieldWidth, height: fieldHeight))

// we need a view
let view = SKView(frame: NSRect(x: 0, y: 0, width: fieldWidth, height: fieldHeight))

// we link both
view.presentScene(scene)

// display it, XCPShowView is a global function that paints the final scene
XCPShowView("result", view)

