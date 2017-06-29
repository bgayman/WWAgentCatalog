//
//  AgentNode.swift
//  AgentCatalog
//
//  Created by App Partner on 6/28/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

#if os(iOS)
import UIKit
typealias Color = UIColor
#else
import AppKit
typealias Color = NSColor
#endif

final class AgentNode: SKNode
{
    var color: Color?
    {
        didSet
        {
            guard let color = self.color else { return }
            self.triangleShape?.strokeColor = color
        }
    }
    
    var drawsTrail: Bool = false
    {
        didSet
        {
            self.particles?.particleBirthRate = self.drawsTrail ? self.defaultParticleRate : 0.0
        }
    }
    private(set) var agent: GKAgent2D?
    private var triangleShape: SKShapeNode?
    private var particles: SKEmitterNode?
    private var defaultParticleRate: CGFloat = 0.0
    
    init(scene: SKScene, radius: Float, position: CGPoint)
    {
        super.init()
        
        self.position = position
        self.zPosition = 10
        scene.addChild(self)
        
        self.agent = GKAgent2D()
        self.agent?.radius = radius
        self.agent?.position = vector2(Float(position.x), Float(position.y))
        self.agent?.delegate = self
        self.agent?.maxSpeed = 100
        self.agent?.maxAcceleration = 50
        
        let circleShape = SKShapeNode(circleOfRadius: CGFloat(radius))
        circleShape.lineWidth = 2.5
        circleShape.fillColor = Color.gray
        circleShape.zPosition = 1
        self.addChild(circleShape)
        
        let triangleBackSideAngle: CGFloat = (135.0 / 360.0) * (2.0 * CGFloat.pi)
        
        var points = [CGPoint]()
        points.append(CGPoint(x: CGFloat(radius), y: 0.0))
        points.append(CGPoint(x: CGFloat(radius) * cos(triangleBackSideAngle), y: CGFloat(radius) * sin(triangleBackSideAngle)))
        points.append(CGPoint(x: CGFloat(radius) * cos(triangleBackSideAngle), y: -CGFloat(radius) * sin(triangleBackSideAngle)))
        points.append(CGPoint(x: CGFloat(radius), y: 0.0))
        
        self.triangleShape = SKShapeNode(points: &points, count: 4)
        self.triangleShape?.lineWidth = 2.5
        self.triangleShape?.zPosition = 1
        self.addChild(self.triangleShape!)
        
        self.particles = SKEmitterNode(fileNamed: "Trail.sks")
        self.defaultParticleRate = self.particles?.particleBirthRate ?? 0.0
        self.particles?.position = CGPoint(x: -CGFloat(radius + 5), y: 0)
        self.particles?.targetNode = scene
        self.particles?.zPosition = 0
        self.addChild(self.particles!)
    }
    
    private override init()
    {
        fatalError("Use init(scene:, radius:, position:)")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented. Use init(scene:, radius:, position:)")
    }
}

extension AgentNode: GKAgentDelegate
{
    func agentWillUpdate(_ agent: GKAgent)
    {
        // All changes to agents in this app are driven by the agent system, so
        // there's no other changes to pass into the agent system in this method.
    }
    
    func agentDidUpdate(_ agent: GKAgent)
    {
        // Agent and sprite use the same coordinate system (in this app),
        // so just convert vector_float2 position to CGPoint.
        
        guard let agent = agent as? GKAgent2D else { return }
        self.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
        self.zRotation = CGFloat(agent.rotation)
    }
}
