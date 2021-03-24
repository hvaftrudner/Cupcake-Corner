//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Kristoffer Eriksson on 2021-03-23.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order
    
    var body: some View {
        Form{
            Section{
                TextField("Name: ", text: $order.orderStruct.name)
                TextField("Address: ", text: $order.orderStruct.streetAddress)
                TextField("City: ", text: $order.orderStruct.city)
                TextField("Zip: ", text: $order.orderStruct.zip)
                
            }
            
            Section{
                NavigationLink(destination: CheckoutView(order: order)){
                    Text("Checkout")
                }
            }
            .disabled(order.orderStruct.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
