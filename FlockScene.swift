//
//  FlockScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class FlockScene: GameScene
{
    struct Constants
    {
        static let separationRadius: Float = 0.553 * 50
        static let separationAngle: Float = 3 * Float.pi / 4.0
        static let separationWeight: Float = 10.0
        
        static let alignmentRadius: Float = 0.83333 * 50.0
        static let alignmentAngle: Float = Float.pi / 4.0
        static let alignmentWeight: Float = 12.66
        
        static let cohesionRadius: Float = 1.0 * 100
        static let cohesionAngle: Float = Float.pi / 2.0
        static let cohesionWeight: Float = 8.66
    }
    
    var flock = [GKAgent2D]()
    var seekGoal: GKGoal?
    
    override var sceneName: String
    {
        return "FLOCKING"
    }
    
    override var isSeeking: Bool
    {
        didSet
        {
            guard let seekGoal = self.seekGoal else { return }
            self.agentSystem?.components.forEach
            { (agent) in
                if isSeeking
                {
                    agent.behavior?.setWeight(1, for: seekGoal)
                }
                else
                {
                    agent.behavior?.setWeight(0, for: seekGoal)
                }
            }
        }
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        
        var agents = [GKAgent2D]()
        let agentsPerRow = 4
        for i in 0 ..< agentsPerRow * agentsPerRow
        {
            let x = self.frame.midX + CGFloat(i % agentsPerRow * 20)
            let y = self.frame.midY + CGFloat(i / agentsPerRow * 20)
            let boid = AgentNode(scene: self, radius: 10, position: CGPoint(x: x, y: y))
            if let component = boid.agent
            {
                self.agentSystem?.addComponent(component)
                agents.append(component)
                boid.drawsTrail = false
            }
            
        }
        self.flock = agents
        
        let behavior = GKBehavior()
        behavior.setWeight(Constants.separationWeight, for: GKGoal(toSeparateFrom: agents, maxDistance: Constants.separationRadius, maxAngle: Constants.separationAngle))
        behavior.setWeight(Constants.alignmentWeight, for: GKGoal(toAlignWith: agents, maxDistance: Constants.alignmentRadius, maxAngle: Constants.alignmentAngle))
        behavior.setWeight(Constants.cohesionWeight, for: GKGoal(toCohereWith: agents, maxDistance: Constants.cohesionRadius, maxAngle: Constants.cohesionAngle))
        for agent in agents
        {
            agent.behavior = behavior
        }
        
        if let seekAgent = self.trackingAgent
        {
            self.seekGoal = GKGoal(toSeekAgent: seekAgent)
        }
    }
}








