//
//  ViewController.swift
//  STransportLayer
//
//  Created by Vlad on 24.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let client = Client(host: "localhost", port: 8888)
    
    var previous = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.start()

        client.connection.didReceiveData = { data in
            guard let data = data else {fatalError("Non Int!!!")}
            guard let message = String(data: data, encoding: .utf8) else {fatalError("Non Int!!!")}
            guard let count = Int(message) else {fatalError("Non Int!!!")}
//            if count < self.previous {
//                fatalError("Non Order!!!")
//            }
            self.previous = count
            
        }
    }


}

