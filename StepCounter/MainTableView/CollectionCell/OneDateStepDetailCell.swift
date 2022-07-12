//
//  OneDateStepDetailCell.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import UIKit
import CoreMotion
class OneDateStepDetailCell: UICollectionViewCell {
    @IBOutlet private weak var infomationCirleEdgeView: UIView!
    @IBOutlet private weak var humanImage: UIImageView!
    @IBOutlet private weak var sumStep: UILabel!
    @IBOutlet private weak var timeline: UILabel!
    @IBOutlet private weak var goal: UILabel!
    @IBOutlet private weak var goalImageL: UIImageView!
    @IBOutlet private weak var bottonInfomationEdgeView: UIView!
    @IBOutlet private weak var caloEdgeView: UIView!
    @IBOutlet private weak var caloImage: UIImageView!
    @IBOutlet private weak var caloBurned: UILabel!
    @IBOutlet private weak var mileEdgeView: UIView!
    @IBOutlet private weak var mileImage: UIImageView!
    @IBOutlet private weak var mile: UILabel!
    @IBOutlet private weak var timeEdgeView: UIView!
    @IBOutlet private weak var timeImage: UIImageView!
    @IBOutlet private weak var time: UILabel!
    var dataOfCell: CMPedometerData?
    private var circleShape: CAShapeLayer = CAShapeLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        drawProgressRing()
    }
    func reloadData(data: CMPedometerData?) {
        dataOfCell = data
        layoutIfNeeded()
        drawProgressRing()
        guard let data = data else { return  }
        guard let distance = data.distance, let pace = data.averageActivePace else {return}
        self.mile.text = ("\(String(format: "%.1f",(distance.doubleValue / 1000))) mil")
        self.sumStep.text = data.numberOfSteps.stringValue
        if pace.doubleValue != 0 {
            self.time.text = ("\((distance.doubleValue * pace.doubleValue / 60).toString()) m")
        }else {
            self.time.text = "_:_"
        }
        self.timeline.text = data.endDate.formatDate()
        self.caloBurned.text = ("\((distance.doubleValue * 70.0 / 1000 * 0.95 ).toString()) kcal")
        self.circleShape.strokeEnd = data.numberOfSteps.doubleValue / 10000
    }
    private func drawProgressRing(){
        //UIBezierPath
        let circlePath = UIBezierPath(arcCenter: .zero,
                                      radius: self.infomationCirleEdgeView.bounds.width / 2 - 20 ,
                                      startAngle: CGFloat(-0.5 * .pi),
                                      endAngle: CGFloat(1.5 * .pi),
                                        clockwise: true)
          // circle shape
        circleShape.position = self.infomationCirleEdgeView.center
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = UIColor.red.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 8
          // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = 0.0
          // add sublayer
        self.infomationCirleEdgeView.layer.addSublayer(circleShape)
    }
}
