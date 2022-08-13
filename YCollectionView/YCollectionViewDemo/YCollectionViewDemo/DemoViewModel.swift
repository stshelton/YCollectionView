//
//  DemoViewModel.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/12/22.
//

import Foundation
import YCollectionViewPackage
import UIKit



class DemoViewModel: ObservableObject{
    
    //section
    typealias Section = CollectionViewSection<CreateDemoSectionData, AnyHashable>
    
    //all sections in collectionview
    @Published var sections: [Section] = []
    
    //start 2 sections
    var demoSectionData:[CreateDemoSectionData] = [CreateDemoSectionData( layoutStyle: .horizontal, containsHeader: true), CreateDemoSectionData(layoutStyle: .vertical, containsHeader: false)]
    
    
    init(){
        initialLoad()
    }
    
    //creates initial two sections
    private func initialLoad(){
        var sections = [Section]()
        for demoSection in demoSectionData{
            sections.append(Section(section: demoSection, items: demoSection.createCells()))
        }
        self.sections = sections
    }
    
    
    
    /// load more cells within section index
    /// - Parameter sectionIndex: section that wants to load more cells
    func loadMoreCells(sectionIndex: Int){
        ///remove all loading cells from sections
        self.sections[sectionIndex].cells.removeAll { cell in
            cell is OverrideLoadingCell
        }
        
        ///hardcode logic to display how you continue loading cells within current section or u can append a new section with class that inherits from LoadMoreSectionsCellData
        ///Once vertical section cell count is greater then 12 section will not add a loadingcell to section instead will append a loadingSection that contains one LoadMoreSectionCellData
        ///
        if self.sections[sectionIndex].section.layoutStyle == .vertical{
            let cellCount = sections[sectionIndex].cells.count
            self.sections[sectionIndex].cells.append(contentsOf: CreateDemoCellData().createDemoCells(withLoadMore: cellCount < 12 ? true : false))
            if cellCount == 12{
                let createLoadingSection = CreateDemoSectionData(layoutStyle: .loading, containsHeader: false)
                self.sections.append(Section(section: createLoadingSection, items: [OverrideSectionLoadingCell()] ))
            }
           
        }else{
            self.sections[sectionIndex].cells.append(contentsOf: CreateDemoCellData().createDemoCells(withLoadMore: true))
        }
      
    }
    
    
    ///Once LoadMoreSectionCellData is displayed collection view asks for more sections
    func loadMoreSections(){
        //remove all sections with layout style == .loading
        self.sections.removeAll { section in
            section.section.layoutStyle == .loading
        }
        
        //randomly choose next layout style to be appended
        //if layout style is vertical logic will have vertical section continue to add cells to that section till that section cell count is greater then 12
        let randomLayoutStyle = CreateDemoSectionData.layoutStyle(rawValue: Int.random(in: 0...1))
        let newSectionData = CreateDemoSectionData(layoutStyle: (randomLayoutStyle ?? .vertical), containsHeader: true)
        let section = Section(section: newSectionData, items: newSectionData.createCells())
        
        self.sections.append(section)
    }
    
    
    
    
}
