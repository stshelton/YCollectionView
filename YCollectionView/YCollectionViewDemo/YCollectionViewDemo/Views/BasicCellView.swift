//
//  BasicCellView.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import SwiftUI

struct BasicCellView: View {
    let demoCellData: DemoCellData
    
    var body: some View {
        VStack{
            Image(demoCellData.image).resizable().scaledToFit()
            Text(demoCellData.title)
        }
    }
}

struct BasicCellView_Previews: PreviewProvider {
    static var previews: some View {
        BasicCellView(demoCellData: DemoCellData(title: "Test", image: "6"))
    }
}
