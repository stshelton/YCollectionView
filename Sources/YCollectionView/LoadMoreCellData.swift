//
//  CellProtocol.swift
//  Y?CollectionView
//
//  Created by Spencer Shelton on 6/1/22.
//

import Foundation

open class LoadMoreCellsData: Hashable{
    public static func == (lhs: LoadMoreCellsData, rhs: LoadMoreCellsData) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    
    public init(){
        
    }
    var id: UUID = UUID()
}

open class LoadMoreSectionsCellData: Hashable{
    public static func == (lhs: LoadMoreSectionsCellData, rhs: LoadMoreSectionsCellData) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    
    public init(){
        
    }
    
    var id: UUID = UUID()
}
