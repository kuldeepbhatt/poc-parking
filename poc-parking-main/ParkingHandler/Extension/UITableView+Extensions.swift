import UIKit

public extension UITableView {
    func dequeueCell<CellType : UITableViewCell>(ofType cellType: CellType.Type, reuseIdentifier: String = CellType.defaultReuseIdentifier, indexPath: IndexPath, configure: ((CellType) -> Void)? = nil) -> UITableViewCell {
        let cell = self.cell(ofType: cellType, reuseIdentifier: reuseIdentifier, indexPath: indexPath)
        if let configure = configure {
            configure(cell)
        }
        return cell
    }

    func cell<CellType : UITableViewCell>(ofType cellType: CellType.Type, reuseIdentifier: String = CellType.defaultReuseIdentifier, indexPath: IndexPath) -> CellType {
        if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? CellType {
            return cell
        }
        register(nib(for: cellType), forCellReuseIdentifier: reuseIdentifier)
        guard let registeredCell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CellType else {
            register(CellType.self, forCellReuseIdentifier: reuseIdentifier)
            guard let registeredCell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CellType else {
                return CellType()
            }
            return registeredCell
        }
        return registeredCell
    }

    func dequeuedCell<CellType : UITableViewCell>(ofType cellType: CellType.Type, reuseIdentifier: String = CellType.defaultReuseIdentifier, indexPath: IndexPath) -> CellType {
         if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? CellType { return cell }
         if Bundle(for: cellType).path(forResource: cellType.className, ofType: "nib") != nil {
            let nib = UINib(nibName: cellType.className, bundle: Bundle(for: cellType))
             register(nib, forCellReuseIdentifier: reuseIdentifier)
         } else {
             register(cellType, forCellReuseIdentifier: reuseIdentifier)
         }
         guard let registeredCell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CellType else {
             register(CellType.self, forCellReuseIdentifier: reuseIdentifier)
             guard let registeredCell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CellType else {
                 return CellType()
             }
             return registeredCell
         }
         return registeredCell
     }

    func headerFooterView<ViewType : UITableViewHeaderFooterView>(ofType viewType: ViewType.Type, reuseIdentifier: String) -> ViewType? {
        if let view = dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? ViewType {
            return view
        }
        register(nib(for: viewType), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        return dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? ViewType
    }

    private func nib<NibType : UIView>(for nibType: NibType.Type) -> UINib {
        let bundle = Bundle(for: nibType)
        if bundle.path(forResource: nibType.className, ofType: "nib") == nil {
            return UINib(nibName: String(describing: nibType), bundle: Bundle.main)
        }
        return UINib(nibName: String(describing: nibType), bundle: Bundle(for: nibType))
    }
}
