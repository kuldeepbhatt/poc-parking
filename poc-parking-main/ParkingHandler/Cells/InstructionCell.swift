import UIKit

class InstructionCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Charges Table"
    }
}
