//: A UIKit based Playground for presenting user interface
  
import Foundation

protocol Timeable {
    let timer: Timer

    func checkTime()
}

struct MockTimer: Timeable { // 테스트 객체
    let timer: Timer

    func checkTime() { }
}

struct Timers: Timeable { // 실제 사용될 객체
    let timer: Timer

    func checkTime() { }
}

class ViewController {
    Timeable <- 보장된 객체만 들어오면 좋겠어

    let timers: Timeable
    timers = Timers
}

