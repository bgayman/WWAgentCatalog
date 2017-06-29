//
//  AlignScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class AlignScene: GameScene
{
    var player: AgentNode?
    var friends = [AgentNode]()
    var alignGoal: GKGoal?
    var seekGoal: GKGoal?
    
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
                    agent.behavior?.setWeight(0, for: stopGoal)
                }
                else
                {
                    agent.behavior?.setWeight(0, for: seekGoal)
                    agent.behavior?.setWeight(1, for: stopGoal)
                }
            }
        }
    }
    
    override var sceneName: String
    {
        return "ALIGNMENT"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        
        self.player = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.player?.agent?.behavior = GKBehavior()
        if let component = self.player?.agent
        {
            self.agentSystem?.addComponent(component)
        }
        self.player?.agent?.maxSpeed *= 1.2
        
        if let agent = self.player?.agent,
           let trackingAgent = self.trackingAgent
        {
            self.seekGoal = GKGoal(toSeekAgent: trackingAgent)
            self.alignGoal = GKGoal(toAlignWith: [agent], maxDistance: 100, maxAngle: Float.pi * 2)
            let behavior = GKBehavior(goal: self.alignGoal!, weight: 100)
            
            let points = [CGPoint(x: self.frame.midX - 150.0, y: self.frame.midY),
                          CGPoint(x: self.frame.midX + 150.0, y: self.frame.midY)]
            
            self.friends = points.map { self.addFriend(at: $0) }
            for friend in self.friends
            {
                friend.agent?.behavior = behavior
            }
        }
        
        
    }
    
    func addFriend(at point: CGPoint) -> AgentNode
    {
        let friend = AgentNode(scene: self, radius: DefaultAgentRadius, position: point)
        friend.color = .cyan
        if let component = friend.agent
        {
            self.agentSystem?.addComponent(component)
        }
        return friend
    }
}
