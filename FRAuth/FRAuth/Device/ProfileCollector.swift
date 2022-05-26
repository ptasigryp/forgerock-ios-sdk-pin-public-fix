// 
//  ProfileCollector.swift
//  FRAuth
//
//  Copyright (c) 2020-2021 ForgeRock. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//


import Foundation

public class ProfileCollector: DeviceCollector {
    
    public var name: String = "metadata"
    
    /// An array of DeviceCollector to be collected
    public var collectors: [DeviceCollector]
    
    /// Initialization method which initializes default array of ProfileCollector
    public init() {
        collectors = [
            PlatformCollector(),
            HardwareCollector(),
            BrowserCollector(),
            TelephonyCollector(),
            NetworkCollector()
        ]
    }
    
    /// Collects Device Information with all given DeviceCollector
    ///
    /// - Parameter completion: completion block which returns JSON of all Device Collectors' results
    @objc
    public func collect(completion: @escaping DeviceCollectorCallback) {
        
        let dispatchGroup = DispatchGroup()
        let concurrentQueue = DispatchQueue(label: "com.forgerock.isolationQueue", attributes: .concurrent)
        let threadSafe = ConcurrentAtomic(queue: concurrentQueue, dispatchGroup: dispatchGroup)
        for collector in self.collectors {
            dispatchGroup.enter()
            concurrentQueue.async(group: dispatchGroup) {
                collector.collect { (collectedData) in
                    threadSafe.collectAndDispatch(key: collector.name, value: collectedData)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(threadSafe.get())
        }
    }
}


class ConcurrentAtomic {
    
    let isolationQueue: DispatchQueue
    let dispatchGroup: DispatchGroup
    
    var profile: [String: Any] = [:]
    
     init(queue: DispatchQueue = DispatchQueue(label: "com.forgerock.isolationQueue", attributes: .concurrent),
         dispatchGroup: DispatchGroup = DispatchGroup()) {
        self.isolationQueue = queue
        self.dispatchGroup = dispatchGroup
    }
    
    func collectAndDispatch(key: String, value: [String: Any]) {
        isolationQueue.async(group: dispatchGroup, flags: .barrier) { [weak self] in
            if value.keys.count > 0 {
                self?.profile[key] = value
            }
            self?.dispatchGroup.leave()
        }
    }

    func get() -> [String: Any] {
        isolationQueue.sync {[weak self] in
            return self?.profile ?? [:]
        }
    }
}

