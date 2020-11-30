//
//  ViewController.swift
//  ServerTarget
//
//  Created by Vlad on 26.11.2020.
//

import UIKit
import BoxView

class ViewController: UIViewController {
    
    var boxView = BoxView()
    
    var startButton = UIButton()
    var stopButton = UIButton()
    var logTextView = UITextView()
    
    var count = 0
    
    let server = Server(port: 8888)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBoxItem(boxView.boxed )
        startButton.setTitle("Start Server", for: .normal)
        stopButton.setTitle("Stop Server", for: .normal)
        startButton.heightAnchor.constraint(equalToConstant: 20.0)
        stopButton.heightAnchor.constraint(equalToConstant: 20.0)
        logTextView.backgroundColor = .gray
        boxView.items = [startButton.boxed, stopButton.boxed, logTextView.boxed]
        try! server.start()
    }


}

