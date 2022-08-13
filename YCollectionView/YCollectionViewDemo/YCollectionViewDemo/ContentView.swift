//
//  ContentView.swift
//  Y?CollectionDemo
//
//  Created by Spencer Shelton on 8/12/22.
//

import SwiftUI
import YCollectionViewPackage

struct ContentView: View {
    @StateObject var demoViewModel = DemoViewModel()
    
   

    var body: some View {
        VStack{
            CollectionView(rows: demoViewModel.sections, collectionViewBackgroundColor: UIColor.white, addPullToRefresh: true) { sectionIndex, layoutEnviroment in
                return demoViewModel.sections[sectionIndex].section.basicLayout()
            } cell: { indexPath, cellData in
                switch cellData {
                case let demoCellData as DemoCellData:
                    BasicCellView(demoCellData: demoCellData)
                case _ as LoadMoreCellsData, _ as OverrideLoadingCell, _ as OverrideSectionLoadingCell:
                   LoadingCellView()
                default:
                    EmptyView()
                }
                
            } supplementaryView: { kind, indexPath, sectionData in
                if kind == UICollectionView.elementKindSectionHeader{
                    HeaderView()
                }else{
                    
                }
            } loadMoreCells: { loadingSection in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    demoViewModel.loadMoreCells(sectionIndex: loadingSection)
                }
            } loadMoreSections: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    demoViewModel.loadMoreSections()
                }
            } clickedDetailPage: { item in
                
            } pullToRefresh: { refreshControl in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
