import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    weak var screen : UIView? = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      self.listenToTakeScreenshot();
      
      self.listenToTakeScreenRecording();
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func applicationWillResignActive(
      _ application: UIApplication
    ) {
        blurScreen()
    }
    override func applicationDidBecomeActive(
      _ application: UIApplication
    ) {
        removeBlurScreen()
    }

    
    private func listenToTakeScreenRecording() {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(
              forName: UIScreen.capturedDidChangeNotification,
              object: nil,
              queue: .main) { notification in
          
                  DispatchQueue.main.async {
                      if self.window?.isHidden == false{
                          self.hideScreen()
                      }
                      
                  }
              }
        } else {
        }
    }
    
    private func listenToTakeScreenshot() {
        NotificationCenter.default.addObserver(
          forName: UIApplication.userDidTakeScreenshotNotification,
          object: nil,
          queue: .main) { notification in
              
              if self.window?.isHidden == false{
                  self.blurScreen();
              }
            }
    }
    
    private func hideScreen() {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                self.blurScreen();
            } else {
                self.removeBlurScreen();
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
        screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        screen?.addSubview(blurBackground)
        blurBackground.frame = (screen?.frame)!
        window?.addSubview(screen!)
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
    }
    
}
