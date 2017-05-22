//
//  CollectionSingleDataSource.swift
//  AAIB
//
//  Created by Yousef Hamza on 4/25/17.
//  Copyright © 2017 yousefhamza. All rights reserved.
//

import UIKit

public class CollectionSingleDataSource<CellElement: UICollectionViewCell, ModelElement>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var models: [ModelElement]
    public var didSelectRow: ((ModelElement) -> Void)?
    public var configureCellForRow: ((CellElement, ModelElement) -> Void)?
    public var loadDataBlock: ( (@escaping ([ModelElement]?, NSError?) -> Void) -> Void)?
    
    let collectionView: UICollectionView
    let cellIdentifier: String
    
    var activated = false
    
    var currentState = DataSourceState.Initial {
        didSet {
            if !activated {
                return
            }
            
            //            switch currentState {
            //                case .Empty:
            //                    tableView.emptyDataSetSource = EmptyStateDataSet(withTitle: "No data found", image: nil) // TODO: Set image
            //                case .Error:
            //                    tableView.emptyDataSetSource = ErrorStateDataSet(withTitle: "Something went wrong",
            //                                                                 image: nil,
            //                                                                 buttonTitle: "Tap to retry")
            //                default:
            //                    tableView.emptyDataSetSource = nil
            //            }
        }
    }
    
    public init(withCollectionView collectionView: UICollectionView, cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        self.collectionView = collectionView
        models = []
        
        super.init()
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.separatorColor = UIColor.clear
    }
    
    //Mark: Public
    
    public func activate() {
        activated = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let state = currentState
        currentState = state
        
        collectionView.register(CellElement.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.reloadData()
    }
    
    public func loadData() {
        currentState = .Loading
        loadDataBlock?({ (loadedModels, error) -> Void in
            if let newModels = loadedModels {
                self.models = newModels
                
                if (newModels.count == 0) {
                    self.currentState = .Empty
                } else {
                    self.currentState = .Content
                }
                self.collectionView.reloadData()
                return
            }
            self.currentState = .Error
            
            self.models = []
            self.collectionView.reloadData()
        })
    }
    
    //Mark: TableView Data Source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CellElement
        let model = models[indexPath.item]
        configureCellForRow?(cell!, model)
        return cell!
    }
    
    // Mark: TableView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.item]
        didSelectRow?(model)
    }
}
