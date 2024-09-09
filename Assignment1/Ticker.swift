import Foundation

class Ticker {
    private var timer: Timer?
    private(set) var state: GameState = .initial
    var stateChangeHandler: ((GameState) -> Void)?

    enum GameState {
        case initial
        case flip
        case evaluate
        case scoreUpdate
        case checkEnd
        case gameEnd

        var nextState: GameState {
            switch self {
            case .initial:
                return .flip
            case .flip:
                return .evaluate
            case .evaluate:
                return .scoreUpdate
            case .scoreUpdate:
                return .checkEnd
            case .checkEnd:
                return .flip
            case .gameEnd:
                return .initial
            }
        }
    }

    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in self?.updateState()
        })
        print("Ticker started")
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        print("Ticker stopped")
    }

    func triggerGameEnd() {
        stop()
        updateStateTo(.gameEnd)
    }

    private func updateState() {
        state = state.nextState
        print("State updated to: \(state)")
        stateChangeHandler?(state)
    }

    func updateStateTo(_ newState: GameState) {
        state = newState
        print("State updated to: \(state)")
        stateChangeHandler?(state)
    }
}
