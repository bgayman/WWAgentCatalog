//
//  WindowController.swift
//  AgentCatalog
//
//  Created by App Partner on 6/29/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import Cocoa
import SpriteKit

class WindowController: NSWindowController
{

    @IBOutlet weak var sceneControl: NSSegmentedControl!
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        self.window?.titleVisibility = .hidden
        guard let viewController = self.window?.contentViewController as? ViewController,
              let skView = viewController.view as? SKView else { return }
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        self.didChangeSelection(self.sceneControl)
    }

    @IBAction func didChangeSelection(_ sender: NSSegmentedControl)
    {
        guard let viewController = self.window?.contentViewController as? ViewController,
            let skView = viewController.view as? SKView else { return }
        let scene = GameScene.scene(with: SceneType(rawValue: sender.selectedSegment)!, size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
}
