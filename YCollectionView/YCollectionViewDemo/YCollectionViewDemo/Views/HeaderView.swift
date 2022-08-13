//
//  HeaderView.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .center){
            Text("Header").font(.title).frame(maxWidth: .infinity, alignment: .leading)
        }.frame(maxHeight: .infinity).background(Color.gray)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
