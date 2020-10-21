//
//  ContentView.swift
//  reversi WatchKit Extension
//
//  Created by Jakob & Niko Neufeld on 20.10.20.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView: View {
    let size = 8
    var body: some View {
        GridStack(rows: size, columns: size) { (row, column) in
            Rectangle().foregroundColor(((column % 2)  + row) % 2 == 0 ? .blue  : .white )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
