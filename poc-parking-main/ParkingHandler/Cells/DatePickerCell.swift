import UIKit

public protocol TimePickerSelector: AnyObject {
    func didEndSelectingTime(with time: Date?, type: TimePickerType?)
    func shouldEndCalculation(with paidCharges: String)
}

class DatePickerCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeField: UITextField!
    var timeSelector: TimePickerSelector?
    var currentType: TimePickerType?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .none
    }

    func setUpCell(with type: TimePickerType, delegate: TimePickerSelector, shouldEnable: Bool = false) {
        switch type {
        case .inTime:
            titleLabel.text = "In Time"
            setUpTimeField()
        case .outTime:
            titleLabel.text = "Out Time"
           setUpTimeField()
        case .getCharges:
            titleLabel.text = "Pay Charges"
            timeField.isEnabled = shouldEnable
            timeField.keyboardType = .numberPad
            timeField.delegate = self
        }
        self.currentType = type
        self.timeSelector = delegate
    }
    func setUpTimeField() {
        timeField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        timeField.delegate = nil
    }
}
extension DatePickerCell {
    @objc func tapDone() {
        if let datePicker = self.timeField.inputView as? UIDatePicker {
            datePicker.datePickerMode = .time
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm:ss"
            self.timeField.text = dateformatter.string(from: datePicker.date)
            self.timeSelector?.didEndSelectingTime(with: datePicker.date, type: self.currentType)
        }
        self.timeField.resignFirstResponder()
    }
}
extension DatePickerCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.timeSelector?.shouldEndCalculation(with: textField.text ?? "")
    }
}
