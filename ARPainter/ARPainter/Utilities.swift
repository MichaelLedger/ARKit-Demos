//
//  Utilities.swift
//  ARPainter
//
//  Created by MountainX on 2019/3/1.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

import simd
import ARKit

// Swift标准库协议: CustomStringConvertible、CustomDebugStringConvertible
extension ARFrame.WorldMappingStatus: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        var description: String
        switch self {
        case .notAvailable:
            description = "Not Available"
        case .limited:
            description = "Limited"
        case .extending:
            description = "Extending"
        case .mapped:
            description = "Mapped"
        }
        return description
    }
    
    public var debugDescription: String {
        var debugDescription: String
        switch self {
        case .notAvailable:
            debugDescription = "Debug - Not Available"
        case .limited:
            debugDescription = "Debug - Limited"
        case .extending:
            debugDescription = "Debug - Extending"
        case .mapped:
            debugDescription = "Debug - Mapped"
        }
        return debugDescription
    }
}

extension float4x4 {
    var translation: float3 {
        return float3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    init(translation vector: float3) {
        self.init(float4(1, 0, 0, 0),
                  float4(0, 1, 0, 0),
                  float4(0, 0, 1, 0),
                  float4(vector.x, vector.y, vector.z, 1))
    }
}

extension float4 {
    var xyz: float3 {
        return float3(x, y, z)
    }
}
