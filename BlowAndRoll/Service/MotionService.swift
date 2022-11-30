
import SwiftUI
import CoreMotion

class MotionService: ObservableObject {
    // MARK: State

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    // MARK: Properties

    private var manager = CMMotionManager()

    // MARK: Internal Methods

    func start() {
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                print("motionData PITCH = \(motionData.attitude.pitch), ROLL = \(motionData.attitude.roll)")
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
