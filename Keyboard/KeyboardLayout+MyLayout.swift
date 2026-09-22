import KeyboardKit

extension KeyboardLayout {

    /// The stock layout, with a digits row on top, "," and "." flanking the
    /// spacebar, and a narrower return key.
    static func myLayout(for context: KeyboardContext) -> KeyboardLayout {
        var layout = KeyboardLayout.standard(for: context)
        guard context.keyboardType.isAlphabetic else { return layout }

        // A real layout row rather than the built-in input toolbar, which
        // renders nothing on iPhone in the open-source engine.
        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        layout.itemRows.insert(digits.map { layout.createIdealItem(for: .character($0)) }, at: 0)

        var comma = layout.createIdealItem(for: .character(","))
        comma.size.width = .input
        layout.itemRows.insert(comma, before: .space)

        var period = layout.createIdealItem(for: .character("."))
        period.size.width = .input
        layout.itemRows.insert(period, after: .space)

        layout.setReturnKeyWidth(.percentage(0.135))

        return layout
    }
}

private extension KeyboardLayout {

    /// The return key's action carries the field's return type, which varies
    /// per text field, so match the case rather than a concrete action value.
    mutating func setReturnKeyWidth(_ width: KeyboardLayoutItem.Width) {
        for (rowIndex, row) in itemRows.enumerated() {
            for (itemIndex, item) in row.enumerated() {
                guard case .primary = item.action else { continue }
                itemRows[rowIndex][itemIndex].size.width = width
            }
        }
    }
}
