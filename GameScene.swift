//
//  GameScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SceneType: Int
{
    case seek
    case wander
    case flee
    case avoid
    case separate
    case align
    case flock
    case path
    
}

class GameScene: SKScene
{
    let DefaultAgentRadius: Float = 40.0
    var sceneName: String
    {
        return "DEFAULT"
    }
    private(set) var agentSystem: GKComponentSystem<GKAgent2D>?
    private(set) var trackingAgent: GKAgent2D?
    var lastUpdateTime: TimeInterval = 0.0
    var isSeeking: Bool = false
    
    private(set) lazy var stopGoal: GKGoal =
    {
        return GKGoal(toReachTargetSpeed: 0)
    }()
    
    static func scene(with sceneType: SceneType, size: CGSize) -> GameScene
    {
        switch sceneType
        {
        case .seek:
            return SeekScene(size: size)
        case .wander:
            return WanderScene(size: size)
        case .flee:
            return FleeScene(size: size)
        case .avoid:
            return AvoidScene(size: size)
        case .separate:
            return SeparateScene(size: size)
        case .align:
            return AlignScene(size: size)
        case .flock:
            return FlockScene(size: size)
        case .path:
            return PathScene(size: size)
        }
    }
    
    override func didMove(to view: SKView)
    {
        #if !os(iOS)
            let fontName = NSFont.systemFont(ofSize: 65).fontName
            let label = SKLabelNode(fontNamed: fontName)
            label.text = self.sceneName
            label.fontSize = 65
            label.horizontalAlignmentMode = .left
            label.verticalAlignmentMode = .top
            label.position = CGPoint(x: self.frame.minX + 10, y: self.frame.maxY - 46)
            self.addChild(label)
        #endif
        self.agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        self.trackingAgent = GKAgent2D()
        self.trackingAgent?.position = vector2(Float(self.frame.midX), Float(self.frame.midY))
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if lastUpdateTime == 0.0
        {
            lastUpdateTime = currentTime
        }
        
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        self.agentSystem?.update(deltaTime: delta)
    }
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isSeeking = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isSeeking = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isSeeking = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        self.trackingAgent?.position = vector2(Float(position.x), Float(position.y))
    }
    
    #else
    override func mouseDown(with event: NSEvent)
    {
        self.isSeeking = true
    }
    
    override func mouseUp(with event: NSEvent)
    {
        self.isSeeking = false
    }
    
    override func mouseDragged(with event: NSEvent)
    {
        let position = event.location(in: self)
        self.trackingAgent?.position = vector2(Float(position.x), Float(position.y))
    }
    #endif
}










