import KeyboardKit

extension KeyboardLayout {

    /// The letters page gets an optional digits row on top, and every page
    /// gets "," / "." flanking the spacebar. The numeric and symbolic pages follow the Android layout:
    /// two rows of ten symbols, then a page toggle, seven symbols and backspace.
    static func myLayout(for context: KeyboardContext) -> KeyboardLayout {
        var layout = KeyboardLayout.standard(for: context)
        switch context.keyboardType {
        case .alphabetic:
            if SharedSettings.showsNumbersRow {
                layout.itemRows.insert(layout.characterRow(SymbolPage.digits), at: 0)
            }
        case .numeric:
            layout.replaceUpperRows(with: .first, pageToggle: .keyboardType(.symbolic))
        case .symbolic:
            layout.replaceUpperRows(with: .second, pageToggle: .keyboardType(.numeric))
        default:
            return layout
        }
        layout.alignBottomRowWithShift()
        layout.addPunctuationAroundSpace()
        layout.setReturnKeyWidth(.percentage(0.135))
        return layout
    }
}

extension KeyboardLayout {

    /// The height the keyboard needs for these rows, plus a fixed gap on top.
    func keyboardHeight(topGap: CGFloat) -> CGFloat {
        let rows = itemRows.reduce(0) { $0 + ($1.map(\.size.height).max() ?? 0) }
        return rows + configuration.edgeInsets.top + configuration.edgeInsets.bottom + topGap
    }
}

struct SymbolPage {

    static let digits = "1234567890"

    static let first = SymbolPage(
        upper: "+×÷=/_<>[]",
        middle: "!@#$%^&*()",
        lower: "-'\":;,?"
    )

    static let second = SymbolPage(
        upper: "`~\\|{}€£¥₩",
        middle: "°•○●□■♤♡◇♧",
        lower: "☆▪¤《》¡¿"
    )

    let upper: String
    let middle: String
    let lower: String
}

private extension KeyboardLayout {

    /// Uses `.input` so ten-key rows define the input key width; KeyboardKit
    /// derives it from the row with the most `.input` items.
    func characterRow(_ characters: String) -> KeyboardLayoutItemRow {
        characters.map { createIdealItem(for: .character(String($0)), width: .input) }
    }

    /// Keeps the standard bottom row, and reuses the standard backspace and
    /// page toggle items so they keep their actions, styling and heights.
    mutating func replaceUpperRows(with page: SymbolPage, pageToggle: KeyboardAction) {
        guard let bottomRow = itemRows.last else { return }
        let items = itemRows.flatMap { $0 }
        var toggle = items.first { $0.action == pageToggle } ?? createIdealItem(for: pageToggle)
        var backspace = items.first { $0.action == .backspace } ?? createIdealItem(for: .backspace)
        toggle.size.width = .available
        backspace.size.width = .available

        itemRows = [
            characterRow(SymbolPage.digits),
            characterRow(page.upper),
            characterRow(page.middle),
            [toggle] + characterRow(page.lower) + [backspace],
            bottomRow,
        ]
    }

    /// Web address fields already have a `.urlDomain` key, which types "." and
    /// offers .com, .org and more on long-press, so ours would be a duplicate.
    /// Widens the 123 / ABC key to Shift's width plus the margin before Z
    /// (13% + 2%), so the "," next to it sits directly under Z. The emoji key
    /// is dropped: the emoji keyboard is a KeyboardKit Pro feature, so it never shows.
    mutating func alignBottomRowWithShift() {
        guard !itemRows.isEmpty else { return }
        let last = itemRows.count - 1
        itemRows[last].removeAll { $0.action == .keyboardType(.emojis) }
        for index in itemRows[last].indices {
            guard case .keyboardType(let type) = itemRows[last][index].action,
                  type == .numeric || type == .alphabetic else { continue }
            itemRows[last][index].size.width = .percentage(0.15)
        }
    }

    /// Adds the keys chosen in the app on either side of the spacebar. Web
    /// address fields already have a `.urlDomain` key right of the spacebar,
    /// which types "." and offers .com, .org and more on long-press, so no key
    /// is added there.
    mutating func addPunctuationAroundSpace() {
        let bottomRow = itemRows.last ?? []
        func has(_ action: KeyboardAction) -> Bool { bottomRow.contains { $0.action == action } }
        if let left = SharedSettings.leftSpaceKey, !has(.character(left)) {
            itemRows.insert(createIdealItem(for: .character(left), width: .input), before: .space)
        }
        if let right = SharedSettings.rightSpaceKey, !has(.character(right)), !has(.urlDomain) {
            itemRows.insert(createIdealItem(for: .character(right), width: .input), after: .space)
        }
    }

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
