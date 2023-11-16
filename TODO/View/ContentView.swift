//
//  ContentView.swift
//  TODO
//
//  Created by Jasim Uddin on 16/11/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TodoListView(presentationMode: presentationMode)
    }
}
