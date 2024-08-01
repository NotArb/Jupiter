# NotArb

**NotArb** is a versatile platform designed to optimize token trading and arbitrage operations on the Solana blockchain. It offers two main components:

- A Docker-based Jupiter management server with features designed to enhance token trading efficiency.
- A bot that performs arbitrage operations using Jupiter on the Solana blockchain.

#### Warnings
  - Never use NotArb files that you did not directly download from our official GitHub page.
  - Never put private keys on shared or unsecured hosts.

## Features

### Docker Jupiter Management Server

Currently, this service is only available via Docker, with potential support for other platforms in the future.
- **Auto-Restart Feature**: Ensures the server automatically restarts if it stops due to failure.
- **Timed Restart Feature**: Optionally, the server can be configured to restart at regular intervals, providing additional stability.
- **Dynamic/Static Mint Filter**:
  - **Dynamic Filter**: On every start/restart, the server fetches tradable tokens from Jupiter's official Tokens API and adds them to Jupiter's filtered mint list.
  - **Static Filter**: On every start/restart, the server includes mints from predefined lists in your config file to Jupiter's filtered mint list. 
  - _All filters are configurable and can be enabled/disabled in the config file._

- **Dependency Management**: Automatically downloads and installs required dependencies, such as the `jupiter-swap-api`, ensuring users have everything they need to get started quickly.
- **Configurable via `jupiter-config.toml`**: Allows users to pass any ENV variables to the `jupiter-swap-api` and set up configurations such as the auto-restart timer and filters.

  [jupiter-config.toml](https://github.com/NotArb/Jupiter/blob/main/releases-wip/docker-jupiter/jupiter-config.toml)

<br>

### Jupiter Arb Bot

NotArb offers a powerful Jupiter Arbitrage Bot designed for executing arbitrage transactions quickly and efficiently on the Solana blockchain. The bot utilizes Jupiter Swap to identify and execute arbitrage transactions as quickly as possible.

#### Bot Availability
The bot is publicly available but is currently in an alpha stage and will undergo several changes. You can follow the bot's program account to see its activity at:<br>
https://solscan.io/account/BqirtYFXWbEaQr2VxcDKZ7nehZqNtqrLJbpoUaBpPZ6z

Feel free to join our Discord community:
[Discord - NotArb](https://discord.notarb.org)

#### Requirements
- **RPC Server**
- **Jupiter Server**
- **Bot Server**

The bot itself does not require a heavy-duty host, unlike the RPC and Jupiter servers. Specifications and recommendations will be provided soon.

Note: While you can technically run the bot using free RPC endpoints, this will likely result in a very poor transaction success rate. Higher quality servers will improve your returns.

## Links
- [Discord Community](https://discord.notarb.org)
- [Example Arbitrage Configurations](https://examples.notarb.org)
- [Download NotArb](https://download.notarb.org)
