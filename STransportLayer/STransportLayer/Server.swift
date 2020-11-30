//
//  Server.swift
//  STransportLayer
//
//  Created by Vlad on 24.11.2020.
//

import Foundation
import Network

protocol NetworkDelegate {
    func log(message: String)
}

class Server {
    let port: NWEndpoint.Port
    let listener: NWListener
    
    var delegate: NetworkDelegate? {
        didSet {
            for connection in connectionsByID.values {
                connection.delegate = delegate
            }
        }
    }

    private var connectionsByID: [Int: ServerConnection] = [:]

    init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        listener = try! NWListener(using: .tcp, on: self.port)
    }

    func start() throws {
        delegate?.log(message: "Server starting...")
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
        listener.start(queue: .main)
    }

    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            delegate?.log(message: "Server ready.")

        case .failed(let error):
            delegate?.log(message: "Server failure, error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        default:
            break
        }
    }
    
    var count = 0

    private func didAccept(nwConnection: NWConnection) {
        let connection = ServerConnection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        connection.delegate = delegate
        connection.start()
        connection.send(data: "Welcome you are connection \(connection.id)".data(using: .utf8)!)
        delegate?.log(message: "server did open connection \(connection.id)")
    }

    private func connectionDidStop(_ connection: ServerConnection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        delegate?.log(message: "server did close connection \(connection.id)")
    }

    func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.stop()
        }
        self.connectionsByID.removeAll()
    }
    
    
}

//extension Server {
//    func sendNotification(data: Data) {
//        for connection in connectionsByID.values {
//            connection.send(data: data)
//        }
//    }
//    
//    func sendMessage(_ message: String) {
//        sendNotification(data: message.data(using: .utf8)!)
//    }
//}
