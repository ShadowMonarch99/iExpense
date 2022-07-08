//
//  AddView.swift
//  iExpenseApp
//
//  Created by Lenskart on 08/07/22.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var showAlert = false
    @State private var name = ""
    @State private var  type = "Personal"
    @State private var amount = ""
    static let types = ["Business","Personal"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text:  $name)
                Picker("Type", selection: $type){
                    ForEach(Self.types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new Expense")
            .navigationBarItems(trailing:
                                    Button("Save"){
                if  let actualAmount  = Int(self.amount){
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                    
                }else{
                    self.showAlert  = true
                }
            }
                                )
            .alert(isPresented: $showAlert){
                Alert(title: Text("Invalid Amount"),
            message: Text("The amount has  to be  a number"),
            dismissButton: .default(Text("OK")))
            }
        }
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
