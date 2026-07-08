extension Terminal.SGR {

    public enum Style: Equatable, Sendable {

        case bold

        case dim

        case italic

        case underline

        case blink

        case inverse

        case hidden

        case strikethrough

        public var on: String {
            switch self {
            case .bold:
                return "1"
            case .dim:
                return "2"
            case .italic:
                return "3"
            case .underline:
                return "4"
            case .blink:
                return "5"
            case .inverse:
                return "7"
            case .hidden:
                return "8"
            case .strikethrough:
                return "9"
            }
        }

        public var off: String {
            switch self {
            case .bold:
                return "22"
            case .dim:
                return "22"
            case .italic:
                return "23"
            case .underline:
                return "24"
            case .blink:
                return "25"
            case .inverse:
                return "27"
            case .hidden:
                return "28"
            case .strikethrough:
                return "29"
            }
        }
    }
}

extension Terminal.SGR {

    public static func style(_ style: Style) -> String {
        return "\u{1B}[\(style.on)m"
    }

    public static func resetStyle(_ style: Style) -> String {
        return "\u{1B}[\(style.off)m"
    }
}
