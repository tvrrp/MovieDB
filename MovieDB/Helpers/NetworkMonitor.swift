//
//  NetworkMonitor.swift
//  MovieDB
//
//  Created by Damir Yackupov on 14.03.2022.
//

import Network

protocol NetworkCheckObserver: class {
    func statusDidChange(status: NWPath.Status)
}

class NetworkMonitor {

    struct NetworkChangeObservation {
        weak var observer: NetworkCheckObserver?
    }

    private static let shared = NetworkMonitor()
    private var monitor = NWPathMonitor()
    
    private var observations = [ObjectIdentifier: NetworkChangeObservation]()
    var currentStatus: NWPath.Status {
        get {
            return monitor.currentPath.status
        }
    }

    class func sharedInstance() -> NetworkMonitor {
        return shared
    }

    init() {
        monitor.pathUpdateHandler = { [unowned self] path in
            for (id, observations) in self.observations {

                //If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }

                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(status: path.status)
                })
            }
        }
    }
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    func addObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = NetworkChangeObservation(observer: observer)
    }

    func removeObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

}
