public struct Point: Codable, Equatable, Hashable, Sendable {

    public var column: Int

    public var row: Int

    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

    // MARK: Codable

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.row = try container.decode(Int.self)
        self.column = try container.decode(Int.self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(row)
        try container.encode(column)
    }
}

extension Point {

    public static let zero: Point = .init(column: 0, row: 0)
}

// MARK: -

public struct Size: Codable, Equatable, Hashable, Sendable {

    public var columns: Int

    public var rows: Int

    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
    }

    // MARK: Codable

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.rows = try container.decode(Int.self)
        self.columns = try container.decode(Int.self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(rows)
        try container.encode(columns)
    }
}

extension Size {

    public static let zero: Size = .init(columns: 0, rows: 0)
}

// MARK: -

public struct Rect: Codable, Equatable, Hashable, Sendable {

    public var origin: Point

    public var size: Size

    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    // MARK: Codable

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.origin = try container.decode(Point.self)
        self.size = try container.decode(Size.self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(origin)
        try container.encode(size)
    }
}

extension Rect {

    public static let zero: Rect = .init(origin: .zero, size: .zero)
}
