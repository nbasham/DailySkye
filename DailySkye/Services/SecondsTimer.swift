import Foundation

protocol SecondsTimerListener {
    func update(elapsedSeconds: Int)
}

class SecondsTimer {
    var secondUpdateHandler: ((Int) -> Void)?
    var timer: Timer?
    var timerPaused = true
    var seconds = 0

    deinit {
        print("SecondsTimer deinit")
    }

    func start(secondUpdateHandler: @escaping (Int) -> Void) {
        self.secondUpdateHandler = secondUpdateHandler
        reset()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
        timerPaused = false
    }

    func pause() { timerPaused = true }
    func resume() { timerPaused = false }
    func reset() { seconds = 0 }

    @objc func updateSeconds() {
        guard !timerPaused else { return }
        seconds += 1
        secondUpdateHandler?(seconds)
    }

}
