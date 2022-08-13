//
//  CreateDemoSectionData.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/13/22.
//

import Foundation
import UIKit

struct CreateDemoSectionData: Hashable{
    var id: UUID = UUID()
    var layoutStyle: layoutStyle
    var containsHeader: Bool
    
    
    /// layout styles
    enum layoutStyle : Int{
        case vertical = 0
        case horizontal = 1
        case loading = 2
    }
    
    
    /// create demo cells
    /// - Returns: array of hashable objects (cells
    func createCells() -> [AnyHashable]{
        return CreateDemoCellData().createDemoCells(withLoadMore: true)
    }
    
    
    /// create layout based on layout style
    /// - Returns: NSCollectionLayoutSection
    func basicLayout() -> NSCollectionLayoutSection {
        switch self.layoutStyle {
        case .vertical:
            return verticalStyle()
        case .horizontal:
            return horizontalStyle()
        case .loading:
            return loadingStyle()
        }
    }
    
    
    /// vertical layout section cells are 80 percent of screens hight and full size of width
    /// - Returns: NSCollecctionLayoutSection
    private func verticalStyle() -> NSCollectionLayoutSection{
        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.8))
        //3
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = containsHeader ? createSupplementaryViews() : []
        
        return section
    }
    
    
    /// horizontal layout section cells are 300 in height
    /// - Returns: Collection Layout Section
    private func horizontalStyle() -> NSCollectionLayoutSection{
        let inset: CGFloat = 2.5
            
            // Items
       let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
       let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
       largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
       
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
            let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem])
        
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = containsHeader ? createSupplementaryViews() : []
        
        return section
    }
    
    
    /// loading style section full width of screen and a height of 100
    /// - Returns: Collection Layout Section
    private func loadingStyle() -> NSCollectionLayoutSection{
        let inset: CGFloat = 2.5
        
        // Items
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem])
        
        let section = NSCollectionLayoutSection(group: outerGroup)
    

        return section
    }
    
    //header footer views
    func createSupplementaryViews() -> [NSCollectionLayoutBoundarySupplementaryItem]{
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(CGFloat(40))),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        return [header]
    }
}
