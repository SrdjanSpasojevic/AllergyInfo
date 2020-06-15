//
//  LocalNotificationManager.swift
//  AllergyInfo
//
//  Created by TBP on 10/3/18.
//  Copyright © 2018 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationCategorie: String
{
    case welcome = "welcome"
    case critical = "critical"
    case dailyReport = "dailyReport"
}

class NotificationRequest: NSObject {
    var request: UNNotificationRequest
    var isNotificationSeen: Bool = false
    
    init(request: UNNotificationRequest) {
        self.request = request
    }
}

class LocalNotificationManager: NSObject
{
    var badgeCountNumber = 0
    
    static let engine = LocalNotificationManager()
    
    private var notificationRequests: [NotificationRequest] = []
    
    /**
     Mechanism for creating and firing local notifications.
     
     - Title: Title of the notification.
     - Body: Body of the notification.
     - FireOnTime: When do you want notification to fire.
     */
    
    public func createNotification(title: String, body: String, categoryID: NotificationCategorie, fireIn timeInterval: TimeInterval)
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            for request in requests
            {
                for notifcationRequest in self.notificationRequests
                {
                    if request.identifier == notifcationRequest.request.identifier
                    {
                        return
                    }
                }
            }
        }
            
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = NSNumber(value: 0)
        content.sound = UNNotificationSound.default()
        
        //Setting time for notification trigger
        let date = Date(timeIntervalSinceNow: timeInterval)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Adding Request
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        let customRequest = NotificationRequest(request: request)
        self.notificationRequests.append(customRequest)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @objc func setIsNotificationSeen() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func updateRequests() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            for request in requests
            {
                for notifcationRequest in self.notificationRequests
                {
                    if request.identifier == notifcationRequest.request.identifier,
                        notifcationRequest.isNotificationSeen
                    {
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notifcationRequest.request.identifier])
                    }
                }
            }
            
        }
    }
}
