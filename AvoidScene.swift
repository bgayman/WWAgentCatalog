//
//  AvoidScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class AvoidScene: GameScene
{
    var player: AgentNode?
    var seekGoal: GKGoal?
    
    override var isSeeking: Bool
    {
        didSet
        {
            guard let seekGoal = self.seekGoal else { return }
            if isSeeking
            {
                self.player?.agent?.behavior?.setWeight(1, for: seekGoal)
                self.player?.agent?.behavior?.setWeight(0, for: stopGoal)
            }
            else
            {
                self.player?.agent?.behavior?.setWeight(0, for: seekGoal)
                self.player?.agent?.behavior?.setWeight(1, for: stopGoal)
            }
        }
    }
    
    override var sceneName: String
    {
        return "AVOID OBSTACLES"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        
        let obstacles: [GKObstacle] = [
            self.addObstacle(at: CGPoint(x: self.frame.midX, y: self.frame.midY + 150.0)),
            self.addObstacle(at: CGPoint(x: self.frame.midX - 200, y: self.frame.midY - 150.0)),
            self.addObstacle(at: CGPoint(x: self.frame.midX + 200, y: self.frame.midY - 150.0))
        ]
        
        self.player = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.player?.agent?.behavior = GKBehavior()
        if let component = self.player?.agent,
           let seekAgent = self.trackingAgent
        {
            self.agentSystem?.addComponent(component)
            self.seekGoal = GKGoal(toSeekAgent: seekAgent)
        }
        self.player?.agent?.behavior?.setWeight(100, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 1))
    }
    
    func addObstacle(at point: CGPoint) -> GKObstacle
    {
        let circleShape = SKShapeNode(circleOfRadius: CGFloat(DefaultAgentRadius))
        circleShape.lineWidth = 2.5
        circleShape.fillColor = .gray
        circleShape.strokeColor = .red
        circleShape.zPosition = 1
        circleShape.position = point
        self.addChild(circleShape)
        
        let obstacle = GKCircleObstacle(radius: DefaultAgentRadius)
        obstacle.position = vector2(Float(point.x), Float(point.y))
        
        return obstacle
    }
}
