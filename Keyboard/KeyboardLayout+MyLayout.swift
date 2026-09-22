import KeyboardKit

extension KeyboardLayout {

    /// Every page gets a digits row on top and "," / "." flanking the
    /// spacebar. The numeric and symbolic pages follow the Android layout:
    /// two rows of ten symbols, then a page toggle, seven symbols and backspace.
    static func myLayout(for context: KeyboardContext) -> KeyboardLayout {
        var layout = KeyboardLayout.standard(for: context)
        switch context.keyboardType {
        case .alphabetic:
            layout.itemRows.insert(layout.characterRow(SymbolPage.digits), at: 0)
        case .numeric:
            layout.replaceUpperRows(with: .first, pageToggle: .keyboardType(.symbolic))
        case .symbolic:
            layout.replaceUpperRows(with: .second, pageToggle: .keyboardType(.numeric))
        default:
            return layout
        }
        layout.addPunctuationAroundSpace()
        layout.setReturnKeyWidth(.percentage(0.135))
        return layout
    }
}

struct SymbolPage {

    static let digits = "1234567890"

    static let first = SymbolPage(
        upper: "+×÷=/_<>[]",
        middle: "!@#$%^&*()",
        lower: "-'\":;?"
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

    mutating func addPunctuationAroundSpace() {
        itemRows.insert(createIdealItem(for: .character(","), width: .input), before: .space)
        itemRows.insert(createIdealItem(for: .character("."), width: .input), after: .space)
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
