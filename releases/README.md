# TODO UPDATE

# Run by Platform
For platform specific guides and information, please refer to the README.md file in each of the platform directories:
- [docker-jupiter](https://github.com/NotArb/Jupiter/tree/main/releases/docker-jupiter)
- [unix-notarb](https://github.com/NotArb/Jupiter/tree/main/releases/unix-notarb)
- [windows-notarb](https://github.com/NotArb/Jupiter/tree/main/releases/windows-notarb)

# Run with Java
All programs provided by NotArb are in Java, therefore you can run them purely from Java.

_This guide will be cleaned up in the future._

**Minimum Java Version:** 22<br>
> _Depending on your Java version, `--enable-preview` VM arg may be required to run._

## Examples

### Jupiter Arbitrage Bot
> java -cp /path/to/bot.jar org.notarb.launcher.Main --jupiter-arb-config-path=/path/to/bot-config.toml

### Jupiter Management Server
> java -cp /path/to/bot.jar org.notarb.launcher.Main --jupiter-config-path=/path/to/jupiter-config.toml