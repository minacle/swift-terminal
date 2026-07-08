#if canImport(System)
public import System
#else
public import SystemPackage
#endif

#if canImport(Darwin)
private import Darwin
#elseif canImport(Glibc)
private import Glibc
#endif

extension Terminal {

    /// The visible character-cell dimensions of a terminal viewport.
    ///
    /// Terminal sizes are expressed in columns and rows, not pixels. A value
    /// describes the size reported by the terminal device at the time it was
    /// queried.
    @frozen
    public struct Size: Equatable, Sendable {

        /// The number of character cells available horizontally.
        public var columns: Int

        /// The number of character-cell rows available vertically.
        public var rows: Int

        /// Creates a terminal size value.
        ///
        /// - Parameters:
        ///   - columns: The number of character cells available horizontally.
        ///   - rows: The number of character-cell rows available vertically.
        public init(columns: Int, rows: Int) {
            self.columns = columns
            self.rows = rows
        }
    }

    /// Returns the current terminal viewport size for a file descriptor.
    ///
    /// This function queries the operating system with `TIOCGWINSZ` and
    /// returns the terminal's current column and row count. Pass a file
    /// descriptor connected to a terminal device, such as standard input,
    /// standard output, or standard error.
    ///
    /// - Parameter fileDescriptor: The terminal file descriptor to query.
    /// - Returns: The terminal size reported by the operating system.
    /// - Throws: `Errno` when the underlying `ioctl` call fails.
    public static func size(for fileDescriptor: FileDescriptor) throws(Errno) -> Size {
        var size = winsize()
        let result = unsafe ioctl(fileDescriptor.rawValue, .init(TIOCGWINSZ), &size)
        guard result == 0
        else {
            throw .init(rawValue: errno)
        }
        return .init(columns: .init(size.ws_col), rows: .init(size.ws_row))
    }
}
