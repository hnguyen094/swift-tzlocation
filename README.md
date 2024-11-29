# swift-tzlocation
This is a Swift implementation of [TZLocation](https://github.com/atomicbird/TZLocation). See their
page for more details.

**Note**: This project is not maintained.

## Changes
- not tested (nearly at all)
- there is no demo
- no `backward` feature, and depending on the OS's `zone.tab`
- no caching, so all calls to `TimeZone.location()` will read the `zone.tab` file again
- no exposed `countryCode`
