//
//  OnePageLootLoggerApp.swift
//  OnePageLootLogger
//
//  Created by Ron Woodbury on 11/24/21.
//

import SwiftUI

@main
struct OnePageLootLoggerApp: App {
    var body: some Scene {
        WindowGroup {
            ItemsView()
        }
    }
}

// ************************************
// Item
// ************************************
struct Item: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var serialNumber: String
    var value: String
}



// ************************************
// ItemStore
// ************************************
class ItemStore: ObservableObject {
    
    // A property marked with @Published is “published”,
    // it is turned into a publisher that emits data.
    // You can subscribe to data that's published.
    
    @Published var items = [Item]()
}



// ************************************
// ItemCell
// ************************************

struct ItemCell: View {
    
    let item: Item
    
    var body: some View {
        
        HStack {
            Text(item.name)
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.serialNumber)
                Text(item.value)
            }.font(.system(size:11))
             .frame( alignment: .trailing)
        }
    }
    
}



// ************************************
// Items View (al a controller)
// ************************************
struct ItemsView: View {

    // An ObservedObject is an object that
    // the view is observing for changes.
    // Normally used for external state.
    
    @ObservedObject var itemStore = ItemStore()

    var body: some View {
        NavigationView {
            List {
                ForEach(itemStore.items) { item in
                    // Pass binding to item into DetailView
                    NavigationLink(destination: DetailView(item: self.$itemStore.items[self.itemStore.items.firstIndex(of: item)!])) {
                        ItemCell(item: item)
                    }
                }
            }.navigationBarTitle("Loot Logger")
            
            
            // **************************************************
            // Add new item to itemStore
            // **************************************************
            .navigationBarItems(trailing:
                Button(action: {
                
                let item = Item(name: "New Item", serialNumber: "SN3040220", value: "1.00")
                    self.itemStore.items.append(item)
        
                }) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}



// ************************************
// Detail View (al a controller)
// ************************************
struct DetailView: View {
    
    // We use @Binding to alter data outside the view.
    // In contrst to @State, which is used for data
    // that doesn't leave the view.
    
    @Binding var item: Item
    
    let lightBlue: UIColor = UIColor(red: 0.79, green: 0.94, blue: 1.0, alpha: 0.5)
    
    var body: some View {
        Form {
            HStack {
                Text("Description:")
                TextField("", text: self.$item.name)
                    .background(Color(lightBlue))
            }
            HStack {
                Text("Serial Number:")
                TextField("", text: self.$item.serialNumber)
                    .background(Color(lightBlue))
            }
            HStack {
                Text("Value:")
                TextField("", text: self.$item.value)
                    .background(Color(lightBlue))
            }
        }.navigationBarTitle(Text(item.name), displayMode: .inline)
            
    }
}







