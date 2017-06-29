//
//  FleeScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class FleeScene: GameScene
{
    var player: AgentNode?
    var enemy: AgentNode?
    var seekGoal: GKGoal?
    var fleeGoal: GKGoal?
    var isFleeing = false
    {
        didSet
        {
            guard let fleeGoal = self.fleeGoal else { return }
            if isFleeing
            {
                self.enemy?.agent?.behavior?.setWeight(1, for: fleeGoal)
                self.enemy?.agent?.behavior?.setWeight(0, for: stopGoal)
            }
            else
            {
                self.enemy?.agent?.behavior?.setWeight(0, for: fleeGoal)
                self.enemy?.agent?.behavior?.setWeight(1, for: stopGoal)
            }
        }
    }
    
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
                self.player?.agent?.behavior?.setWeight(1, for: seekGoal)
                self.player?.agent?.behavior?.setWeight(0, for: stopGoal)
            }
        }
    }
    
    override var sceneName: String
    {
        return "FLEEING"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        self.player = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX - 150.0, y: self.frame.midY))
        self.player?.agent?.behavior = GKBehavior()
        if let component = self.player?.agent
        {
            self.agentSystem?.addComponent(component)
        }
        
        self.enemy = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX + 150.0, y: self.frame.midY))
        self.enemy?.color = .red
        self.enemy?.agent?.behavior = GKBehavior()
        if let component = self.enemy?.agent
        {
            self.agentSystem?.addComponent(component)
        }
        
        if let seekAgent = self.trackingAgent,
           let fleeAgent = self.player?.agent
        {
            self.seekGoal = GKGoal(toSeekAgent: seekAgent)
            self.fleeGoal = GKGoal(toFleeAgent: fleeAgent)
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        guard let playerPosition = self.player?.agent?.position,
              let enemyPosition = self.enemy?.agent?.position else { return }
        let distance = vector_distance(playerPosition, enemyPosition)
        let maxDistance: Float = 200.0
        self.isFleeing = distance < maxDistance
        super.update(currentTime)
    }
}







