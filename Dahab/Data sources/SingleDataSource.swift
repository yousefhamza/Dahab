//
//  SingleDataSource.swift
//  myschool
//
//  Created by Yousef Hamza on 4/1/17.
//  Copyright © 2017 yousefhamza. All rights reserved.
//

import UIKit
enum DataSourceState {
    case Initial
    case Loading
    case Error
    case Content
    case Empty
}


public class SingleDataSource<CellElement: UITableViewCell, ModelElement>: NSObject, UITableViewDataSource, UITableViewDelegate, MessageStateDelegate {
    
    private var models: [ModelElement]
    public var didSelectRow: ((ModelElement, CellElement) -> Void)?
    public var configureCellForRow: ((CellElement, ModelElement) -> Void)?
    public var loadDataBlock: ( (@escaping ([ModelElement]?, NSError?) -> Void) -> Void)?

    let tableView: UITableView
    let cellIdentifier: String
    
    var activated = false

    var currentState = DataSourceState.Initial {
        didSet {
            if !activated {
                return
            }

            switch currentState {
                case .Empty:
                    tableView.backgroundView = MessageStateView(withMessage: "No entries found.", messageImage: nil, delegate: self)
                case .Error:
                    tableView.backgroundView = MessageStateView(withMessage: "Error happened, we couldn't reach the server", messageImage: nil, delegate: self)
                case .Loading:
                    tableView.backgroundView = LoadingIndicator(withTitle: "Loading...")
                default:
                    tableView.backgroundView = nil
            }
        }
    }
    
    public init(withTableView tableView: UITableView, cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        models = []

        super.init()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
    }

    //Mark: Public
    
    public func activate() {
        activated = true
        tableView.delegate = self
        tableView.dataSource = self

        let state = currentState
        currentState = state

        tableView.register(CellElement.self, forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()

        for view in tableView.subviews {
            if view.isKind(of: UIRefreshControl.classForCoder()) {
                view.removeFromSuperview()
            }
        }
        tableView.addSubview(refreshControl())
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
                self.tableView.reloadData()
                return
            }
            self.currentState = .Error

            self.models = []
            self.tableView.reloadData()
        })
    }

    // Mark: Message state delegate
    func retry() {
        loadData()
    }

    // Mark: Refresh control
    func refreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }

    // Mark : Refresh control delegate
    func refresh(_ refreshController: UIRefreshControl) {
        retry()
        DispatchQueue.main.async {
            refreshController.endRefreshing()
        }
    }

    // Mark: TableView Data Source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellElement
        let model = models[indexPath.row]
        configureCellForRow?(cell!, model)
        cell?.selectionStyle = .none
        return cell!
    }

    // Mark: TableView Delegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as? CellElement
        didSelectRow?(model, cell!)
    }
}
