//
//  OnboardingSoundManager.swift
//  bigbruhh
//
//  Sound effects and ambient music manager for onboarding
//  Migrated from: nrn/components/onboarding/useOnboardingSound.ts
//

import Foundation
import AVFoundation

class OnboardingSoundManager: ObservableObject {
    // MARK: - Audio Players

    private var subBassPlayer: AVAudioPlayer?
    private var tickingPlayer: AVAudioPlayer?
    private var successPlayer: AVAudioPlayer?
    private var glitchPlayer: AVAudioPlayer?
    private var glitchLongPlayer: AVAudioPlayer?

    @Published var isAmbientPlaying = false
    private var currentAmbientFile: String?

    // MARK: - Initialization

    init() {
        setupAudioSession()
        loadAudioPlayers()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("⚠️ Failed to setup audio session: \(error)")
        }
    }

    private func loadAudioPlayers() {
        // Ambient loops
        subBassPlayer = loadAudio(named: "sub_bass", type: "mp3", volume: 0.12)
        subBassPlayer?.numberOfLoops = -1 // Infinite loop

        tickingPlayer = loadAudio(named: "ticking-clock", type: "mp3", volume: 0.06)
        tickingPlayer?.numberOfLoops = -1

        // Sound effects (one-shots)
        successPlayer = loadAudio(named: "success", type: "mp3", volume: 0.3)
        glitchPlayer = loadAudio(named: "glitch", type: "mp3", volume: 0.4)
        glitchLongPlayer = loadAudio(named: "glitch-long", type: "mp3", volume: 0.02)
    }

    private func loadAudio(named name: String, type: String, volume: Float) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else {
            print("⚠️ Audio file not found: \(name).\(type)")
            return nil
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            return player
        } catch {
            print("⚠️ Failed to load audio \(name): \(error)")
            return nil
        }
    }

    // MARK: - Ambient Music Logic

    /// Determines which ambient audio to play based on phase and step type
    private func getContextualAudio(phase: OnboardingPhase, stepType: StepType, recordingTime: TimeInterval? = nil) -> String? {
        // Voice step logic
        if stepType == .voice {
            if let time = recordingTime, time > 30 {
                return "sub_bass"
            }
            if [.patternAwareness, .patternAnalysis].contains(phase) {
                return "ticking"
            }
        }

        // Phase-based logic
        if [.commitmentSystem, .externalAnchors, .finalOath].contains(phase) {
            return "ticking"
        }

        return nil
    }

    /// Update ambient music based on current step
    func updateAmbientForStep(phase: OnboardingPhase, stepType: StepType, recordingTime: TimeInterval? = nil) {
        let selection = getContextualAudio(phase: phase, stepType: stepType, recordingTime: recordingTime)

        guard let audioFile = selection else {
            if isAmbientPlaying {
                stopAmbient()
            }
            return
        }

        // Don't restart if already playing the correct file
        if currentAmbientFile == audioFile {
            return
        }

        playAmbient(audioFile)
    }

    private func playAmbient(_ kind: String) {
        stopAmbient()

        let player: AVAudioPlayer?
        switch kind {
        case "sub_bass":
            player = subBassPlayer
        case "ticking":
            player = tickingPlayer
        default:
            return
        }

        player?.currentTime = 0
        player?.play()

        currentAmbientFile = kind
        isAmbientPlaying = true

        print("🎵 Playing ambient: \(kind)")
    }

    func stopAmbient() {
        subBassPlayer?.pause()
        tickingPlayer?.pause()
        isAmbientPlaying = false
        currentAmbientFile = nil
    }

    // MARK: - Sound Effects

    /// Play success sound on step completion
    func playSuccess() {
        successPlayer?.currentTime = 0
        successPlayer?.play()
    }

    /// Play glitch sound for phase transitions
    func playGlitch() {
        glitchPlayer?.currentTime = 0
        glitchPlayer?.play()
    }

    /// Play sharp snap sound for ritual moments
    func playSnap() {
        successPlayer?.volume = 0.45
        successPlayer?.currentTime = 0
        successPlayer?.play()

        // Reset volume for normal success sounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.successPlayer?.volume = 0.3
        }
    }

    /// Play long glitch sound for seal completion (very quiet)
    func playGlitchLong() {
        glitchLongPlayer?.currentTime = 0
        glitchLongPlayer?.play()
    }

    // MARK: - Cleanup

    deinit {
        stopAmbient()
    }
}
