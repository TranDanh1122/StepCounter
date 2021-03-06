//
//  OneWeekStepDetailCell.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import UIKit
import CoreMotion
class CollectionViewCustomLayout: UICollectionViewFlowLayout {
    static var shared: CollectionViewCustomLayout = CollectionViewCustomLayout()
    var currentPage: Int = 0
    var oldOffset: CGFloat = 0.0
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collection = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let numberOfItemInSection = collection.numberOfItems(inSection: 0)
        //lướt qua phải
        if collection.contentOffset.x > oldOffset, velocity.x > 0.0 {
            currentPage = min(currentPage + 1, numberOfItemInSection-1)
        }else if collection.contentOffset.x < oldOffset, velocity.x < 0.0 { //lướt qua trái
            currentPage = max(currentPage - 1, 0)
        }
        // chiều rôngj của collection
        let collectionWidth = collection.frame.width
        // chiều rộng của 1 cái item
        let itemWidth = itemSize.width
        // khoảng cánh giữa mấy cái item
        let spacing = minimumLineSpacing
        // độ rộng 2 biên ngoài cùng
        let edge = (collectionWidth - itemWidth - spacing * 2)/2
        // vị trí hiện tại  = (độ rộng item + khoảng cách giữa 2 item) * số trang hiện tại - (biên + khoảng cách giữa 2 item)
        let offset = (itemWidth + spacing)  * CGFloat(currentPage) - (edge + spacing)
        oldOffset = offset
        // y không đổi vì sẽ lăn theo chiều ngang
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
}
protocol OneWeekStepDetailCellDelegate: class {
    func didScrollToAnotherItem(currentPage: Int)
}
class OneWeekStepDetailCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var collectionViewDataSource: CMPedometerData? {
        didSet {
            print("this is reload data point at \(IndexPath(row: layout.currentPage, section: 0))")
            collectionView.reloadItems(at: [IndexPath(row: currentViewPage, section: 0)])
        }
    }
    private var notificationName = Notification.Name.init(rawValue: "reloadTableCellDataWhenShake")
    let layout = CollectionViewCustomLayout.shared
    private var currentViewPage: Int = 0
    weak var delegate: OneWeekStepDetailCellDelegate?
    //deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    //config view
    override func awakeFromNib() {
        super.awakeFromNib()
        currentViewPage = layout.currentPage
        setupSubview()
        observableUpdateDataEvent()
    }
    override func layoutSubviews() {
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 416)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func setupSubview() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        register(cellName: "OneDateStepDetailCell")
    }
    private func register(cellName: String) {
        collectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
    }
    // config data of view
    func reloadData(data: CMPedometerData?){
        collectionViewDataSource = data
        
    }
    private func observableUpdateDataEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWhenDataSourceUpdate(_:)), name: notificationName, object: nil)
    }
    @objc func reloadDataWhenDataSourceUpdate(_ noti : Notification) {
        if let data = noti.userInfo?["dataSource"] as? CMPedometerData {
            DispatchQueue.main.async {
                self.collectionViewDataSource = data
            }
        } else {
            print("data error")
        }
    }
}
extension OneWeekStepDetailCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneDateStepDetailCell", for: indexPath) as? OneDateStepDetailCell
        guard let cell = cell else { return OneDateStepDetailCell() }
        cell.reloadData(data: collectionViewDataSource)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if layout.currentPage != currentViewPage {
            delegate?.didScrollToAnotherItem(currentPage: layout.currentPage)
        }
        currentViewPage = layout.currentPage
    }
}
