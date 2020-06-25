//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Vegesna, Vijay V EX1 on 6/23/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Form{
            Section {
                TextField("Name:", text: $order.name)
                TextField("Stree Address:", text: $order.streetAddress)
                TextField("City:", text: $order.city)
                TextField("Zip:", text: $order.zip)
            }
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check Out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery Address", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        AddressView(order: Order())
        }
    }
}
