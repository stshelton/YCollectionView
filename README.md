
[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
<!-- [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) -->
<!-- [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)   -->
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# YCollectionView
<br />
<p align="center">
    <img src="https://i.imgur.com/lwJNQGw.png" width="200" height="200">
</p>

  
YCollectionView is a elegant swiftUI CollectionView built off UICollectionView. It was designed to solve performance issues associated with SwiftUI stack and scroll view nesting by achieving elegant scrolling and cell resuablity that UICollectionVew provides. It allows cells and supplementary views to be built in SwiftUI and provides built in basic paganation logic, pull to refresh and on cell tap functionally. YCollectionView was built off https://github.com/defagos/SwiftUICollection sample project for his article for [Building a Collection For SwiftUI](http://defagos.github.io/swiftui_collection_part2/)
  

<p align="center">
<img src= "https://media.giphy.com/media/DmvisWAJSg1WGYeCJ5/giphy.gif" height= "400" >
</p>

## Features

- [x] Pagination/Infinite Scrolling vertically and horizontally
- [x] Cells and Supplementary views are built with swiftUI Views
- [x] Fully customizable sections using compositional layouts
- [x] Uses diffable data source as collectionViews data source
- [x] Built in pull to refresh added to view

## Requirements

- iOS 14.0+
- Xcode 12.0

## Installation
YCollectionview is available via [Swift Package Manger](https://www.swift.org/package-manager/)

Using Xcode 12, go to ```File -> Swift Packages -> Add Package Dependecy and enter``` and enter https://github.com/stshelton/YCollectionView


## Usage example
Heres the most basic implentation of **YCollectionView**. If you'd like to see a more complex implentation that shows pagination refer to the [Sample Project](https://github.com/stshelton/YCollectionViewDemo)


• Create Cell and Section Data that conform to hashable protocol
```swift
     struct BasicDemoData: Hashable{
        var id: UUID = UUID()
        var title: String
    }
    
    struct BasicSectionData: Hashable{
        var id: UUID = UUID()
        var extraSectionInfo: String = ""
    }
```

• Create CollectionViewSection, which contains an array of hashable objects for cells(BasicDemoData) and a hashable object for section(BasicSectionData)
```swift
    //section
    typealias Section = CollectionViewSection<AnyHashable, AnyHashable>
    
    //basic Section
    var basicSection = Section(section: BasicSectionData(), items: [BasicDemoData(title: "Test 1"), 
    BasicDemoData(title: "Test 2"), BasicDemoData(title: "Test 3"), BasicDemoData(title: "Test 4")])
```

• Create Basic NSCollectionLayoutSection for compositional layout
```swift
       private func CreateBasicLayoutSection()-> NSCollectionLayoutSection{
        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.3))
        //3
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
```


• Full Example
```swift
import SwiftUI
import YCollectionView

struct BasicYCollectionViewImplementation: View {
    
    //section
    typealias Section = CollectionViewSection<AnyHashable, AnyHashable>
    
    //basic Section
    var basicSection = Section(section: BasicSectionData(), items: [BasicDemoData(title: "Test 1"), BasicDemoData(title: "Test 2"),
    BasicDemoData(title: "Test 3"), BasicDemoData(title: "Test 4")])
    
    
    struct BasicDemoData: Hashable{
        var id: UUID = UUID()
        var title: String
    }
    
    struct BasicSectionData: Hashable{
        var id: UUID = UUID()
        var extraSectionInfo: String = ""
    }
    
    
    var body: some View {
        CollectionView(rows: [basicSection], collectionViewBackgroundColor: UIColor.white, addPullToRefresh: true) { sectionIndex, layoutEnviroment in
            return CreateBasicLayoutSection()
        } cell: { indexPath, cellData in
            switch cellData{
            case let basicCellData as BasicDemoData:
                VStack{
                    Text(basicCellData.title)
                }
                
            default:
                EmptyView()
            }
        } supplementaryView: { kind, indexPath, sectionData in
            //header and footer views
        } loadMoreCells: { loadingSection in
            //logic to load more cells within section
        } loadMoreSections: {
            //logic to load more sections
        } clickedDetailPage: { item in
            //current cell clicked and data associated with cell
        } pullToRefresh: { refreshControl in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                refreshControl.endRefreshing()
            }
        }

    }
    
    private func CreateBasicLayoutSection()-> NSCollectionLayoutSection{
        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.3))
        //3
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
```

## Customize Loading Data
YCollectionView uses ``willDisplay`` method of UICollectionViewDelegate to check if last cell within data source is or inherits from ``LoadMoreCellsData`` object. If you'd like to add more data to the ``LoadMoreCellsData`` create a new object that inherits from ``LoadMoreCellsData`` and add aditional data needed within that class.

```swift
class OverrideLoadingCell: LoadMoreCellsData{
    var extraData: String
    
    init(extraData: String){
        self.extraData = extraData
        super.init()
    }
}
```

Accessing the data
```swift
  cell: { indexPath, cellData in
                switch cellData {
                case let demoCellData as DemoCellData:
                    BasicCellView(demoCellData: demoCellData)
                case let loadingMoreData as OverrideLoadingCell:
                    LoadingCellView(loadingData: loadingMoreData)
                default:
                    EmptyView()
                }
            } 
```

The same is true with loading more sections. YCollectionView uses ``willDisplay`` method of UICollectionViewDelegate to check if last cell in section is or inherits from ``LoadMoreSectionsCellData``. With a section intented to load more sections I would only pass in one cell which is or inherits from ``LoadMoreSectionsCellData``. 

```swift
class OverrideSectionLoadingCell: LoadMoreSectionsCellData{
    var extraData: String = ""
    
    init(extraData: String){
      self.extraData = extraData
    }
}
```

Accessing the data
```swift
  cell: { indexPath, cellData in
                switch cellData {
                case let demoCellData as DemoCellData:
                    BasicCellView(demoCellData: demoCellData)
                case let loadingMoreData as OverrideLoadingCell:
                    LoadingCellView(loadingData: loadingMoreData)
                case let loadingMoreSections as OverrideSectionLoadingCell:
                    LoadingNewSectionCellView(loadingSectionData: loadingMoreSections)
                default:
                    EmptyView()
                }
            } 
```


## Contribute

We would love you for the contribution to **YCollectionView**, check the ``LICENSE`` file for more info.

## Meta

Spencer Shelton - Stshelton1993@example.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/stshelton](https://github.com/stshelton)

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
