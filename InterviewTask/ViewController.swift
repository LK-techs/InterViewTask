//
//  ViewController.swift
//  InterviewTask
//
//  Created by Admin on 18/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class ViewController: UIViewController {
    
    struct Cells {
        static let TableViewCell = "cell"
    }
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    private var factResponse: FactsResponse?
    var rows: [Rows] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        setupTableView()
        addRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            getData()
            print("Internet Connection Available!")
        }else{
            getDataFromCoreData()
            print("Internet Connection not Available!")
        }
    }

    func setupTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Cells.TableViewCell)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.pin(to:view)
    }
    //Add refresh controller to tableview
    func addRefresh(){
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher
        }else{
            tableView.addSubview(refresher)
        }
    }
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getData()
    }
    
    //Setup delegates and datatsource to tableview
    func setTableViewDelegates(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getDataFromCoreData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Interview")
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        var results: [NSManagedObject] = []
        var rowsArray = [Rows]()
        do {
            results = try context.fetch(fetchRequest)
            print(results)
            for data in results as! [Interview] {
                let eachTitle = data.value(forKey: "titlestring") as! String
                let eachDescription = data.value(forKey: "descriptionstring") as! String
                let eachImagePath = data.value(forKey: "imagePath") as! String
                let eachRow = Rows(title: eachTitle, description: eachDescription, imageHref: eachImagePath)
                rowsArray.append(eachRow)
                factResponse = FactsResponse(title: "Interview", rows: rowsArray)
                tableView.reloadData()
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
    }
    
    // Fetch data from server
    func getData() {
        let session = NetworkManager()
        session.fetchDataFromServer(withCompletion: { [weak self] (data) in
            guard let facts = data else {
                return
            }
            self?.factResponse = facts
            DispatchQueue.main.async {
                self?.navigationItem.title = facts.title ?? " "
                self?.refresher.endRefreshing()
                self?.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    // TableView Datasource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.factResponse?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TableViewCell) as! TableViewCell
        if let eachRow : Rows = (self.factResponse?.rows[indexPath.row]){
            cell.set(row: eachRow)
        }
        return cell
        
    }
}


