//
//  ClientConnection.swift
//  STransportLayer
//
//  Created by Vlad on 24.11.2020.
//

import Foundation
import Network

class ClientConnection {
    
    var queueName = "default"

    let nwConnection: NWConnection
    let queue: DispatchQueue

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        switch nwConnection.endpoint {
            case .hostPort(host: let host, port: let port):
                self.queueName = "\(host) \(port) connection"
            default:
                break
        }
        queue = DispatchQueue(label: queueName)
    }

    var didStopCallback: ((Error?) -> Void)? = nil
    
    var didReceiveData:((Data?) -> Void)? = nil

    func start() {
        print("connection will start")
        nwConnection.stateUpdateHandler = stateDidChange(to:)
        setupReceive()
        nwConnection.start(queue: queue)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            print("Client connection ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        nwConnection.receiveMessage { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                print("isComplete: \(isComplete)")
//                if let block = self.didReceiveData
//                {
//                    block(data)
//                }
                let message = String(data: data, encoding: .utf8)
                print("connection did receive, data: \(data as NSData) string: \(message ?? "-" )")
            }
//            if isComplete {
////                self.connectionDidEnd()
//            }
//            else
            if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }

    func send(data: Data) {
        nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
                print("connection did send, data: \(data as NSData)")
        }))
    }

    func stop() {
        print("connection will stop")
        stop(error: nil)
    }

    private func connectionDidFail(error: Error) {
        print("connection did fail, error: \(error)")
        self.stop(error: error)
    }

    private func connectionDidEnd() {
        print("connection did end")
//        self.stop(error: nil)
    }

    private func stop(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
