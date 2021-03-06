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
import UserNotifications

protocol AlarmApplicationDelegate {
    func playAlarmSound(_ soundName: String)
    func brewCoffee()
    func setAlarmOnParticle(alarmString: String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, UNUserNotificationCenterDelegate, AlarmApplicationDelegate, SparkDeviceDelegate{

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
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if((error != nil)) {
                print("Request authorization failed!")
            }
            else {
                print("Request authorization succeeded!")
                self.alarmScheduler.setupNotificationSettings()
                self.window?.tintColor = UIColor.red
                //self.showAlert()
            }
        }
        return true
    }
    
    /*func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
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
            print("Snooze index is \(index)")
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
            print("Stop index is \(index)")
            //Alarms.sharedInstance.setEnabled(false, AtIndex: index)
            //let sb = UIStoryboard(name: "Main", bundle: nil)
            //let mainVC = sb.instantiateViewController(withIdentifier: "MainVC")
            self.brewCoffee()
            
        }
        
        storageController.addAction(stopOption)
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
                vc?.present(storageController, animated: true, completion: nil)
            }else{
                window?.rootViewController!.present(storageController, animated: true, completion: nil)
            }
        }
    }*/
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
        //if app is in foreground, show a alert
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        
        var isSnooze: Bool = false
        var soundName: String = ""
        var index: Int = -1
        
        let userInfo = response.notification.request.content.userInfo
        isSnooze = userInfo[("snooze")] as! Bool
        soundName = userInfo["soundName"] as! String
        index = userInfo["index"] as! Int
        
        print("If there is nothing here then shits fucked:  \(soundName)")
        
        playAlarmSound(soundName)
        
        if isSnooze  == true
        {
            print("Snooze index is \(index)")
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
            print("Stop index is \(index)")
            //Alarms.sharedInstance.setEnabled(false, AtIndex: index)
            //let sb = UIStoryboard(name: "Main", bundle: nil)
            //let mainVC = sb.instantiateViewController(withIdentifier: "MainVC")
            self.brewCoffee()
            
        }
        
