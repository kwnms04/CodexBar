import CryptoKit
import Foundation

/// How a Mac identifies itself to the fleet. See `docs/adr/0001-stable-device-identity.md`.
enum CloudSyncDeviceIdentity {
    /// A persisted identifier always wins, so fleets created before stable identity keep addressing
    /// their existing device records. Only a fresh install derives an identifier from the machine,
    /// which is what stops a reinstall from stranding the previous device record.
    static func resolve(persisted: String?, hardwareUUID: String?) -> String {
        if let persisted, !persisted.isEmpty {
            return persisted
        }
        guard let hardwareUUID, !hardwareUUID.isEmpty else {
            return UUID().uuidString.lowercased()
        }
        return self.derive(from: hardwareUUID)
    }

    /// The machine's hardware UUID, which survives reinstalling CodexBar and macOS.
    static func hardwareUUID() -> String? {
        var size = 0
        guard sysctlbyname("kern.uuid", nil, &size, nil, 0) == 0, size > 0 else { return nil }
        var buffer = [CChar](repeating: 0, count: size)
        guard sysctlbyname("kern.uuid", &buffer, &size, nil, 0) == 0 else { return nil }
        let bytes = buffer.prefix { $0 != 0 }.map(UInt8.init(bitPattern:))
        return String(bytes: bytes, encoding: .utf8)
    }

    /// Hashed so the raw hardware identifier never reaches CloudKit, and shaped as a UUID because
    /// every identifier issued before this change is one.
    private static func derive(from hardwareUUID: String) -> String {
        SHA256.hash(data: Data(hardwareUUID.utf8))
            .withUnsafeBytes { UUID(uuid: $0.load(as: uuid_t.self)).uuidString.lowercased() }
    }
}
