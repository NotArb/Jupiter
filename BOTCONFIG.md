# NotArb Bot Configuration Guide

## Overview

This guide provides detailed instructions on configuring your NotArb bot using the provided configuration options.

[View Example Configs](https://examples.notarb.org/)

## Configuration Options

```toml
# Miscellaneous configuration (Required)
[bot_misc]
keypair_path="/path/to/keypair.json OR /path/to/keypair.txt" # Path to the keypair file used for signing transactions
disable_http_pools=false # Disable HTTP pools for debugging purposes (will be removed in future)
max_swap_threads=0 # Maximum number of threads for handling swap requests (if left 0, the bot will automatically determine an optimal amount)
max_jito_threads=0 # Maximum number of threads for dispatching Jito requests. (if left 0, the bot will automatically determine an optimal amount)
max_spam_threads=0 # Maximum number of threads for dispatching Spam requests. (if left 0, the bot will automatically determine an optimal amount)

# Jupiter configuration (Required)
[jupiter]
url="http://0.0.0.0:8080/" # URL of your Jupiter server
http_timeout_ms=3000 # HTTP request timeout for Jupiter (in milliseconds)
http_pool_max_size=50 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=0 # Maximum number of requests per second to Jupiter
thread_pool_size=0 # Number of threads for dispatching requests
unmetered=true # Ignore rate limits and send requests as fast as possible

# RPC configuration (Only required if using for spam sending)
# This is just an example, we advise changing this from solana's public rpc.
[[rpc]]
enabled=true # Enable or disable this RPC node configuration (default: true)
id="solana-pub" # Unique custom identifier for this RPC configuration
url="https://api.mainnet-beta.solana.com" # URL and port of your RPC server
http_timeout_ms=1000 # HTTP request timeout for RPC (in milliseconds)
http_pool_max_size=10 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=10 # Maximum number of requests per second to this RPC
queue_timeout_ms=1000 # Timeout for requests in the queue; good if you don't want to allow potential arbs to send after waiting too long

# Jito configuration (At least one required for sending Jito transactions)
# Swaps will execute on the enabled Jito dispatcher with the least amount of requests queued.
[[jito]]
enabled=false # Enable or disable sending (default: true)
url="https://mainnet.block-engine.jito.wtf" # URL of the block engine
http_timeout_ms=3000 # HTTP request timeout (in milliseconds)
http_pool_max_size=5 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=5 # Maximum number of requests per second allowed to be dispatched
queue_timeout_ms=7500 # Timeout for requests in the queue to prevent overload; ensures the queue doesn't grow faster than it is processed
always_queue=false # Set to true to make transaction requets always queue to this dispatcher no matter what. (The default behavior is to choose a dispatcher with the least amount of requests queued)
proxy_host="" # All proxy settings are optional
proxy_port=8002
proxy_user=""
proxy_password=""

# Simulation mode (Optional)
[simulation_mode]
enabled=false # Enable or disable sending (default: false)
rpc="solana-pub"
skip_known_jupiter_errors=true # When true, known Jupiter errors will be skipped from output
skip_successful_responses=false # When true, successful responses will be skipped from output
skip_no_profit_responses=false # When true, no profit responses will be skipped from output
force_blockhash=true # When true, the "replaceRecentBlockhash=true" Solana variable will be set

# Jupiter token fetcher (Optional)
# Note: Enabling this may result in opening multiple token accounts, which can affect your balance due to account creation fees.
# Token accounts are only opened once. Adjust your filters to limit the number of tokens if this is a concern.
[jupiter_token_fetcher]
enabled=true # Enable or disable the Jupiter token fetcher (default: true)
fetch_ms=10000 # Interval for fetching tradable tokens from Jupiter (in milliseconds)
max_per_cycle=5 # Maximum number of tokens to attempt a swap per cycle
required_tags=[ # Fetched tokens must match at least one group to be accepted.
    ["birdeye-trending"], 
    ["pump", "verified"],
    ["pump", "community"],
] # Juptier token tags can be found here: https://station.jup.ag/docs/token-list/token-list-api

# Json mint list configuration (Optional)
[[json_mint_list]]
enabled=false
max_per_cylce=5 # optional
random_order=true # optional
path="/path/to/mints.json"

# Static mint list configuration (Optional, but required if no other token suppliers are enabled)
[[static_mint_list]]
enabled=true # Enable or disable this token list (default: true)
random_order=true # Randomize the order of tokens in this list
max_per_cycle=5 # Maximum number of tokens to attempt a swap per cycle
mints=[ # List of token mints to use
    "So11111111111111111111111111111111111111112",  # SOL
    "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB", # USDT
    "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", # USDC
]

# Swap config (At least one required to find swaps)
[[swap]]
enabled=true # Enable or disable this swap configuration (default: true)
mint="So11111111111111111111111111111111111111112" # Base mint to trade (can also do symbols: SOL, USDC, USDT)

[swap.strategy_defaults] # Default strategy configuration for all of this swap's strategies
wrap_unwrap_sol=false 
jito_enabled=true
# Refer to Strategy Fields below #

[[swap.strategy]]
enabled=true
min_spend=0.001 
max_spend=0.01
cu_limit=250_000 
min_profit_type="bps" # Accepted types: solana, lamports, bps, percent
min_profit_value=20 # Minimum profit required; note that the actual profit may vary by the time the transaction lands. Consider starting with a higher value to be safe.
min_priority_fee_lamports=190 # Alternatively you can use min_priority_fee_sol
max_priority_fee_lamports=190 # Alternatively you can use max_priority_fee_sol
spam_senders=[ # Normal transaction senders list
    { rpc="solana-pub", skip_preflight=true, max_retries=0 },
]
spam_cooldown="5s"
# Refer to Strategy Fields below #
```

## Strategy Fields

#### 1.0. Fields that will directly affect the results of Jupiter entry/exit quotes:
- `wrap_unwrap_sol`: Whether to automatically wrap and unwrap SOL for transactions. (default: true)
- `min_spend`: The minimum amount to spend per swap operation.
- `max_spend`: The maximum amount to spend per swap operation.
- `auto_priority_fee`: Use Jupiter's auto priority fee feature. (This will use an additional rpc call on Jupiter)
- `min_priority_fee_lamports`: The minimum priority fee for transactions in lamports.
  - Alternatively, you can use `min_priority_fee_sol` which will do the lamport conversion for you.
- `max_priority_fee_lamports`: The maximum priority fee for transactions in lamports.
  - Alternatively, you can use `max_priority_fee_sol` which will do the lamport conversion for you.
##### 1.1. Entry specific:
- `entry_only_direct_routes`: Restrict the entry swaps to direct routes only.
- `entry_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during entry swaps.
- `entry_max_auto_slippage_bps`: The maximum automatic slippage for entry swaps (in basis points).
- `entry_min_slippage_bps`: The minimum slippage allowed for entry swaps (in basis points).
- `entry_max_slippage_bps`: The maximum slippage allowed for entry swaps (in basis points).
- `entry_max_accounts`: The maximum number of accounts that can be used for entry swaps.
  - Alternatively, you can use `total_max_accounts` to limit total accounts instead.
- `entry_dexes`: A list of DEXes allowed for entry swaps.
- `entry_exclude_dexes`: A list of DEXes to exclude from entry swaps.
##### 1.2. Exit specific: (The same as above, but specific to exit quotes)
- `exit_only_direct_routes`: Restrict the exit swaps to direct routes only.
- `exit_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during exit swaps.
- `exit_max_auto_slippage_bps`: The maximum automatic slippage for exit swaps (in basis points).
- `exit_min_slippage_bps`: The minimum slippage allowed for exit swaps (in basis points).
- `exit_max_slippage_bps`: The maximum slippage allowed for exit swaps (in basis points).
- `exit_max_accounts`: The maximum number of accounts that can be used for exit swaps.
  - Alternatively, you can use `total_max_accounts` to limit total accounts instead.
- `exit_dexes`: A list of DEXes allowed for exit swaps.
- `exit_exclude_dexes`: A list of DEXes to exclude from exit swaps.
---
#### 2.0. Fields that will determine if a transaction will be skipped, after quotes are acquired:
- `max_swap_routes`: The maximum number of swap routes allowed.
- `max_price_impact`: The maximum price impact allowed. (Price impact is returned from Jupiter quotes. Price impact is represented as a percentage. Ex: 0.05 = 5%)
##### 2.1. Gain requirements:
- `min_gain_bps`: The minimum _estimated_ token gain [bps](https://www.investopedia.com/ask/answers/what-basis-point-bps) required.
- `min_gain_percent`: The minimum _estimated_ token gain percentage required.
- `min_gain_lamports`: The minimum _estimated_ token gain converted to lamports required.
- `min_gain_sol`: The minimum _estimated_ token gain converted to solana required.
---
#### 3.0. Fields that will directly affect the building of transactions:
- `cu_limit`: The cu limit to set per transaction. (If you're unsure, leave unset.)
---
#### 4.0. Jito specific fields:
- `jito_enabled`: Enable or disable Jito sending for the specific strategy.
##### 4.1. Dynamic Jito tipping:
- `jito_tip_percent`: (1-100) When > 0, Jito transactions will be sent with dynamic tipping based on true profit.
- `jito_min_tip_lamports`: The minimum _preferred_ dynamic Jito tip.
  - Alternatively, you can use `jito_min_tip_sol` which will do the lamport conversion for you.
- `jito_max_tip_lamports`: The maximum _preferred_ dynamic Jito tip.
  - Alternatively, you can use `jito_max_tip_sol` which will do the lamport conversion for you.
##### 4.2. Static Jito tipping:
- `jito_static_tip_lamports`: When > 0, Jito transactions will be sent with a predefined static tip. (This will send alongside dynamic Jito transactions)
  - Alternatively, you can use `jito_static_tip_sol` which will do the lamport conversion for you.
---
#### 5.0. Spam specific fields:
- `spam_senders`: A list of normal transaction senders, which consist of rpc, skip_preflight, and max_retries.
- `spam_unique`: Defaults to false, but when enabled, sends unique transactions for all spam senders listed.
- `spam_cooldown`: The amount of time to wait before trying to send another normal transaction from the given strategy. (Examples: "100ms", "5s")