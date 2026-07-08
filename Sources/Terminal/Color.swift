/// A type-erased SGR color.
///
/// Use `AnyColor` when an API needs to store or compare colors without
/// preserving the concrete color type. Equality and hashing preserve the
/// concrete type, so two colors are equal only when they wrap the same color
/// type and value.
@frozen
public struct AnyColor: Terminal.SGR.Color {

    private let box: any _AnyColorBox

    /// Creates a type-erased color from a concrete SGR color.
    ///
    /// - Parameter color: The concrete color value to wrap.
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

/// The standard 16 ANSI terminal colors.
///
/// These colors map to the conventional 8 base colors and 8 bright colors used
/// by SGR foreground and background parameters. The actual RGB values are
/// terminal-theme dependent.
@frozen
public enum Color16: CaseIterable, Terminal.SGR.Color {

    /// The standard black color.
    case black

    /// The standard red color.
    case red

    /// The standard green color.
    case green

    /// The standard yellow color.
    case yellow

    /// The standard blue color.
    case blue

    /// The standard magenta color.
    case magenta

    /// The standard cyan color.
    case cyan

    /// The standard white color.
    case white

    /// The bright black color, commonly rendered as gray.
    case brightBlack

    /// The bright red color.
    case brightRed

    /// The bright green color.
    case brightGreen

    /// The bright yellow color.
    case brightYellow

    /// The bright blue color.
    case brightBlue

    /// The bright magenta color.
    case brightMagenta

    /// The bright cyan color.
    case brightCyan

    /// The bright white color.
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

/// An indexed color from the 256-color terminal palette.
///
/// Values `0...15` correspond to the standard 16 ANSI colors. Values `16...231`
/// conventionally address the 6x6x6 color cube, and values `232...255`
/// conventionally address the grayscale ramp.
@frozen
public struct Color256: RawRepresentable, Terminal.SGR.Color {

    /// Creates an indexed color from its 8-bit palette index.
    ///
    /// - Parameter rawValue: The terminal palette index.
    public init(_ rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// Creates an indexed color matching a standard 16-color value.
    ///
    /// - Parameter color16: The standard ANSI color to represent in the
    ///   256-color palette.
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

/// A 24-bit RGB terminal color.
///
/// True-color SGR parameters encode the red, green, and blue components
/// directly. Terminals that do not support 24-bit color may approximate or
/// ignore these values.
@frozen
public struct TrueColor: Terminal.SGR.Color {

    /// The red component.
    public var red: UInt8

    /// The green component.
    public var green: UInt8

    /// The blue component.
    public var blue: UInt8

    /// Creates a 24-bit RGB terminal color.
    ///
    /// - Parameters:
    ///   - red: The red component.
    ///   - green: The green component.
    ///   - blue: The blue component.
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

@usableFromInline
internal protocol _AnyColorBox: Sendable {

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

@usableFromInline
internal struct _ConcreteColorBox<C>: _AnyColorBox
where C: Terminal.SGR.Color {

    private let color: C

    internal init(color: C) {
        self.color = color
    }

    // MARK: _AnyColorBox

    @usableFromInline
    internal var base: Any {
        return color
    }

    // MARK: Equatable

    @usableFromInline
    internal func isEqual(to other: any _AnyColorBox) -> Bool {
        guard let other = other as? _ConcreteColorBox<C>
        else {
            return false
        }
        return self.color == other.color
    }

    // MARK: Hashable

    @usableFromInline
    internal func hash(into hasher: inout Hasher) {
        color.hash(into: &hasher)
    }

    // MARK: Terminal.SGR.Color

    @usableFromInline
    internal var background: String {
        return color.background
    }

    @usableFromInline
    internal var foreground: String {
        return color.foreground
    }
}
