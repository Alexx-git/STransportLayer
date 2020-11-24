//
//  ViewController.swift
//  STransportLayer
//
//  Created by Vlad on 24.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
//    let button = UIButton()
//
//    let textField = UITextField()

    let client = Client(host: "localhost", port: 8888)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.addSubview(button)
//        button.center = view.center
//        button.frame.size = CGSize(width: 40.0, height: 40.0)
//        button.frame.origin.y += 50
//        button.backgroundColor = .red
//        view.addSubview(textField)
//        textField.center = view.center
//        textField.frame.size.width = 100.0
//        textField.frame.origin.y -= 50
//        textField.borderStyle = .roundedRect
//        textField.backgroundColor = .gray
        client.start()
//        button.addTarget(self, action: #selector(send), for: .touchUpInside)
        let text = "Hi!"
        client.send(data: text .data(using: .utf8)!)
    }

//    @objc func send() {
//        guard let text = textField.text else {return}
//        client.send(data: text .data(using: .utf8)!)
//    }

}

