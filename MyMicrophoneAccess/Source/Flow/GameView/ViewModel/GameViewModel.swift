import Foundation
import Combine

class GameViewModel: ObservableObject {
    private let recordService = MicrophoneService()
    private let motionService = MotionService()
    @Published var circleMoveHorizontal: CGFloat = 0
    @Published var circleMoveVertical: CGFloat = 0
    @Published var isStarted = false

    private var subscribers = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    func start() {
        motionService.start()
        recordService.startRecording()
        isStarted = true
    }

    func stop() {
        motionService.stop()
        recordService.stopRecording()
        circleMoveVertical = 0
        isStarted = false
    }

    private func setupBindings() {
        recordService.$micValue
            .sink { [weak self] db in
                guard let self = self else { return }
                self.makeOffsetValue(db)
                print("db \(db)")
            }
            .store(in: &subscribers)

        motionService.$roll
            .sink { [weak self] roll in
                guard let self = self else { return }
                self.circleMoveHorizontal += CGFloat(roll)
                print("roll from sink \(roll)")
            }
            .store(in: &subscribers)

        motionService.$pitch
            .sink { [weak self] pitch in
                guard let self = self else { return }
                let newVal = (0 - pitch)
                if newVal < 0 {
                    self.circleMoveVertical -= CGFloat(newVal)
                }
                print("**pitch from sink \(newVal)")
            }
            .store(in: &subscribers)
    }

    private func makeOffsetValue(_ input: Float) {
        let value = abs(input) * 5
        if value < 40 {
            circleMoveVertical -= 5
        }
        if circleMoveVertical <= -750 {
            stop()
        }
    }
}
