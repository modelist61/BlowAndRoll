
import SwiftUI
import CoreMotion

class MotionService: ObservableObject {

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    var pitchResetVal = 0.0
    var rollResetVal = 0.0

    private var manager = CMMotionManager()

    func start() {

        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
//                self.pitch = motionData.attitude.pitch - self.pitchResetVal
//                self.roll = motionData.attitude.roll - self.rollResetVal
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                print("motionData PITCH = \(motionData.attitude.pitch), ROLL = \(motionData.attitude.roll)")
                print("\n PITCH State \(self.pitch), resetVal = \(self.pitchResetVal) \n ROLL State \(self.roll), resetVal \(self.rollResetVal)")
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }

//    func reset() {
//        let curPitch = 0 + pitch
//        let curRoll = 0 + roll
//        pitchResetVal = 0 + curPitch
//        rollResetVal = 0 + curRoll
//    }
}
