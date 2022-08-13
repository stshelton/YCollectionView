//
//  OverrideSectionLoadingCell.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import Foundation
import YCollectionViewPackage

//example of how to inheirt LoadMoreSectionsCellData to add extra data to loading more sections
class OverrideSectionLoadingCell: LoadMoreSectionsCellData{
    var extraData: String = ""
    
//    init(){
//        super.init()
//    }
}