        storageController.addAction(stopOption)
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
                vc?.present(storageController, animated: true, completion: nil)
            }else{
                window?.rootViewController!.present(storageController, animated: true, completion: nil)
            }
        }
    }
    
    //TODO:  Change this snooze system when notifications are working
    //notification handler, snooze
    /*func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void)
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
    }*/
    
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
    
    
    /// Logs into the Particle Cloud
    ///
    /// - Parameters:
    ///   - username: Particle Username
    ///   - password: Particle Password
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - loginGroup: Dispatch Group for Login
    ///   - deviceGroup: Device Group for retrieving Device info
    func particleLogin(username: String, password: String, priority: DispatchQoS.QoSClass, loginGroup: DispatchGroup, deviceGroup: DispatchGroup){
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
    }
    
    
    /// Returns the SparkDevice with specified name
    ///
    /// - Parameters:
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - loginGroup: Dispatch Group for Login
    ///   - deviceGroup: Device Group for retrieving Device info
    ///   - deviceName: Particle Device name
    /// - Returns: returns the Particle Device object or nil if not found
    func getParticleDevice(priority: DispatchQoS.QoSClass, loginGroup: DispatchGroup, deviceGroup: DispatchGroup, deviceName: String, myPhotonPointer: UnsafeMutablePointer<SparkDevice?>){
        
        let devicePointer = UnsafeMutablePointer<SparkDevice?>(myPhotonPointer)
        
        if devicePointer.pointee == nil {
            print("WTF I thought u and me were bros device?  Where are you?")
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
                                devicePointer.pointee = device
                                deviceGroup.leave()
                            }
                            
                        }
                        if (devicePointer.pointee == nil)
                        {
                            print("device with name "+deviceName+" was not found in your account")
                        }
                    }
                }
            }
        }
    }
    
    
    /// Subscribe to Particle Cloud event with prefix
    ///
    /// - Parameters:
    ///   - prefix: event prefix to listen for
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - deviceGroup: Device Group for retrieving Device info
    ///   - myPhoton: Particle Device transmitting the event
    /// - Returns: Returns the event Id
    func subscribeToEventWithPrefix(prefix: String, priority: DispatchQoS.QoSClass, deviceGroup: DispatchGroup, myPhotonPointer: UnsafePointer<SparkDevice?>, myEventIdPointer: UnsafeMutablePointer<AnyObject?>){
        
        let devicePointer = UnsafePointer<SparkDevice?>(myPhotonPointer)
        let eventIdPointer = UnsafeMutablePointer<AnyObject?>(myEventIdPointer)
        
        // MARK:  This code is used to subscribe to an event
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture)
            deviceGroup.enter();
            
            print("subscribing to event...");
            var gotFirstEvent : Bool = false
            eventIdPointer.pointee = devicePointer.pointee?.subscribeToEvents(withPrefix: prefix, handler: { (event: SparkEvent?, error:Error?) -> Void in
                if (!gotFirstEvent) {
                    print("Got first event: "+event!.event)
                    gotFirstEvent = true
                    deviceGroup.leave()
                } else {
                    print("Got event: "+event!.event)
                }
            }) as AnyObject?;
        }
    }
    
    
    /// Calls this registered function on the Particle Device
    ///
    /// - Parameters:
    ///   - functionName: Registered name for the particle function
    ///   - functionArguments: Arguments sent to the devices function
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - deviceGroup: Device Group for retrieving Device info
    ///   - myPhoton: Particle Device
    func callParticleFunction(functionName: String, functionArguments: [Any], priority: DispatchQoS.QoSClass, deviceGroup: DispatchGroup, myPhotonPointer: UnsafePointer<SparkDevice?>){
        
        let myDevicePointer = UnsafePointer<SparkDevice?>(myPhotonPointer)
        
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            myDevicePointer.pointee?.callFunction(functionName, withArguments: functionArguments) { (resultCode : NSNumber?, error : Error?) -> Void in
                if (error == nil) {
                    print("Successfully called function "+functionName)
                    deviceGroup.leave()
                } else {
                    print("Failed to call function "+functionName)
                }
            }
        }
    }
    
    
    /// Read a registered device variable from the Particle Device
    ///
    /// - Parameters:
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - deviceGroup: Device Group for retrieving Device info
    ///   - myPhoton: Particle Device
    ///   - variableName: Name of the varibale to be read
    func readDeviceVariable(priority: DispatchQoS.QoSClass, deviceGroup: DispatchGroup, myPhotonPointer: UnsafePointer<SparkDevice?>, variableName: String){
        
        let myDevicePointer = UnsafePointer<SparkDevice?>(myPhotonPointer)
        
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            myDevicePointer.pointee?.getVariable(variableName, completion: { (result:Any?, error:Error?) -> Void in
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
    }
    
    //  TODO:  Create a function for this shit like the ones above
    /*
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
     }*/
    
    
    /// Log out of your particle account and unsubscribe from an event (If you want to)
    ///
    /// - Parameters:
    ///   - priority: Priority Queue for Dispatch Queue
    ///   - deviceGroup: Device Group for retrieving Device info
    ///   - eventId: The event Id you want to unsubscribe from.  Leave as nil if there is nothing to unsubscribe from
    ///   - myPhoton: Particle Device
    func particleLogoutAndUnsubscribe(priority: DispatchQoS.QoSClass, deviceGroup: DispatchGroup, myEventIdPonter: UnsafePointer<AnyObject?>, myPhotonPointer: UnsafePointer<SparkDevice?>){
        
        let myDevicePointer = UnsafePointer<SparkDevice?>(myPhotonPointer)
        let myEventIdPointer = UnsafePointer<AnyObject?>(myEventIdPonter)
        
        // logout
        DispatchQueue.global(qos: priority).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            
            if let eId = myEventIdPointer.pointee {
                myDevicePointer.pointee?.unsubscribeFromEvent(withID: eId)
            }
            SparkCloud.sharedInstance().logout()
            
            print("logged out")
        }
    }
    
    /// Sets an alarm on the particle device.
    ///
    /// - Parameter alarmString: A string version of the Unix Epoch Timestamp for the alarm
    func setAlarmOnParticle(alarmString: String){
        print("Setting the particle alarm from the AppDelegate")
        let loginGroup : DispatchGroup = DispatchGroup()
        let deviceGroup : DispatchGroup = DispatchGroup()
        let priority = DispatchQoS.QoSClass.default
        let functionName = "addAlarmFunc"
        var myPhoton : SparkDevice? = nil
        var myEventId : AnyObject?
        
        // CHANGE THESE CONSANTS TO WHAT YOU NEED:
        let deviceName = ParticleAccountDetails.devices[0]
        let username = UserDefaults.standard.string(forKey: "username")!
        let password = UserDefaults.standard.string(forKey: "password")!
        
        //  Login
        particleLogin(username: username, password: password, priority: priority, loginGroup: loginGroup, deviceGroup: deviceGroup);
        
        //  Get device
        getParticleDevice(priority: priority, loginGroup: loginGroup, deviceGroup: deviceGroup, deviceName: deviceName, myPhotonPointer: &myPhoton)
        
        //  If we have a device lets subscribe to the event with prefix 'Coffee'
        subscribeToEventWithPrefix(prefix: "Coffee", priority: priority, deviceGroup: deviceGroup, myPhotonPointer: &myPhoton, myEventIdPointer: &myEventId)
        
        //  If we have a device call the function
        let funcArgs = ["D7"] as [Any]
        callParticleFunction(functionName: functionName, functionArguments: funcArgs, priority: priority, deviceGroup: deviceGroup, myPhotonPointer: &myPhoton)
        
        //  If we have a device lets log out
        particleLogoutAndUnsubscribe(priority: priority, deviceGroup: deviceGroup, myEventIdPonter: &myEventId, myPhotonPointer: &myPhoton)
    }
    
    func brewCoffee()
    {
        print("Brewing Coffee from the AppDelegate")
        let loginGroup : DispatchGroup = DispatchGroup()
        let deviceGroup : DispatchGroup = DispatchGroup()
        let priority = DispatchQoS.QoSClass.default
        let functionName = "onOffFunc"
        var myPhoton : SparkDevice? = nil
        var myEventId : AnyObject?
        
        // CHANGE THESE CONSANTS TO WHAT YOU NEED:
        let deviceName = ParticleAccountDetails.devices[0]
        let username = UserDefaults.standard.string(forKey: "username")!
        let password = UserDefaults.standard.string(forKey: "password")!
        
        //  Log in
        particleLogin(username: username, password: password, priority: priority, loginGroup: loginGroup, deviceGroup: deviceGroup);
        
        //  Get device
        getParticleDevice(priority: priority, loginGroup: loginGroup, deviceGroup: deviceGroup, deviceName: deviceName, myPhotonPointer: &myPhoton)
        
        //  If we have a device lets subscribe to the event with prefix 'Coffee'
        subscribeToEventWithPrefix(prefix: "Coffee", priority: priority, deviceGroup: deviceGroup, myPhotonPointer: &myPhoton, myEventIdPointer: &myEventId)

        
        //  If we have a device call the function
        let funcArgs = ["D7",1] as [Any]
        callParticleFunction(functionName: functionName, functionArguments: funcArgs, priority: priority, deviceGroup: deviceGroup, myPhotonPointer: &myPhoton)

        
        //  If we have a device lets log out
        //particleLogoutAndUnsubscribe(priority: priority, deviceGroup: deviceGroup, myEventIdPonter: &myEventId, myPhotonPointer: &myPhoton)
        
    }

}

