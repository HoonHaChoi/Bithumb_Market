//
//  GraphDataEntityValueTransformer.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//

import Foundation

@objc(GraphDataEntityValueTransformer)
final class GraphDataEntityValueTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: GraphDataEntityValueTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self, GraphDataEntity.self]
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    public static func register() {
        let transformer = GraphDataEntityValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
