import Foundation
import AsyncDNSResolver
import OSLog

/// Resolve hostname -> IPv4 and IPv6 addresses.
/// Uses swift-async-dns-resolver by default with a system-based fallback.
/// Caches results with a simple TTL.
actor DNSResolver {
    private static let DefaultTTLSeconds: Int32 = 60 * 10
    struct CacheEntry {
        let hostname: String
        let ips: [String]
        let ttl: Int32
        let timestamp: Int = Int(Date.now.timeIntervalSince1970.rounded())
    }
    private var cache = [String: CacheEntry]()
    private let resolver: AsyncDNSResolver?

    init() {
        do {
            var options = CAresDNSResolver.Options.default
            options.timeoutMillis = 200
            options.servers = ["1.1.1.1", "8.8.8.8", "8.8.4.4"]
            options.rotate = true
            resolver = try AsyncDNSResolver(options: options)
            Logger.app.info("IPResolver using async dns resolver.")
        } catch {
            resolver = nil
            Logger.app.error("Failed initializing async dns resolver, using fallback \(error.localizedDescription)")
        }
    }

    func getIPs(for hostname:String) async -> [String] {
        let timestamp = Int(Date.now.timeIntervalSince1970.rounded())
        if let existing = cache[hostname] {
            if timestamp - existing.timestamp < existing.ttl {
                return existing.ips
            }
            cache.removeValue(forKey: hostname)
        }

        let ipEntry: CacheEntry?
        if resolver != nil {
            ipEntry = await resolveWithAsyncDNS(for: hostname)
        } else {
            ipEntry = resolveWithOS(for: hostname)
        }

        guard let ipEntry = ipEntry else {
            Logger.app.error("Failed to resolve hostname \(hostname)")
            return []
        }

        cache[hostname] = ipEntry
        return ipEntry.ips
    }

    private func resolveWithAsyncDNS(for hostname: String) async -> CacheEntry? {
        guard let resolver = resolver else {
            return nil
        }
        let aRecords = try? await resolver.queryA(name: hostname)
        let aaaaRecords = try? await resolver.queryAAAA(name: hostname)
        var ips:[String] = []
        var ttl: Int32 = 0
        if let aRecords = aRecords {
            aRecords.forEach { aRecord in
                // Use largest TTL for the whole collection, doesn't matter much for us
                if let recordTTL = aRecord.ttl, recordTTL > ttl {
                    ttl = recordTTL
                }
                ips.append(aRecord.address.description)
            }
        }
        if let aaaaRecords = aaaaRecords {
            aaaaRecords.forEach { aaaaRecord in
                // Use largest TTL for the whole collection, doesn't matter much for us
                if let recordTTL = aaaaRecord.ttl, recordTTL > ttl {
                    ttl = recordTTL
                }
                ips.append(aaaaRecord.address.description)
            }
        }
        if ips.isEmpty {
            return nil
        }
        return CacheEntry(hostname: hostname, ips: ips, ttl: ttl)
    }

    private func resolveWithOS(for hostname:String) -> CacheEntry? {
        let ips = resolveIPsWithOS(for: hostname)
        if ips.isEmpty {
            return nil
        }
        return CacheEntry(hostname: hostname, ips: ips, ttl: DNSResolver.DefaultTTLSeconds)
    }
}

/// Resolve IPv4 and IPv6 addresses given a hostname using the operating system defaults.  For domains with both IPv4 (A record) and IPv6 (AAAA record), it may return either one
/// and we have no way to control here. If you need precise DNS records, I had success with https://github.com/apple/swift-async-dns-resolver .
///
/// Inspired by https://stackoverflow.com/questions/25890533/how-can-i-get-a-real-ip-address-from-dns-query-in-swift
func resolveIPsWithOS(for hostname: String) -> [String] {
    var ipAddresses: [String] = []
    let host = CFHostCreateWithName(nil, hostname as CFString).takeRetainedValue()
    CFHostStartInfoResolution(host, .addresses, nil)
    var success: DarwinBoolean = false
    if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray? {
        for case let theAddress as NSData in addresses {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                ipAddresses.append(String(cString: hostname))
            }
        }
    }
    return ipAddresses
}
