//
//  CreateDemoCellData.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import Foundation


class CreateDemoCellData{
    
    var titles: [String] = ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6"]
    var imagesForTitls : [String : String] = ["Test1" : "1", "Test2" : "2", "Test3" : "3", "Test4" : "4", "Test5" : "5", "Test6" : "6"]
    
    
    /// creates demo cells
    /// - Parameter withLoadMore: should load more cell be added to end of array
    /// - Returns: array of anyhashable objects (Cells)
    func createDemoCells(withLoadMore: Bool) -> [AnyHashable]{
        var demoCells:[AnyHashable] = []
        for title in titles{
            demoCells.append(DemoCellData(title: title, image: imagesForTitls[title] ?? ""))
        }
        
        if withLoadMore{
            demoCells.append(OverrideLoadingCell(extraData: ""))
        }
        return demoCells
    }
}
