//
//  AppDelegate.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import ParticleSDK

protocol AlarmApplicationDelegate
{

    func playAlarmSound(_ soundName: String)
   
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate, SparkDeviceDelegate{

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    
    func sparkDevice(_ device: SparkDevice, didReceive event: SparkDeviceSystemEvent) {
        print("Device "+device.name!+" received system event id "+String(event.rawValue))
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //alarmDelegate? = self
        //alarmDelegate!.setupNotificationSettings()
        
        alarmScheduler.setupNotificationSettings()
        window?.tintColor = UIColor.red
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        /*AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            vibrationCallback,
            nil)*/
        //if app is in foreground, show a alert
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        //todo, snooze
        var isSnooze: Bool = false
        var soundName: String = ""
        var index: Int = -1
        if let userInfo = notification.userInfo {
            isSnooze = userInfo["snooze"] as! Bool
            soundName = userInfo["soundName"] as! String
            index = userInfo["index"] as! Int
        }
        
        playAlarmSound(soundName)
       
        if isSnooze  == true
        {
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            //snooze 9 minutes later
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 9, to: now, options:.matchStrictly)!
            
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                
                self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
            }
            storageController.addAction(snoozeOption)
        }
        
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
            Alarms.sharedInstance.setEnabled(false, AtIndex: index)
            let vc = self.window?.rootViewController! as! UINavigationController
            let cells = (vc.topViewController as! MainAlarmViewController).tableView.visibleCells 
            for cell in cells
            {
                if cell.tag == index{
                    let sw = cell.accessoryView as! UISwitch
                    sw.setOn(false, animated: false)
                }
            }}
        
        storageController.addAction(stopOption)
        window?.rootViewController!.present(storageController, animated: true, completion: nil)
        
  
        
    }
    //notification handler, snooze
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void)
    {
        if identifier == "mySnooze"
        {
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 9, to: now, options:.matchStrictly)!
            var soundName: String = ""
            var index: Int = -1
            if let userInfo = notification.userInfo {
                soundName = userInfo["soundName"] as! String
                index = userInfo["index"] as! Int
            self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
        }
        }
        completionHandler()
    }
    //print out all registed NSNotification for debug
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("THis part here is to affirm my sanity.......  (: ")
        print(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playAlarmSound(_ soundName: String) {
        print("alarm played")

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = URL(
            fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
        
    
    
    
    //todo,vibration infinity
    func vibrationCallback(_ id:SystemSoundID, _ callback:UnsafeMutableRawPointer) -> Void
    {
        print("callback", terminator: "")
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully
        flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
        error: Error?) {
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func testCloudSDK()
    {
        let loginGroup : DispatchGroup = DispatchGroup()
        let deviceGroup : DispatchGroup = DispatchGroup()
        let priority = DispatchQoS.QoSClass.default
        let functionName = "testFunc"
        let variableName = "testVar"
        var myPhoton : SparkDevice? = nil
        var myEventId : AnyObject?
        
        
        // CHANGE THESE CONSANTS TO WHAT YOU NEED:
        let deviceName = ParticleAccountDetails.devices[0]
        let username = ParticleAccountDetails.uName!
        let password = ParticleAccountDetails.pWord!
        
        
        DispatchQueue.global(qos: priority).async {
            // logging in
            loginGroup.enter();
            deviceGroup.enter();
            if SparkCloud.sharedInstance().isAuthenticated {
                print("logging out of old session")
                SparkCloud.sharedInstance().logout()
            }
            
            SparkCloud.sharedInstance().login(withUser: username, password: password, completion: { (error : Error?) in  // or possibly: .injectSessionAccessToken("ec05695c1b224a262f1a1e92d5fc2de912c467a1")
                if let _ = error {
                    print("Wrong credentials or no internet connectivity, please try again")
                }
                else
                {
                    print("Logged in with user "+username) // or with injected token
                    loginGroup.leave()
                }
            })
        }
        
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = loginGroup.wait(timeout: DispatchTime.distantFuture)
            
            // get specific device by name:
            SparkCloud.sharedInstance().getDevices { (sparkDevices:[Any]?, error:Error?) -> Void in
                if let _=error
                {
                    print("Check your internet connectivity")
                }
                else
                {
                    if let devices = sparkDevices as? [SparkDevice]
                    {
                        for device in devices
                        {
                            if device.name == deviceName
                            {
                                print("found a device with name "+deviceName+" in your account")
                                myPhoton = device
                                deviceGroup.leave()
                            }
                            
                        }
                        if (myPhoton == nil)
                        {
                            print("device with name "+deviceName+" was not found in your account")
                        }
                    }
                }
            }
        }
        
        
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture)
            deviceGroup.enter();
            
            print("subscribing to event...");
            var gotFirstEvent : Bool = false
            myEventId = myPhoton!.subscribeToEvents(withPrefix: "test", handler: { (event: SparkEvent?, error:Error?) -> Void in
                if (!gotFirstEvent) {
                    print("Got first event: "+event!.event)
                    gotFirstEvent = true
                    deviceGroup.leave()
                } else {
                    print("Got event: "+event!.event)
                }
            }) as AnyObject?;
        }
        
        
        // calling a function
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            let funcArgs = ["D7",1] as [Any]
            myPhoton!.callFunction(functionName, withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
                if (error == nil) {
                    print("Successfully called function "+functionName+" on device "+deviceName)
                    deviceGroup.leave()
                } else {
                    print("Failed to call function "+functionName+" on device "+deviceName)
                }
            }
        }
        
        
        // reading a variable
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            myPhoton!.getVariable(variableName, completion: { (result:Any?, error:Error?) -> Void in
                if let _=error
                {
                    print("Failed reading variable "+variableName+" from device")
                }
                else
                {
                    if let res = result as? Int
                    {
                        print("Variable "+variableName+" value is \(res)")
                        deviceGroup.leave()
                    }
                }
            })
        }
        
        
        // get device variables and functions
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            let myDeviceVariables : Dictionary? = myPhoton!.variables as Dictionary<String,String>
            print("MyDevice first Variable is called \(myDeviceVariables!.keys.first) and is from type \(myDeviceVariables?.values.first)" as Any)
            
            let myDeviceFunction = myPhoton!.functions
            print("MyDevice first function is called \(myDeviceFunction.first)")
            deviceGroup.leave()
        }
        
        // logout
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            
            if let eId = myEventId {
                myPhoton!.unsubscribeFromEvent(withID: eId)
            }
            SparkCloud.sharedInstance().logout()
            
            print("logged out")
        }
        
    }
}

