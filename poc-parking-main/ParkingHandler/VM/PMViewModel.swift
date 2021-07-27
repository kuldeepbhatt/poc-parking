import Foundation

public enum TimePickerType {
    case inTime
    case outTime
    case getCharges
}
public enum LabelType {
    case charges
    case change
    case chargeInstruction(type: InstructionType)
}
public enum InstructionType {
    case twohours
    case fourhours
    case sixhours
    case sixonwards
}
public enum ParkingManagerRow {
    case timepicker(type: TimePickerType)
    case label(type: LabelType)
    case instruction
}
public class ParkingManagerViewModel: NSObject {
    var screenTitle: String {
        return "Parking Manager"
    }
    var inTime: Date? {
        didSet {
            guard inTime != nil else { return }
        }
    }
    var outTime: Date? {
        didSet {
            guard outTime != nil else { return }
        }
    }
    var visibleRows: [ParkingManagerRow] {
        var rows = [ParkingManagerRow]()
        rows.append(.timepicker(type: .inTime))
        rows.append(.timepicker(type: .outTime))
        rows.append(.label(type: .charges))
        rows.append(.timepicker(type: .getCharges))
        rows.append(.label(type: .change))
        rows.append(.instruction)
        rows.append(.label(type: .chargeInstruction(type: .twohours)))
        rows.append(.label(type: .chargeInstruction(type: .fourhours)))
        rows.append(.label(type: .chargeInstruction(type: .sixhours)))
        rows.append(.label(type: .chargeInstruction(type: .sixonwards)))
        return rows
    }
}
//Business
extension ParkingManagerViewModel {
    public var charges: Int {
        guard let inTime = self.inTime,
              let outTime = self.outTime else { return 0 }
        guard let result = outTime - inTime else { return 0 }
        guard let hours = Int(result) else { return 0 }
        return calculateAndUpdate(asPer: hours)
    }
    private func calculateAndUpdate(asPer hours: Int) -> Int {
        var charges: Int = 0
        hours > 0 && hours <= 2 ? (charges = 10) : ()
        hours > 2 && hours <= 4 ? (charges = 20) : ()
        hours > 4 && hours <= 6 ? (charges = 40) : ()
        hours > 6 ? (charges = 10 * hours) : ()
        hours < 0 ? (charges = -1) : ()
        return charges
    }
}
public struct TimeModel {
    var time: Date
    init(time: Date) {
        self.time = time
    }
}
