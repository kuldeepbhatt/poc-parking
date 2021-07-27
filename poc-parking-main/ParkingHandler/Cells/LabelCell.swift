import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .none
    }

    func setUpCell(with type: LabelType, subTitle: String? = "--") {
        switch type {
            case .charges:
                titleLabel.text = "Charges"
                subtitleLabel.text = subTitle
            case .change:
                titleLabel.text = "Collect change"
                subtitleLabel.text = subTitle
            case .chargeInstruction(let instructionType):
                setChargeInstruction(with: instructionType)
        }
    }

    func setChargeInstruction(with instructionType: InstructionType) {
        switch instructionType {
            case .twohours:
                self.titleLabel.text = "0 - 2 Hours"
                self.subtitleLabel.text = "10R"
            case .fourhours:
                self.titleLabel.text = "2 - 4 Hours"
                self.subtitleLabel.text = "20R"
            case .sixhours:
                self.titleLabel.text = "4 - 6 Hours"
                self.subtitleLabel.text = "40R"
            case .sixonwards:
                self.titleLabel.text = "6 Onwards"
                self.subtitleLabel.text = "10R per Hour"
        }
    }
}
