# Qiita記事
https://qiita.com/Imael/items/85ab1e339c16a3033a29
# はじめに
iOS設計パターン入門を読んでいてNotificationCenterがわからなかったのでメモ
# できるもの
ボタンでカウントアップして各ViewControllerに値が変わったことを伝える
<img width="150" alt="Simulator Screen Shot - iPhone 14 Pro - 2023-04-21 at 11.58.16.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2883687/c3c8ec8b-036f-3c4d-ae92-143d5aa70124.png">
カウント0のときボタンをタップしたら、
<img width="150" alt="Simulator Screen Shot - iPhone 14 Pro - 2023-04-21 at 11.58.16.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2883687/795768ae-1e09-8df5-d122-041e7cda19de.png"><img width="150" alt="Simulator Screen Shot - iPhone 14 Pro - 2023-04-21 at 11.58.16.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2883687/65e1f1bc-5c77-dcf2-573c-5450c3f4741a.png">
各VCに通知されカウントの値が反映される

# CountModel.swiftを作成
Modelとなるものです。
今回はCountModelに通知を出すnotificationCenter.postを作成してます。
```swift
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
```
# 各ストーリーボードとViewControllerを作成
カウントアップするボタンとラベルを置いてます。
![スクリーンショット 2023-04-21 12.22.37.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2883687/a9a293f2-db6b-6914-5aae-3130a308362f.png)




```swift
import UIKit

class RedViewController: UIViewController {
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countButton: UIButton!
    @IBAction private func tapped(_ sender: Any) {
        countModel?.countUp()
    }

    // MainTabBarControllerからViewControllerにモデルを渡しています
    //　MainTabBarControllerが呼ばれたらdidSetでregisterModel()も呼ばれるのでNotificationCenterクラスへの登録完了
    // 登録してから通知を出さなきゃきけない
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
```
名前と色だけ変えた同じ構成のストーリーボードとViewControllerを3つ作成します。




# MainTabBarControllerを作成
ここでViewControllerの外からModelを渡してるのがポイント
iOS設計パターン入門を読んでこの書き方を知りました!
```swift
import UIKit
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
    }

    func initTabBar() {

        guard let redVC = UIStoryboard(name: "Red", bundle: nil).instantiateInitialViewController() as? RedViewController else {
            return
        }
        // ここでViewControllerにモデルを渡しています
        redVC.countModel = CountModel.shared
        redVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let redNVC = UINavigationController(rootViewController: redVC)


        guard let blueVC = UIStoryboard(name: "Blue", bundle: nil).instantiateInitialViewController() as? BlueViewController else {
            return
        }
        blueVC.countModel = CountModel.shared
        blueVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let blueNVC = UINavigationController(rootViewController: blueVC)

        guard let greenVC = UIStoryboard(name: "Green", bundle: nil).instantiateInitialViewController() as? GreenViewController else {
            return
        }
        greenVC.countModel = CountModel.shared
        greenVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        let greenNVC = UINavigationController(rootViewController: greenVC)

        setViewControllers([redNVC, blueNVC, greenNVC], animated: false)

    }
}
```



# MainTabBarControllerを起動画面にする
タブ画面から起動させるので下記の記事を参考に
https://qiita.com/Imael/items/e908aef1e6fc077f29fc

#### プロジェクトからMain.storyboardとViewControllerを削除
#### TARGETSのinfoのCustom iOS Target Propertiesの　→　Main storyboard file base nameを削除
#### TARGETSのinfoのCustom iOS Target PropertiesのApplication Scene Manifest　→ Scene Configuration→ Application SessionRole　→Item 0(default Configuration)→Storyboard Nameを削除

### SceneDelegate.swiftの変更
下記コードに書き換えます。
```swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       // 起動時の画面をMainTabBarController()に設定
        guard let scene = (scene as? UIWindowScene) else { return }
                window = UIWindow(windowScene: scene)
                window?.rootViewController = MainTabBarController()
                window?.makeKeyAndVisible()
    }
}
```

# おわりに
間違い等ありましたら教えてください！
サンプルです
https://github.com/kabikira/SampleNotificationCenter
# 参考
iOS設計パターン入門
https://peaks.cc/books/iOS_architecture
iOS設計パターン入門のサンプルコード
https://github.com/peaks-cc/iOS_architecture_samplecode
［増補改訂第3版］Swift実践入門
https://qiita.com/st43/items/ab76494ce6e33a90371e
https://qiita.com/Tatsuya_ss0121/items/f1ae1e7d4c5bca08c70b
