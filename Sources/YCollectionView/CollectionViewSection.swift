//
//  CollectionViewSection.swift
//  Y?CollectionView
//
//  Created by Spencer Shelton on 8/12/22.
//

import Foundation


public struct CollectionViewSection<Section: Hashable, CellData: Hashable>: Hashable {
    public let section: Section
    public var cells: [CellData]
    
    public init(section: Section, items: [CellData]) {
        self.section = section
        self.cells = items
    }
}
