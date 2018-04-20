//
//  ViewController.swift
//  DrawAndRec
//
//  Created by punyawee  on 20/4/61.
//  Copyright © พ.ศ. 2561 punyawee . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        self.canvasView.clearCanvas()
    }

}

