//
//  Scheduler.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 16/1/15.
//  Copyright (c) 2016年 LongGames. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol AlarmSchedulerDelegate
{
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify:[Int], snooze: Bool, soundName: String, index: Int)
    func setupNotificationSettings()
    func reSchedule()
}


class Scheduler : AlarmSchedulerDelegate
{
    func setupNotificationSettings() {
        print("We settin up these notifications or shittin our pants")
        
        let newStopAction = UNNotificationAction(identifier: "myStop", title: "OK", options: [])
        
        let newSnoozeAction = UNNotificationAction(identifier: "mySnooze", title: "Snooze", options: [])
        
        let newActionsArray = [newStopAction, newSnoozeAction]

        let newAlarmCategory = UNNotificationCategory(identifier: "myAlarmCategory", actions: newActionsArray, intentIdentifiers: [], options: [.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([newAlarmCategory])
    }
    
    fileprivate func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var correctedDate: [Date] = [Date]()
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        //var nowComponents = calendar.components(flags, fromDate: now)
        let weekday:Int = dateComponents.weekday!
        
        if weekdays.isEmpty{
            //date is eariler than current time
            if date.compare(now) == ComparisonResult.orderedAscending
            {
                
                correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
                //later
            else
            {
                correctedDate.append(date)
            }
            return correctedDate
        }
        else
        {
            let daysInWeek = 7
            correctedDate.removeAll(keepingCapacity: true)
            for wd in weekdays
            {
                
                var wdDate: Date!
                //if date.compare(now) == NSComparisonResult.OrderedAscending
                if wd < weekday
                {
                    
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
                }
                else if wd == weekday
                {
                    if date.compare(now) == ComparisonResult.orderedAscending
                    {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                    }
                    //later
                    wdDate = date
                    
                }
                else
                {
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
                }
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
        
        
    }
    
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify weekdays:[Int], snooze: Bool, soundName: String, index: Int) {

        //  Updated Notifications
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Open App", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
        content.sound = UNNotificationSound.init(named: soundName + ".caf")
        content.categoryIdentifier = "myAlarmCategory"
        
        content.userInfo = ["snooze" : snooze, "index": index, "soundName": soundName]
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        print("Date Components:  ")
        
        for d in datesForNotification
        {
            print("Garn for the trigger.  Here d d \(d)")
 
            let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: d)
            dump(dateComponent)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
        
    }
    
    func reSchedule() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        for i in 0..<Alarms.sharedInstance.count{
            let alarm = Alarms.sharedInstance[i]
            if alarm.enabled{
                setNotificationWithDate(alarm.date as Date, onWeekdaysForNotify: alarm.repeatWeekdays, snooze: alarm.snoozeEnabled, soundName: alarm.mediaLabel, index: i)
            }
        }
    }
}
