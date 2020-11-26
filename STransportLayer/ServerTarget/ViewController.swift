//
//  ViewController.swift
//  ServerTarget
//
//  Created by Vlad on 26.11.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let server = Server(port: 8888)
        try! server.start()
        // Do any additional setup after loading the view.
    }


}

