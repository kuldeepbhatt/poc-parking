import UIKit
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_GB")
        // iOS 14 and above
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker

        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar
    }

    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
extension Date {
    static func - (lhs: Date, rhs: Date) -> String? {
        return hours(interval: (lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate))
    }
    static func hours(interval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.unitsStyle = .short

        let hours = formatter.string(from: TimeInterval(interval))!
        let hoursComponent = hours.components(separatedBy: " ").first
        guard let hoursInInt = hoursComponent else { return nil }
        return hoursInInt
    }
}

