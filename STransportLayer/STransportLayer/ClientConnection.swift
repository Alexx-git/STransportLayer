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
    
    var delegate: NetworkDelegate?

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
        delegate?.log(message: "connection will start")
        nwConnection.stateUpdateHandler = stateDidChange(to:)
        setupReceive()
        nwConnection.start(queue: queue)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            delegate?.log(message: "Client connection ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        nwConnection.receiveMessage { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                delegate?.log(message: "isComplete: \(isComplete)")
//                if let block = self.didReceiveData
//                {
//                    block(data)
//                }
                let message = String(data: data, encoding: .utf8)
                delegate?.log(message: "connection did receive, data: \(data as NSData) string: \(message ?? "-" )")
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
                delegate?.log(message: "connection did send, data: \(data as NSData)")
        }))
    }

    func stop() {
        delegate?.log(message: "connection will stop")
        stop(error: nil)
    }

    private func connectionDidFail(error: Error) {
        delegate?.log(message: "connection did fail, error: \(error)")
        self.stop(error: error)
    }

    private func connectionDidEnd() {
        delegate?.log(message: "connection did end")
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
