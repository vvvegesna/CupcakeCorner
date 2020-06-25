//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Vegesna, Vijay V EX1 on 6/23/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    
    @State var confirmationMessage = ""
    @State var showingConfirmation = false
    @State var alertTitle = ""
    
    @ObservedObject var order: Order
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Cehck Out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) { () -> Alert in
            Alert(title: Text(alertTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("faild to encode code")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                self.presentAlert(title: "Sorry!", message: "Can not place your order: \(error!.localizedDescription).")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.presentAlert(title: "Thank You!", message: "Your order of \(decodedOrder.quantity)X \(Order.types[decodedOrder.type]) is ready for the delivery")
            } else {
                print("Invalid response from the server")
            }
        }.resume()
    }
    
    func presentAlert(title: String, message: String) {
        alertTitle = title
        confirmationMessage = message
        showingConfirmation = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        CheckoutView(order: Order())
        }
    }
}
