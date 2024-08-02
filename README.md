# NotArb (UNDER DEVELOPMENT)

**NotArb** is a versatile platform designed to optimize token trading and arbitrage operations on the Solana blockchain. It offers two main components:

- A Docker-based Jupiter management server with features designed to enhance token trading efficiency.
- A bot that performs arbitrage operations using Jupiter on the Solana blockchain.

#### Warnings
  - Never use NotArb files that you did not directly download from our official GitHub page.
  - Never put private keys on shared or unsecured hosts.

## Features

### Jupiter Management Server

Currently, this service is only available via Docker, with potential support for other platforms in the future.
- **Auto-Restart Feature**: Ensures the server automatically restarts if it stops due to failure.
- **Timed Restart Feature**: Optionally, the server can be configured to restart at regular intervals, providing additional stability.
- **Dynamic/Static Mint Filters**:
  - **Dynamic Filter**: Fetches tradable tokens from Jupiter's official [Token List API](https://station.jup.ag/docs/token-list/token-list-api) and adds them to the program's filtered mint list.
  - **Static Filter**: A list of predefined mints that will be added to the program's filtered mint list. 
  - _All filters are configurable and can be enabled/disabled in the config file._
  - _Filters are applied on every start/restart._

- **Dependency Management**: Automatically downloads and installs required dependencies, such as the `jupiter-swap-api`, ensuring users have everything they need to get started quickly.
- **Configurable via `jupiter-config.toml`**: Allows users to pass any ENV variables to the `jupiter-swap-api` and set up configurations such as the auto-restart timer and filters.

  [jupiter-config.toml](https://github.com/NotArb/Jupiter/blob/main/releases-wip/docker-jupiter/jupiter-config.toml)


### Jupiter Arb Bot (ALPHA)

NotArb offers a powerful Jupiter Arbitrage Bot designed for executing arbitrage transactions quickly and efficiently on the Solana blockchain. The bot utilizes [Jupiter Swap API](https://station.jup.ag/docs/apis/swap-api) to identify and execute arbitrage transactions as quickly as possible.

_The bot is publicly available but is currently in its alpha stage and will undergo several changes.<br>Feel free to follow the bot's [Solana Program Account](https://program.notarb.org) to monitor its activity!_

#### Requirements
- **RPC Server**
- **Jupiter Server**
- **Bot Server**

#### Hosting
- The bot can be run on the same host as the Jupiter server or on a separate host.
- Unlike the RPC and Jupiter servers, the bot itself does not require a heavy-duty host. _Specifications and recommendations to come._
- While you can technically run the bot using free RPC endpoints, this will likely result in a very poor transaction success rate. Higher quality servers will improve your returns.


## Offical Links
- [Discord Community](https://discord.notarb.org)
- [Example Arbitrage Configurations](https://examples.notarb.org)
- [Download NotArb](https://download.notarb.org)
