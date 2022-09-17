//
//  NotificationManager.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/6/21.
//

import SwiftUI
import Combine

public class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate{
    public static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    @Published public var isGranted = false
    public let refreshSettingsPublisher = PassthroughSubject<Void, Never>()
    
    public func requestAuthorization() async throws{
        notificationCenter.delegate = self
        isGranted = false
        try await notificationCenter.requestAuthorization(options:[.sound, .badge, .alert])
        await getCurrentSettings()
        refreshSettingsPublisher.sink { _ in
            Task{
                await self.getCurrentSettings()
            }
        }.retain()
    }
    
    func getCurrentSettings() async {
        let settings =  await notificationCenter.notificationSettings()
        isGranted = settings.authorizationStatus == .authorized
    }
    
    @available(iOSApplicationExtension, unavailable)
    @MainActor
    public func openSettings(){
        if let url = UIApplication.openSettingsURLString.url{
            if(UIApplication.shared.canOpenURL(url)){
                Task{
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    public func scheduleLocalNotification(title:String, body:String, sound: UNNotificationSound = .default, delay: TimeInterval = 0){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        let delay = delay <= 0 ? TimeInterval.leastNonzeroMagnitude : delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: title + body, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    // delegate
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
}



