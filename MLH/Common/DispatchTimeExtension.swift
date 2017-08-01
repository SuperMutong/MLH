//
//  DispatchTimeExtension.swift
//  MLH
//
//  Created by Haitang on 17/6/12.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
extension DispatchTime:ExpressibleByIntegerLiteral{
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + DispatchTimeInterval.seconds(value)
    }
}
extension DispatchTime:ExpressibleByFloatLiteral{
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(value*1000.0))
    }
}

