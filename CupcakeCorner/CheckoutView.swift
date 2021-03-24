//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Kristoffer Eriksson on 2021-03-23.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    
    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView{
                VStack{
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is: \(self.order.orderStruct.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("place order"){
                        //send order
                        self.placeOrder()
                    }
                    .padding()
                    
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
        .alert(isPresented: $showingConfirmation){
            Alert(title: Text(confirmationTitle), message: Text(confirmationMessage), dismissButton: .default(Text("ok")))
        }
    }
    
    func placeOrder(){
        guard let encoded = try? JSONEncoder().encode(order.orderStruct) else {
            print("failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            //handle POST
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                
                self.confirmationTitle = "Connection Error"
                self.confirmationMessage = "You have no internet connection"
                self.showingConfirmation = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(OrderStruct.self, from: data){
                
                self.confirmationTitle = "Thank you"
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(OrderStruct.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                
                self.showingConfirmation = true
            } else {
                print("invalid response from server")
            }
            
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
