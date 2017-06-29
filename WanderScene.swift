//
//  WanderScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class WanderScene: GameScene
{
    override var sceneName: String
    {
        return "WANDERING"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        let wanderer = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        wanderer.color = .cyan
        
        wanderer.agent?.behavior = GKBehavior(goal: GKGoal(toWander: 10), weight: 100)
        if let component = wanderer.agent
        {
            self.agentSystem?.addComponent(component)
        }
    }
}
