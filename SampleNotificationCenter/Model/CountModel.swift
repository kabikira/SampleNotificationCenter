//
//  CountModel.swift
// SampleNotificationCenter
//
//  Created by koala panda on 2023/04/20.
//

import Foundation

final class CountModel {
    // 値を共有したいのでシングルトンにしてます
    static var shared: CountModel = .init()

    private init() {}
    let notificationCenter = NotificationCenter()
    // private(set)は変更できないようにアクセス制限するが読み取りは可能
    // countに変更があったら通知を出す
    private(set) var count = 0 {
        didSet {
            notificationCenter.post(name: .init(rawValue: "count"), object: nil, userInfo: ["count": count])
        }
    }
    func countUp() {
        count += 1
    }
}
