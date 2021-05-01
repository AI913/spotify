//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by 招耀華 on 19/4/2021.
//

import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.queuePlayer, !tracks.isEmpty {
            return tracks[index]
        }
        
        return nil
    }
    
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.3
        
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        self.tracks = tracks
        self.track = nil
        
        self.queuePlayer = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        
        self.queuePlayer?.volume = 0.3
        self.queuePlayer?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = queuePlayer {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }
        else if let player = queuePlayer
         {
            queuePlayer?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = queuePlayer?.items().first{
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            queuePlayer = AVQueuePlayer(items: [firstItem])
            queuePlayer?.play()
            queuePlayer?.volume = 0.3
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}
