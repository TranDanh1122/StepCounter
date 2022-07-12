//
//  MainTableViewController.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import UIKit
import CoreMotion
class MainTableViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: MainTableViewModel = MainTableViewModel()
    private var dataSource: CMPedometerData? {
        didSet {
            guard let dataSource = dataSource else { return }
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "reloadTableCellDataWhenShake"), object: nil, userInfo: ["dataSource": dataSource])
        }
    }
    // config view
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupSubcribeObserveble()
    }
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        register(nibName: "OneWeekStepDetailCell", cellID: "OneWeekStepDetailCell")
    }
    private func register(nibName: String, cellID: String){
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellID)
    }
    deinit {
        viewModel.notificationCenter.removeObserver(self, name: viewModel.notificationName, object: nil)
    }
    //subcribe data from view model
    private func setupSubcribeObserveble(){
        viewModel.notificationCenter.addObserver(self, selector: #selector(observebleOnNextHanle(_:)), name: viewModel.notificationName, object: nil)
    }
    @objc func observebleOnNextHanle(_ noti: Notification){
        if let data = noti.userInfo?[viewModel.notificationDataKey] as? CMPedometerData {
            dataSource = data
        } else {
            print("cant get data from userInfo, it's nil")
        }
    }
}
extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneWeekStepDetailCell") as? OneWeekStepDetailCell
        guard let cell = cell else { return OneWeekStepDetailCell() }
        cell.layoutIfNeeded()
        cell.reloadData(data: dataSource)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 416
    }
}
extension MainTableViewController: OneWeekStepDetailCellDelegate {
    func didScrollToAnotherItem(currentPage: Int) {
        let date = Calendar.current.date(byAdding: .day, value: -currentPage, to: Date())
        guard let date = date else { return  }
        viewModel.getStepDetailOf(date: date)
    }
}
