import Foundation
import Combine

class GameViewModel: ObservableObject {
    // MARK: State

    @Published var circleMoveHorizontal: CGFloat = 0
    @Published var circleMoveVertical: CGFloat = 0
    @Published var isStarted = false

    // MARK: Properties

    private let recordService = MicrophoneService()
    private let motionService = MotionService()
    private var subscribers = Set<AnyCancellable>()

    // MARK: Initialization

    init() {
        setupBindings()
    }

    // MARK: Internal Methods

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

    // MARK: Private methods

    private func setupBindings() {
        recordService.$micValue
            .sink { [weak self] decibel in
                guard let self = self else { return }
                self.makeOffsetValue(decibel)
                print("db \(decibel)")
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
