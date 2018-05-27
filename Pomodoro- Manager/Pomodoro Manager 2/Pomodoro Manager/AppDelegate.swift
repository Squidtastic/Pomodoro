//
//  AppDelegate.swift
//  Pomodoro Manager
//
//  Created by Hong Wey on 25/05/18.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        configureCustomNotification()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func configureCustomNotification(){
        let go_for_break = UNNotificationAction(identifier:"GOFORBREAK",title:"Go For Break",options:[])
        let extend_break = UNNotificationAction(identifier:"EXTENDBREAK",title:"Extend Break",options:[])
        let end_pomodoro = UNNotificationAction(identifier:"ENDPOMODORO",title:"End Session",options:[UNNotificationActionOptions.foreground])
        let extend_pomodoro = UNNotificationAction(identifier:"EXTENDPOMODORO",title:"Extend Pomodoro",options:[])
        let go_to_pomodoro = UNNotificationAction(identifier:"GOTOPOMODORO",title:"Go To Pomodoro",options:[])
        
        let breaktime_category = UNNotificationCategory(identifier:"BREAKTIME_CATEGORY",actions:[go_for_break,extend_pomodoro,end_pomodoro],intentIdentifiers :[] , options:[])
        
        let pomodorotime_category = UNNotificationCategory(identifier:"POMODOROTIME_CATEGORY",actions:[go_to_pomodoro,extend_break,end_pomodoro],intentIdentifiers :[] , options:[])
        
        UNUserNotificationCenter.current().setNotificationCategories([breaktime_category,pomodorotime_category])
    }
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        playSound()
        completionHandler(.alert)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "ENDPOMODORO":
            player?.stop()
            NotificationCenter.default.post(name: Notification.Name("ENDPOMODOROSELECT"), object: nil)
            break
        case "GOTOPOMODORO":
            player?.stop()
            NotificationCenter.default.post(name: Notification.Name( "GOTOPOMODOROSELECT"), object: nil)
            break
        case "GOFORBREAK":
            player?.stop()
            NotificationCenter.default.post(name: Notification.Name("GOFORBREAKSELECT") , object: nil)
            break
        case "EXTENDBREAK":
            player?.stop()
            NotificationCenter.default.post(name: Notification.Name("EXTENDBREAKSELECT") , object: nil)
            break
        case "EXTENDPOMODORO":
            player?.stop()
            NotificationCenter.default.post(name: Notification.Name("EXTENDPOMODOROSELECT"),object: nil)
            break
        default:
            print("Invalid Identifier")
            break
        }
        completionHandler()
    }
}

