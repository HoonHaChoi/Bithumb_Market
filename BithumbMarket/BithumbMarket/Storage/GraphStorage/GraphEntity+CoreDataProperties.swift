//
//  GraphEntity+CoreDataProperties.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//
//

import Foundation
import CoreData


extension GraphEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphEntity> {
        return NSFetchRequest<GraphEntity>(entityName: "GraphEntity")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var symbol: String?
    @NSManaged public var graphChartEntity: NSSet?
    
    func toDomain() -> GraphData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            
        var dateList: [String] = []
        var closePriceList: [Double] = []
        var openPriceList: [Double] = []
        var minPriceList: [Double] = []
        var maxPriceList: [Double] = []
        
        let chartData = self.graphChartEntity?.allObjects as? [GraphChartEntity]
        chartData?.first?.graphData?.forEach({ graphDataEntity in
            dateList.append(dateFormatter.string(from: graphDataEntity.date))
            closePriceList.append(graphDataEntity.closPrice.convertDouble())
            openPriceList.append(graphDataEntity.openPrice.convertDouble())
            minPriceList.append(graphDataEntity.minPrice.convertDouble())
            maxPriceList.append(graphDataEntity.maxPrice.convertDouble())
        })
        return GraphData.init(dateList: dateList,
                              closePriceList: closePriceList,
                              openPriceList: openPriceList,
                              minPriceList: minPriceList,
                              maxPriceList: maxPriceList)
    }
}

// MARK: Generated accessors for graphChartEntity
extension GraphEntity {

    @objc(addGraphChartEntityObject:)
    @NSManaged public func addToGraphChartEntity(_ value: GraphChartEntity)

    @objc(removeGraphChartEntityObject:)
    @NSManaged public func removeFromGraphChartEntity(_ value: GraphChartEntity)

    @objc(addGraphChartEntity:)
    @NSManaged public func addToGraphChartEntity(_ values: NSSet)

    @objc(removeGraphChartEntity:)
    @NSManaged public func removeFromGraphChartEntity(_ values: NSSet)

}

extension GraphEntity : Identifiable {

}
