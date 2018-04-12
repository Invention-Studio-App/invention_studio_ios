import AVFoundation

class SoundHelper {
    static let sharedHelper = SoundHelper()
    var audioPlayer: AVAudioPlayer?

    func playSound() {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "pop", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.setVolume(0.7, fadeDuration: 0)
            audioPlayer!.numberOfLoops = 0
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
