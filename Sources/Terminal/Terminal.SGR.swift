extension Terminal {

    @frozen
    public enum SGR {
    }
}

extension Terminal.SGR {

    public static var resetBackgroundColor: String {
        return "\u{1B}[49m"
    }

    public static var resetForegroundColor: String {
        return "\u{1B}[39m"
    }

    public static func backgroundColor(_ color: any Color) -> String {
        return "\u{1B}[\(color.background)m"
    }

    public static func foregroundColor(_ color: any Color) -> String {
        return "\u{1B}[\(color.foreground)m"
    }

    public static func style(_ style: Style) -> String {
        return "\u{1B}[\(style.on)m"
    }

    public static func resetStyle(_ style: Style) -> String {
        return "\u{1B}[\(style.off)m"
    }
}
