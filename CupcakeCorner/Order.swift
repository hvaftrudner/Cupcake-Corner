//
//  Order.swift
//  CupcakeCorner
//
//  Created by Kristoffer Eriksson on 2021-03-23.
//

import Foundation

class Order: ObservableObject{
    
    @Published var orderStruct: OrderStruct
    
    enum CodingKeys: CodingKey{
        case orderStruct
    }
    
    init(){
        self.orderStruct = OrderStruct()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderStruct, forKey: .orderStruct)
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            orderStruct = try container.decode(OrderStruct.self, forKey: .orderStruct)
        }
    
}

struct OrderStruct: Codable {
    
    //Order
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet{
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    
    //Person
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress : Bool {
        if name.isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting{
            cost += Double(quantity)
        }
        
        if addSprinkles{
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
}
