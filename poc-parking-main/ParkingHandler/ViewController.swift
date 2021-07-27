import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    var rows:[ParkingManagerRow] = []
    var chargesDetails: String? = "--"
    let viewModel = ParkingManagerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.rows = viewModel.visibleRows
    }
}

// MARK: SetUp
extension ViewController {
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tap)
        self.title = self.viewModel.screenTitle
    }
}

// MARK: Table View Datasource and Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.rows[indexPath.row]
        switch row {
            case .timepicker(let type):
                let isEmpty = chargesDetails?.isEmpty ?? false
                let cell: DatePickerCell = tableView.dequeuedCell(ofType: DatePickerCell.self, indexPath: indexPath)
                cell.setUpCell(with: type, delegate: self, shouldEnable: !isEmpty)
                return cell
            case .label(let type):
                let cell: LabelCell = tableView.dequeuedCell(ofType: LabelCell.self, indexPath: indexPath)
                cell.setUpCell(with: type, subTitle: chargesDetails)
                return cell
            case .instruction:
            let cell: InstructionCell = tableView.dequeuedCell(ofType: InstructionCell.self, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: Business
extension ViewController: TimePickerSelector {
    func didEndSelectingTime(with time: Date?, type: TimePickerType?) {
        guard let time = time else { return }
        print(time)
        let timeModel = TimeModel(time: time)
        switch type {
            case .inTime: self.viewModel.inTime = timeModel.time
            default: self.viewModel.outTime = timeModel.time
        }
        let charges = self.viewModel.charges
        if charges > 0 {
            chargesDetails = String(format: "%dR", charges)
            reloadRows(rows: [2,3])
        }
    }
    func shouldEndCalculation(with paidCharges: String) {
        guard let paidChargesInInt = Int(paidCharges) else { return }
        let totalChargesInInt = self.viewModel.charges
        let remainingAmount =  paidChargesInInt - totalChargesInInt
        remainingAmount > 0 ? (chargesDetails = String(format: "%dR", remainingAmount)) : (showAmountError())
        reloadRows(rows: [4])
    }
    func reloadRows(rows: [Int]) {
        var reloadableRows:[IndexPath] = []
        for row in rows{
            reloadableRows.append(IndexPath(row: row, section: 0))
        }
        tableView?.reloadRows(at: reloadableRows, with: UITableView.RowAnimation.fade)
    }
}

extension ViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func showAmountError() {
        let alert = UIAlertController(title: "Warning", message: "Please pay full amount", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        chargesDetails = "--"
        reloadRows(rows: [4])
    }
}
