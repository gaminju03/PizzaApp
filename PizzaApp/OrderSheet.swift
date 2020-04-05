//
//  OrderSheet.swift
//  PizzaApp
//
//  Created by Juan on 28/03/20.
//  Copyright © 2020 usuario. All rights reserved.
//

import SwiftUI
import CoreData

struct OrderSheet: View {
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.presentationMode) var presentationMode
    @State var selectedPizzaIndex = 0
    @State var numberOfSlices = 1
    @State var tableNumber = ""
    let pizzaType = ["Margherita","Greek","Cuban","California","Hawaian","New York"]
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Pizza details")){
                    Picker("Pizza type",selection: $selectedPizzaIndex){
                        ForEach(0 ..< pizzaType.count){
                            Text(self.pizzaType[$0])
                        }
                    }
                    Stepper("\(numberOfSlices) Slices", value: $numberOfSlices, in: 1...12)
                }
                Section(header: Text("Table")){
                    TextField("Table number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                Button("Add Order"){
                    guard self.tableNumber != "" else { return }
                    //insert a DB objeto Order
                    let order = Order(context:self.dbContext)
                    order.id = UUID()
                    order.pizzaType = self.pizzaType[self.selectedPizzaIndex]
                    order.orderStatus = .pending
                    order.tableNumber = self.tableNumber
                    order.numberOfSlices = Int16(self.numberOfSlices)
                    do{
                        try self.dbContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }.navigationBarTitle("Add Order")
        }
    }
}

struct OrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheet()
    }
}
