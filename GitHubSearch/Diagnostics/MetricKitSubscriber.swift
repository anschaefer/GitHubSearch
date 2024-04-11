//
//  MetricKitSubscriber.swift
//  GitHubSearch
//
//  Created by André Schäfer on 10.04.24.
//

import MetricKit

class MetricKitSubscriber: NSObject, MXMetricManagerSubscriber {
    
    var metricManager: MXMetricManager?
    
    override init() {
        super.init()
        
        metricManager = MXMetricManager.shared
        metricManager?.add(self)
    }
    
    deinit {
        metricManager?.remove(self)
    }
    
    func didReceive(_ payloads: [MXMetricPayload]) {
        // 24h aggregated payload
        
        payloads.forEach { payload in
            print("MetricPayload: \(payload.dictionaryRepresentation())")}
        
        // Where to go from here?
        // send json to e.g. monitoring server
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        // immediate diagnostic payload
        
        payloads.forEach { payload in
            print("DiagnosticPayload: \(payload.dictionaryRepresentation())")}
        
        // Where to go from here?
        // send json to e.g. monitoring server
    }
}
