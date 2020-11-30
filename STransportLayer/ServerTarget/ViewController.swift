//
//  ViewController.swift
//  ServerTarget
//
//  Created by Vlad on 26.11.2020.
//

import UIKit
import BoxView

class ViewController: UIViewController, NetworkDelegate {
    
    var boxView = BoxView()
    
    var startButton = UIButton()
    var stopButton = UIButton()
    var logTextView = UITextView()
    
    var count = 0
    
    let server = Server(port: 8888)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addBoxItem(boxView.boxed.top(100.0))
        boxView.spacing = 10.0
        
        startButton.addTarget(self, action: #selector(startServer), for: .touchUpInside)
        startButton.backgroundColor = .green
        startButton.setTitle("Start Server", for: .normal)
        startButton.heightAnchor.constraint(equalToConstant: 20.0)
        
        stopButton.addTarget(self, action: #selector(stopServer), for: .touchUpInside)
        stopButton.backgroundColor = .red
        stopButton.setTitle("Stop Server", for: .normal)
        stopButton.heightAnchor.constraint(equalToConstant: 20.0)
        
        logTextView.backgroundColor = .gray
        logTextView.isUserInteractionEnabled = false
        boxView.items = [startButton.boxed, stopButton.boxed, logTextView.boxed]
        
    }
    
    func log(message: String) {
        logTextView.text.append("\n")
        logTextView.text.append(message)
    }
    
    @objc func startServer() {
        try! server.start()
    }
    
    @objc func stopServer() {
        server.stop()
    }


}

