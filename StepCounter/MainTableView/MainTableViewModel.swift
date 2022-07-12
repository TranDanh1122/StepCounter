//
//  MainTableViewModel.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import Foundation
import CoreMotion
class MainTableViewModel {
    let notificationCenter = NotificationCenter.default
    let notificationName = Notification.Name.init(rawValue: "pushdata")
    let notificationDataKey: String = "stepdetail"
    private var stepDataSource: CMPedometerData? {
        didSet {
            guard let stepDataSource = stepDataSource else {
                print("error, stepDataSource is nil")
                return
            }
            print(stepDataSource)
            notifyData(with: stepDataSource)
        }
    }
    // initilation
    init() {
        getTodayStep()
    }
    //custom  func
    private func getTodayStep() {
        let handle: CMPedometerHandler = {[unowned self] pedomaterData, error in
            guard let error = error else {
                stepDataSource = pedomaterData
                return
            }
            print(error)
        }
        PedometerSensor.pedometerStaticObject.startUpdate(from: Date().startOfThisDate, with: handle)
    }
    private func notifyData(with data: CMPedometerData) {
        notificationCenter.post(name: notificationName, object: nil, userInfo: [notificationDataKey: data])
    }
    func getStepDetailOf(date queryDate: Date) {
        let handle: CMPedometerHandler = {[unowned self] pedomaterData, error in
            guard let error = error else {
                stepDataSource = pedomaterData
                return
            }
            print(error)
        }
        PedometerSensor.pedometerStaticObject.getStep(from: queryDate.startOfThisDate, to: queryDate.endOfDay, with: handle)
    }

}
