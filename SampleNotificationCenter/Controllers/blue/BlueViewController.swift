//
//  BuleViewController.swift
// SampleNotificationCenter
//
//  Created by koala panda on 2023/04/20.
//

import UIKit

class BlueViewController: UIViewController {

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countButton: UIButton!
    @IBAction private func tapped(_ sender: Any) {
        countModel?.countUp()
    }


    var countModel: CountModel? {
        didSet {
            registerModel()
        }
    }

    private func registerModel() {
        guard let model = countModel else { return }

        model.notificationCenter.addObserver(forName: .init(rawValue: "count"), object: nil, queue: nil, using: { [weak self] notification in
                if let count = notification.userInfo?["count"] as? Int {
                    self?.countLabel?.text = "\(count)"
                }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = countModel?.count.description

    }

}

