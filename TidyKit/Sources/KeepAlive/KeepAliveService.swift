//
//  KeepAliveService.swift
//  KeepAliveService
//
//  Created by wh on 2024/3/6.
//

import UIKit
import AVFoundation

class KeepAliveService: NSObject {
    
    /// Audio playback time interval, set according to their own specific situation,
    /// too short interval may lead to increased power consumption,
    /// too long interval may lead to failure to keep alive.
    var audioPlayTimeInterval: TimeInterval = 5
    
    private var isEnable: Bool { enableCallback?() ?? false }
    private var enableCallback: (() -> Bool)?
    private var isBackground = false
    private var backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    private let kBackgroundTask = "com.keepalive.background.task"
    
    private var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        addMonitor(#selector(enterBackgroundNotificationDidArrived(_:)), UIApplication.didEnterBackgroundNotification)
        addMonitor(#selector(becomeActiveNotificationDidArrived(_:)), UIApplication.didBecomeActiveNotification)
        addMonitor(#selector(interruptionNotificationDidArrived(_:)), AVAudioSession.interruptionNotification)
        addMonitor(#selector(routeChangeNotificationDidArrived(_:)), AVAudioSession.routeChangeNotification)
    }
    
    deinit {
        delMonitor(UIApplication.didEnterBackgroundNotification)
        delMonitor(UIApplication.didBecomeActiveNotification)
        delMonitor(AVAudioSession.interruptionNotification)
        delMonitor(AVAudioSession.routeChangeNotification)
        
        stopBackgroundTask()
        stopAudioPlay()
    }
    
    func setEnable(_ callback: @escaping () -> Bool) {
        enableCallback = callback
    }
}

private extension KeepAliveService {
    
    func addMonitor(_ selector: Selector, _ name: NSNotification.Name) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func delMonitor(_ name: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc func enterBackgroundNotificationDidArrived(_ notification: Notification) {
        isBackground = true
        if isEnable {
            startBackgroundTask()
        }
        printLog("App enter background")
    }
    
    @objc func becomeActiveNotificationDidArrived(_ notification: Notification) {
        isBackground = false
        stopBackgroundTask()
        stopAudioPlay()
        
        printLog("App become active")
    }
    
    @objc func interruptionNotificationDidArrived(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let interType = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        switch interType {
        case .began:
            stopAudioPlay()
            
        case .ended:
            guard let optValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let interOpt = AVAudioSession.InterruptionOptions(rawValue: optValue)
            switch interOpt {
            case .shouldResume:
                resumeAudioPlay()
                
            default:
                break
            }
        default:
            break
        }
    }
    
    @objc func routeChangeNotificationDidArrived(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt else {
            return
        }
        guard let reasonValueType = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        switch reasonValueType {
        case .oldDeviceUnavailable:
            resumeAudioPlay()
            
        default: break
        }
    }
    
    func startBackgroundTask() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: kBackgroundTask) { [weak self] in
            guard let self = self else { return }
            self.stopBackgroundTask()
            self.startAudioPlay()
        }
    }
    
    func stopBackgroundTask() {
        if backgroundTaskIdentifier == .invalid {
            return
        }
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        backgroundTaskIdentifier = .invalid
        
        printLog("Stop background task")
    }
    
    @objc func startAudioPlay() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startAudioPlay), object: nil)
        guard isEnable, isBackground else { return }
        
        if let player = audioPlayer {
            if player.play(atTime: .zero) {
                perform(#selector(startAudioPlay), with: nil, afterDelay: audioPlayTimeInterval)
                printLog("Audio play success")
            }
        }
        else {
            guard let fileURL = Bundle.main.url(forResource: "mute", withExtension: "caf") else {
                printLog("Load source error")
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: fileURL)
                player.volume = 0
                player.numberOfLoops = 1
                player.delegate = self
                player.prepareToPlay()
                if player.play() {
                    perform(#selector(startAudioPlay), with: nil, afterDelay: audioPlayTimeInterval)
                }
                audioPlayer = player
                
            } catch {
                printLog("Create audio player error: \(error)")
            }
        }
    }
    
    func stopAudioPlay() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startAudioPlay), object: nil)
        
        guard let player = audioPlayer, player.isPlaying else {
            return
        }
        player.pause()
        
        printLog("Stop audio play")
    }
    
    func resumeAudioPlay() {
        guard backgroundTaskIdentifier == .invalid else {
            return
        }
        startAudioPlay()
    }
    
    func printLog(_ log: String) {
#if DEBUG
        print("#KeepAliveService#<<\(log)>>")
#endif
    }
}

extension KeepAliveService: AVAudioPlayerDelegate {
 
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        printLog("Audio player did finish playing")
    }
}
