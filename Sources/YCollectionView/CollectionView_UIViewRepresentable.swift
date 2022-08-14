//
//  CollectionView_UIViewRepresentable.swift
//  Y?CollectionView
//
//  Created by Spencer Shelton on 6/1/22.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct CollectionView<Section: Hashable, CellData: Hashable, Cell: View, SupplementaryView: View>: UIViewRepresentable {
    
    //MARK: CELLS
    //Host Cell
    private class HostCell: UICollectionViewCell {
        private var hostController: UIHostingController<Cell>?
        
        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }
        
        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view, ignoreSafeArea: true)
                if let hostView = hostController?.view {
                    hostView.backgroundColor = UIColor.clear
                    hostView.frame = contentView.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contentView.addSubview(hostView)
                }
            }
        }
        
        deinit {
            //print("hostcell view deinit")
            hostController = nil
        }
    }
    
    //Header/Footer Views
    private class HostSupplementaryView: UICollectionReusableView {
        private var hostController: UIHostingController<SupplementaryView>?
        
        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }
        
        var hostedSupplementaryView: SupplementaryView? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view, ignoreSafeArea: true)
                if let hostView = hostController?.view {
                    hostView.backgroundColor = UIColor.clear
                    hostView.frame = self.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    addSubview(hostView)
                }
            }
        }
        
        deinit {
            //print("supplementary view deinit")
            hostController = nil
        }
    }
    
    
    public class Coordinator: NSObject, UICollectionViewDelegate {
        fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, CellData>
        
        fileprivate var dataSource: DataSource? = nil
        fileprivate var sectionLayoutProvider: ((Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection)?
        fileprivate var rowsHash: Int? = nil
        fileprivate var registeredSupplementaryViewKinds: [String] = []
        fileprivate var isFocusable: Bool = false

        fileprivate var addCells: ((_ loadingSection: Int) -> ())?
        fileprivate var addSections: (() -> ())?
        fileprivate var clickedDetailPage: ((_ cellData: CellData) -> ())?
        fileprivate var pullToRefresh: ((_ refreshControl: UIRefreshControl) -> ())?
        
        
        let refreshControl = UIRefreshControl()
        
       
        
        deinit {
            print("coordinator deinited")
        }
        
        func cleanUp(){
            print("clean up")
            dataSource = nil
            sectionLayoutProvider = nil
            rowsHash = nil
            registeredSupplementaryViewKinds = []
            addCells = nil
            addSections = nil
            clickedDetailPage = nil
            pullToRefresh = nil
        }
        
        
        public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
            return isFocusable
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            print(indexPath)
            if let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] , let item = dataSource?.snapshot(for: section).items[indexPath.row]{
                clickedDetailPage!( item)
            }
        }
        
   
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            //load more cells within section logic
            if let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section]{
                if  let numberOfRows =  dataSource?.snapshot().numberOfItems(inSection: section),let allRowsInSection = dataSource?.snapshot(for: section).items, (indexPath.row ==  numberOfRows - 1 && allRowsInSection[indexPath.row] is LoadMoreCellsData) { //it's your last cell
                    print("load more cells within section")
                    addCells?(indexPath.section)
                   //Load more data & reload your collection view
                }
            
                //load another section
                if  let numberOfRows =  dataSource?.snapshot().numberOfItems(inSection: section),let allRowsInSection = dataSource?.snapshot(for: section).items, (indexPath.row ==  numberOfRows - 1 && allRowsInSection[indexPath.row] is LoadMoreSectionsCellData) { //it's your last cell
                    print("load more sections")
                    addSections?()
                   //Load more data & reload your collection view
                }
            }
        }
        
        func attachRefreshControl(){
            refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        }
        @objc private func refreshWeatherData(_ sender: Any) {
           // Fetch Weather Data
            pullToRefresh?(self.refreshControl)
            print("refresh Data")
       }
        
        
        
       
    }
    
    let rows: [CollectionViewSection<Section, CellData>]
    let collectionViewBackgroundColor: UIColor
    let addPullToRefresh: Bool
    let cell: (IndexPath, CellData) -> Cell
    let supplementaryView: (String, IndexPath, Section) -> SupplementaryView
    
    let sectionLayoutProvider: (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    let loadMoreCells: ((_ loadingSection: Int) -> ())
    let loadMoreSections: (() -> ())
    let clickedDetailPage: ((_ cellData: CellData) -> ())?
    let pullToRefresh: ((_ refreshControl: UIRefreshControl) -> ())?
    
    
    public init(rows: [CollectionViewSection<Section, CellData>], collectionViewBackgroundColor: UIColor,addPullToRefresh: Bool = true,
         sectionLayoutProvider: @escaping (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection,
         @ViewBuilder cell: @escaping (IndexPath, CellData) -> Cell,
         @ViewBuilder supplementaryView: @escaping (String, IndexPath, Section) -> SupplementaryView, loadMoreCells: @escaping ((_ loadingSection: Int) -> ()), loadMoreSections: @escaping (()->()), clickedDetailPage: @escaping ((_ item: CellData) -> ()), pullToRefresh: @escaping ((_ refreshControl: UIRefreshControl) -> ())) {
        self.rows = rows
        self.collectionViewBackgroundColor = collectionViewBackgroundColor
        self.addPullToRefresh = addPullToRefresh
        self.sectionLayoutProvider = sectionLayoutProvider
        self.cell = cell
        self.supplementaryView = supplementaryView
        self.loadMoreCells = loadMoreCells
        self.loadMoreSections = loadMoreSections
        self.clickedDetailPage = clickedDetailPage
        self.pullToRefresh = pullToRefresh
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Section, CellData> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
        for row in rows {
            snapshot.appendSections([row.section])
            snapshot.appendItems(row.cells, toSection: row.section)
        }
        return snapshot
    }
    
    private func reloadData(in collectionView: UICollectionView, context: Context, animated: Bool = false) {
        let coordinator = context.coordinator
        coordinator.sectionLayoutProvider = self.sectionLayoutProvider
        
        guard let dataSource = coordinator.dataSource else { return }
        
        let rowsHash = rows.hashValue
     
        if coordinator.rowsHash != rowsHash {
            //TODO only animate when removing last cell
           
            DispatchQueue.main.async { [weak dataSource] in
                guard let dataSource  = dataSource else{
                    print("dataSource was nil when trying to update")
                    return
                }
                dataSource.apply(snapshot(), animatingDifferences: animated) { [weak collectionView] in
                    coordinator.isFocusable = true
                    collectionView?.setNeedsFocusUpdate()
                    collectionView?.updateFocusIfNeeded()
                    coordinator.isFocusable = false
                }
            }
           
            coordinator.rowsHash = rowsHash
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    private func layout(context: Context) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return context.coordinator.sectionLayoutProvider?(sectionIndex, layoutEnvironment)
        }
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        let cellIdentifier = "hostCell"
        let supplementaryViewIdentifier = "hostSupplementaryView"
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout(context: context))
        collectionView.backgroundColor = collectionViewBackgroundColor
        collectionView.delegate = context.coordinator
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        
        //refresh Contorl
        if addPullToRefresh{
            collectionView.refreshControl = context.coordinator.refreshControl
            context.coordinator.attachRefreshControl()
        }
        
        let dataSource = Coordinator.DataSource(collectionView: collectionView) { collectionView, indexPath, cellData in
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = cell(indexPath, cellData)
            return hostCell
        }
        
     
        context.coordinator.dataSource = dataSource
        context.coordinator.addCells = loadMoreCells
        context.coordinator.addSections = loadMoreSections
        context.coordinator.clickedDetailPage = clickedDetailPage
        context.coordinator.pullToRefresh = pullToRefresh
        
        //Get an instance of the section for the supplementary view
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let coordinator = context.coordinator
            if !coordinator.registeredSupplementaryViewKinds.contains(kind) {
                collectionView.register(HostSupplementaryView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryViewIdentifier)
                coordinator.registeredSupplementaryViewKinds.append(kind)
            }
            
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewIdentifier, for: indexPath) as? HostSupplementaryView else { return nil }
            //dataSource.snapshot().secitonIdentifiers returns sectionData
            view.hostedSupplementaryView = supplementaryView(kind, indexPath, dataSource.snapshot().sectionIdentifiers[indexPath.section])
    
            return view
        }
        
        reloadData(in: collectionView, context: context)
        return collectionView
    }
    
    
    public static func dismantleUIView(_ uiView: UICollectionView, coordinator: Coordinator) {
        print("dismantle UIVIew")
        coordinator.dataSource?.supplementaryViewProvider = nil
        coordinator.cleanUp()
        
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        reloadData(in: uiView, context: context, animated: true)
    }
}




