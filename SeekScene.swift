//
//  SeekScene.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import SpriteKit
import GameplayKit

final class SeekScene: GameScene
{
    var player: AgentNode?
    var seekGoal: GKGoal?
    override var sceneName: String
    {
        return "SEEKING"
    }
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        self.player = AgentNode(scene: self, radius: DefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.player?.agent?.behavior = GKBehavior()
        self.agentSystem?.addComponent(self.player!.agent!)
        
        self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent!)
        
    }
    
    override var isSeeking: Bool
    {
        didSet
        {
            if isSeeking
            {
                self.player?.agent?.behavior?.setWeight(1, for: self.seekGoal!)
                self.player?.agent?.behavior?.setWeight(0, for: self.stopGoal)
            }
            else
            {
                self.player?.agent?.behavior?.setWeight(0, for: self.seekGoal!)
                self.player?.agent?.behavior?.setWeight(1, for: self.stopGoal)
            }
        }
    }
    
}
