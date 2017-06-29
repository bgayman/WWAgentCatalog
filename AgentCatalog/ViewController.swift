//
//  ViewController.swift
//  AgentCatalog
//
//  Created by App Partner on 6/28/17.
//  Copyright © 2017 App Partner. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    private var sceneType = SceneType.seek

    override func viewDidLoad()
    {
        super.viewDidLoad()
        guard let skView = self.view as? SKView else { return }
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.selectScene(self.sceneType)
    }

    func selectScene(_ sceneType: SceneType)
    {
        let scene = GameScene.scene(with: sceneType, size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        guard let skView = self.view as? SKView else { return }
        skView.presentScene(scene)
        self.navigationItem.title = scene.sceneName
    }

    @IBAction func goToPreviousScene(_ sender: UIBarButtonItem)
    {
        if sceneType.rawValue - 1 < 0
        {
            self.sceneType = .path
        }
        else
        {
            self.sceneType = SceneType(rawValue: sceneType.rawValue - 1)!
        }
        self.selectScene(self.sceneType)
    }

    @IBAction func goToNextScene(_ sender: UIBarButtonItem)
    {
        if sceneType == .path
        {
            self.sceneType = .seek
        }
        else
        {
            self.sceneType = SceneType(rawValue: sceneType.rawValue + 1)!
        }
        self.selectScene(self.sceneType)
    }
}

