//
//  ContentView.swift
//  iExpenseApp
//
//  Created by Lenskart on 08/07/22.
//

import SwiftUI
struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name : String
    let type : String
    let amount : Int
}
class Expenses: ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey : "items")
            }
        }
    }
    init(){
        if  let items = UserDefaults.standard.data(forKey : "items"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items=[]
    }
}

struct StyledAmount : ViewModifier{
    let amount : Int
    func body(content: Content) -> some View{
        return content.foregroundColor(getColor())
    }
    func getColor() -> Color{
        if amount  > 1000{
            return Color.red
            
        }else  if amount  < 100{
            return Color.green
        }else{
            return Color.black
        }
    }
}
struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment:  .leading){//(comeback for alignment)
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text("Rs. \(item.amount)")
                                .modifier(StyledAmount(amount: item.amount))
                    }
                }
                                .onDelete(perform: removeItems)
            }
                                .navigationBarTitle("iExpense App")
                                .navigationBarItems(
                                    leading: EditButton(),
                                    trailing:
                                        Button(action:{
                                            self.showingAddExpense  = true
                                        })
                                    {
                                        Image(systemName:  "plus")
                                    })
                                .sheet(isPresented: $showingAddExpense){
                                    AddView(expenses:  self.expenses)
                                }
        }
    }
                            func removeItems(at offsets: IndexSet){
                                expenses.items.remove(atOffsets: offsets)
                            }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
