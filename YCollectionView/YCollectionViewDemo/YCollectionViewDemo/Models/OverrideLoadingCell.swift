//
//  OverrideLoadingCell.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import Foundation
import YCollectionViewPackage


//example of how to inheirt loadmorecelldata to add extra data to a loading cell if needed
class OverrideLoadingCell: LoadMoreCellsData{
    var extraData: String
    
    init(extraData: String){
        self.extraData = extraData
        super.init()
    }
}
