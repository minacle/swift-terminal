public struct AnyColor: Terminal.SGR.Color {

    private let box: any _AnyColorBox

    public init<C>(_ color: C)
    where C: Terminal.SGR.Color {
        self.box = _ConcreteColorBox(color: color)
    }

    // MARK: Equatable

    public static func == (lhs: AnyColor, rhs: AnyColor) -> Bool {
        return lhs.box.isEqual(to: rhs.box)
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        box.hash(into: &hasher)
    }

    // MARK: Terminal.SGR.Color

    public var background: String {
        return box.background
    }

    public var foreground: String {
        return box.foreground
    }
}

public enum Color16: CaseIterable, Terminal.SGR.Color {

    case black

    case red

    case green

    case yellow

    case blue

    case magenta

    case cyan

    case white

    case brightBlack

    case brightRed

    case brightGreen

    case brightYellow

    case brightBlue

    case brightMagenta

    case brightCyan

    case brightWhite

    // MARK: Terminal.SGR.Color

    public var background: String {
        switch self {
        case .black:
            return "40"
        case .red:
            return "41"
        case .green:
            return "42"
        case .yellow:
            return "43"
        case .blue:
            return "44"
        case .magenta:
            return "45"
        case .cyan:
            return "46"
        case .white:
            return "47"
        case .brightBlack:
            return "100"
        case .brightRed:
            return "101"
        case .brightGreen:
            return "102"
        case .brightYellow:
            return "103"
        case .brightBlue:
            return "104"
        case .brightMagenta:
            return "105"
        case .brightCyan:
            return "106"
        case .brightWhite:
            return "107"
        }
    }

    public var foreground: String {
        switch self {
        case .black:
            return "30"
        case .red:
            return "31"
        case .green:
            return "32"
        case .yellow:
            return "33"
        case .blue:
            return "34"
        case .magenta:
            return "35"
        case .cyan:
            return "36"
        case .white:
            return "37"
        case .brightBlack:
            return "90"
        case .brightRed:
            return "91"
        case .brightGreen:
            return "92"
        case .brightYellow:
            return "93"
        case .brightBlue:
            return "94"
        case .brightMagenta:
            return "95"
        case .brightCyan:
            return "96"
        case .brightWhite:
            return "97"
        }
    }
}

public struct Color256: RawRepresentable, Terminal.SGR.Color {

    public init(_ rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public init(_ color16: Color16) {
        self.rawValue = .init(Color16.allCases.firstIndex(of: color16)!)
    }

    // MARK: RawRepresentable

    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    // MARK: Terminal.SGR.Color

    public var background: String {
        return "48;5;\(rawValue)"
    }

    public var foreground: String {
        return "38;5;\(rawValue)"
    }
}

public struct TrueColor: Terminal.SGR.Color {

    public var red: UInt8

    public var green: UInt8

    public var blue: UInt8

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    // MARK: Terminal.SGR.Color

    public var background: String {
        return "48;2;\(red);\(green);\(blue)"
    }

    public var foreground: String {
        return "38;2;\(red);\(green);\(blue)"
    }
}

// MARK: -

private protocol _AnyColorBox: Sendable {

    var base: Any {
        get
    }

    // MARK: (Equatable)

    func isEqual(to other: any _AnyColorBox) -> Bool

    // MARK: (Hashable)

    func hash(into hasher: inout Hasher)

    // MARK: (Terminal.SGR.Color)

    var background: String {
        get
    }

    var foreground: String {
        get
    }
}

private struct _ConcreteColorBox<C>: _AnyColorBox
where C: Terminal.SGR.Color {

    fileprivate var base: Any {
        return color
    }

    private let color: C

    fileprivate init(color: C) {
        self.color = color
    }

    // MARK: Equatable

    fileprivate func isEqual(to other: any _AnyColorBox) -> Bool {
        guard let other = other as? _ConcreteColorBox<C>
        else {
            return false
        }
        return self.color == other.color
    }

    // MARK: Hashable

    fileprivate func hash(into hasher: inout Hasher) {
        color.hash(into: &hasher)
    }

    // MARK: Terminal.SGR.Color

    fileprivate var background: String {
        return color.background
    }

    fileprivate var foreground: String {
        return color.foreground
    }
}
