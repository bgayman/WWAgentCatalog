//
//  PathScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class PathScene: GameScene
{
    override var sceneName: String
    {
        return "FOLLOW PATH"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        let follower = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        follower.color = .cyan
        let center = vector2(Float(self.frame.midX), Float(self.frame.midY))
        
        let points = [
            vector2(center.x, center.y + 50),
            vector2(center.x + 50, center.y + 150),
            vector2(center.x + 100, center.y + 150),
            vector2(center.x + 200, center.y + 200),
            vector2(center.x + 350, center.y + 150),
            vector2(center.x + 300, center.y),
            vector2(center.x, center.y - 200),
            vector2(center.x - 200, center.y - 100),
            vector2(center.x - 200, center.y),
            vector2(center.x - 100, center.y + 50)
        ]
        
        let path = GKPath(points: points, radius: DefaultAgentRadius, cyclical: true)
        
        follower.agent?.behavior = GKBehavior(goal: GKGoal(toFollow: path, maxPredictionTime: 1.5, forward: true), weight: 1)
        
        if let component = follower.agent
        {
            self.agentSystem?.addComponent(component)
        }
        
        var cgPoints = points.map { CGPoint(x: CGFloat($0.x), y: CGFloat($0.y)) }
        cgPoints.append(CGPoint(x: CGFloat(points[0].x), y: CGFloat(points[0].y)))
        let pathShape = SKShapeNode(points: &cgPoints, count: 11)
        pathShape.lineWidth = 2
        pathShape.strokeColor = .magenta
        self.addChild(pathShape)
    }
}






