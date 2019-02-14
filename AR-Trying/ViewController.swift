//
//  ViewController.swift
//  AR-Trying
//
//  Created by Sven Schöni on 13.02.19.
//  Copyright © 2019 Sven Schoeni. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(config)
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pov = sceneView.pointOfView else {return}
        let transform = pov.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let cameraPosition =  SCNVector3(transform.m41,transform.m42,transform.m43)
        
        let currentCameraPosition = orientation + cameraPosition
        DispatchQueue.main.async {
            if self.draw.isHighlighted{
                let spehereNode  = SCNNode(geometry: SCNSphere(radius: 0.02))
                spehereNode.position = currentCameraPosition
                self.sceneView.scene.rootNode.addChildNode(spehereNode)
                spehereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            }
            else{
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.02))
                pointer.name = "pointer"
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                pointer.position = currentCameraPosition
                self.sceneView.scene.rootNode.enumerateChildNodes({
                    (node,_) in
                    if node.name == "pointer"{
                          node.removeFromParentNode()
                    }
                  
                    
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
        
    }

}

func +(left:SCNVector3,right:SCNVector3)->SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y+right.y, left.z+right.z)
}


