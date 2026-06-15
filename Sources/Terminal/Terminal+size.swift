#if canImport(System)
public import System
#else
public import SystemPackage
#endif

#if os(Linux)
private import Glibc
#elseif canImport(Darwin)
private import Darwin
#endif

extension Terminal {

    @frozen
    public struct Size: Equatable, Sendable {

        public var columns: Int
        public var rows: Int

        public init(columns: Int, rows: Int) {
            self.columns = columns
            self.rows = rows
        }
    }

    public static func size(for fileDescriptor: FileDescriptor) throws(Errno) -> Size {
        var size = winsize()
        let result = unsafe ioctl(fileDescriptor.rawValue, TIOCGWINSZ, &size)
        guard result == 0
        else {
            throw .init(rawValue: result)
        }
        return .init(columns: .init(size.ws_col), rows: .init(size.ws_row))
    }
}
