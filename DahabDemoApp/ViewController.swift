//
//  ViewController.swift
//  DahabDemoApp
//
//  Created by Yousef Hamza on 6/11/17.
//  Copyright © 2017 yousefhamza. All rights reserved.
//

import UIKit
import Dahab

class ViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    var singleDataSource: SingleDataSource<UITableViewCell, String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Dispose of any resources that can be recreated.
        
        tableView.backgroundColor = .red
        
        singleDataSource = SingleDataSource<UITableViewCell, String>(withTableView: tableView, cellIdentifier: "cellIdentifier")
        singleDataSource.loadDataBlock = { (callBack: @escaping ([String]?, NSError?) -> Void) in
            sleep(3)
            callBack(["A", "B", "C"], nil)
        }
        
        singleDataSource.configureCellForRow = { (cell: UITableViewCell, model: String, indexPath: IndexPath) in
            cell.textLabel?.text = "\(model)  \(indexPath.row)"
        }
        
        singleDataSource.activate()
        singleDataSource.activate()
        singleDataSource.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadView() {
        view = tableView
    }
}

