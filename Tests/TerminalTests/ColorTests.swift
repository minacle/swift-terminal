import Testing

@testable
import Terminal

@Test
func testColor16() {
    let foregrounds = [
        .black: "30",
        .red: "31",
        .green: "32",
        .yellow: "33",
        .blue: "34",
        .magenta: "35",
        .cyan: "36",
        .white: "37",
        .brightBlack: "90",
        .brightRed: "91",
        .brightGreen: "92",
        .brightYellow: "93",
        .brightBlue: "94",
        .brightMagenta: "95",
        .brightCyan: "96",
        .brightWhite: "97",
    ] as [Color16: String]

    let backgrounds = [
        .black: "40",
        .red: "41",
        .green: "42",
        .yellow: "43",
        .blue: "44",
        .magenta: "45",
        .cyan: "46",
        .white: "47",
        .brightBlack: "100",
        .brightRed: "101",
        .brightGreen: "102",
        .brightYellow: "103",
        .brightBlue: "104",
        .brightMagenta: "105",
        .brightCyan: "106",
        .brightWhite: "107",
    ] as [Color16: String]

    for (color, expected) in foregrounds {
        let actual = color.foreground
        #expect(actual == expected)
    }

    for (color, expected) in backgrounds {
        let actual = color.background
        #expect(actual == expected)
    }

    #expect(Terminal.SGR.foregroundColor(Color16.red) == "\u{1B}[31m")
    #expect(Terminal.SGR.backgroundColor(Color16.red) == "\u{1B}[41m")
}

@Test
func testColor256() {
    #expect(Color256(42).foreground == "38;5;42")
    #expect(Color256(42).background == "48;5;42")

    #expect(Color256(.red).foreground == "38;5;1")

    #expect(Color256(rawValue: 42).foreground == "38;5;42")

    #expect(Terminal.SGR.foregroundColor(Color256(42)) == "\u{1B}[38;5;42m")
    #expect(Terminal.SGR.backgroundColor(Color256(42)) == "\u{1B}[48;5;42m")
}

@Test
func testTrueColor() {
    let color = TrueColor(red: 12, green: 34, blue: 56)

    #expect(Terminal.SGR.foregroundColor(color) == "\u{1B}[38;2;12;34;56m")
    #expect(Terminal.SGR.backgroundColor(color) == "\u{1B}[48;2;12;34;56m")
}

@Test
func testAnyColor() {
    let color16 = AnyColor(Color16.red)
    let color256 = AnyColor(Color256(42))
    let trueColor = AnyColor(TrueColor(red: 12, green: 34, blue: 56))

    #expect(color16.foreground == "31")
    #expect(color16.background == "41")
    #expect(color16 == AnyColor(Color16.red))
    #expect(color16.hashValue == AnyColor(Color16.red).hashValue)

    #expect(color256.foreground == "38;5;42")
    #expect(color256.background == "48;5;42")
    #expect(color256 == AnyColor(Color256(42)))
    #expect(color256.hashValue == AnyColor(Color256(42)).hashValue)

    #expect(trueColor.foreground == "38;2;12;34;56")
    #expect(trueColor.background == "48;2;12;34;56")
    #expect(trueColor == AnyColor(TrueColor(red: 12, green: 34, blue: 56)))
    #expect(trueColor.hashValue == AnyColor(TrueColor(red: 12, green: 34, blue: 56)).hashValue)
}

@Test
func testResetColors() {
    #expect(Terminal.SGR.resetForegroundColor == "\u{1B}[39m")
    #expect(Terminal.SGR.resetBackgroundColor == "\u{1B}[49m")
}
