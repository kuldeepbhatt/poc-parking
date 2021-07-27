import UIKit
class PMTableManager: NSObject {
    let viewModel = ParkingManagerViewModel()
    var rows:[ParkingManagerRow] = []
    var parkingTable: UITableView?
    var chargesDetails: String?
    convenience init(with table: UITableView) {
        self.init()
        parkingTable = table
    }
    override init() {
        super.init()
        self.rows = viewModel.visibleRows
    }
}

