import AVFoundation
import Foundation
//import Combine

class MicrophoneService: ObservableObject {

//    let objectWillChange = PassthroughSubject<MicrophoneService, Never>()
    var audioRecorder: AVAudioRecorder!
    var decibelLevelTimer: Timer?



    @Published var micValue: Float = 0

    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            self.decibelLevelTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.audioRecorder.updateMeters()
                self.micValue = self.audioRecorder.averagePower(forChannel: 0)
            }
        } catch {
            print("Could not start recording")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        audioRecorder.deleteRecording()
        decibelLevelTimer?.invalidate()
        decibelLevelTimer = nil
    }
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
