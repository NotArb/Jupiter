# NotArb Bot Configuration Guide

## Overview

This guide provides detailed instructions on configuring your NotArb bot using the provided configuration options.

[View Example Configs](https://examples.notarb.org/)

## Configuration Options

```toml
# Miscellaneous configuration (Required)
[bot_misc]
keypair_path="/path/to/keypair.json OR /path/to/keypair.txt" # Path to the keypair file used for signing transactions
swap_threads=0 # Number of threads for handling swap requests (if left 0, the bot will automatically determine an optimal amount)
jito_threads=0 # Number of threads for dispatching Jito requests. (if left 0, the bot will automatically determine an optimal amount)
spam_threads=0 # Number of threads for dispatching Spam requests. (if left 0, the bot will automatically determine an optimal amount)
acknowledge_terms_of_service=false # required to run notarb
acknowledge_external_price_risk=false # required to run notarb when trading with anything other than SOL, which require 3rd party price fetches
price_api_gecko=false # optional to use Gecko Terminal API prices instead of Jupiter Price API prices

# Jupiter configuration (Required) (You can optionally use this same exact structure with [jupiter_quote] and [jupiter_swap] to slit Jupiter load)
[jupiter]
url="http://0.0.0.0:8080/" # URL of your Jupiter server
http_timeout_ms=3000 # HTTP request timeout for Jupiter (in milliseconds)
http_pool_max_size=50 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
http_pool_keep_alive="5m" # Maximum amount of time a pooled HTTP connection can be idle for. (default: "5m")

# RPC configuration (Only required for spam sending and simulation mode)
# This is just an example, we advise changing this from solana's public rpc.
[[rpc]]
enabled=true # Enable or disable this RPC node configuration (default: true)
id="solana-pub" # Unique custom identifier for this RPC configuration
url="https://api.mainnet-beta.solana.com" # URL and port of your RPC server
http_timeout_ms=1000 # HTTP request timeout for RPC (in milliseconds)
http_pool_max_size=10 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
http_pool_keep_alive="5m" # Maximum amount of time a pooled HTTP connection can be idle for. (default: "5m")

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
proxy_wallet=false # When true, uses a separate wallet for tips. Sends 0.01 initially to cover minimum balance, refunded at transaction end.
bind_ip="" # Set this to bind outgoing requests to a specific source IP, like a lightweight proxy without an intermediary server.

# Token Accounts Fetcher (Optional)
[token_accounts_fetcher] # This allows the bot to know what token accounts are already open, allowing for faster transaction building.
enabled=false
rpc="solana-pub"

# Simulation mode (Optional)
[simulation_mode]
enabled=false
rpc="solana-pub"
skip_known_jupiter_errors=true # When true, known Jupiter errors will be skipped from output
skip_successful_responses=false # When true, successful responses will be skipped from output
skip_no_profit_responses=false # When true, no profit responses will be skipped from output
force_blockhash=true # When true, the "replaceRecentBlockhash=true" Solana variable will be set

# Wsol Unwrapper (Optional)
[wsol_unwrapper] # Requires SOL balance for network fees
enabled=false
rpc="your-rpc-id" # the rpc used for the balance check & rebalance transaction
check_minutes=1 # interval in minutes to check if an unwrap is required
min_sol=0.5 # triggers an unwrap when your sol balance is less than this number
unwrap_sol=1 # unwraps this amount of wsol to sol
priority_fee_lamports=0 # optional, but can help tx land

## Below are configurations for mint suppliers. There are currently 4 types of mint suppliers:
# [dynamic_mints] - only 1 configuration allowed
# [[static_mints]] - multiple configurations allowed
# [[file_mints]] - multiple configurations allowed
# [[url_mints]] - multiple configurations allowed
# At least one mint supplier is required for the bot to operate.
# Note: More mints may result in opening multiple token accounts, which can affect your balance due to account creation fees. Token accounts are only opened once.

## Dynamic Mints DEPRECATED - this will be removed in a later release
[dynamic_mints] # this is the only mint configuration where only one configuration is allowed, hence the single brackets
enabled=true
limit=100 # optional - limits the number of mints obtained from this supplier, ordered by highest daily volume first
export_path="dynamic-mints.txt" # optional - useful for debugging

untradable_cooldown="1m" # optional - if the bot detects an untradable token, that token will be put on a cooldown for the given duration (default 1m)
max_per_cycle=10 # optional - used to limit how many mints can be processed from this mint supplier per bot cycle (default unlimited)
update_seconds=10 # optional - this pulls from Jupiter's public endpoint, keep that in mind if running multiple bots for rate limiting (default 10, min 5)

exclude=[ # optional
  "So11111111111111111111111111111111111111112",  # sol
  "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB", # usdt
  "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", # usdc
]

## NOTE: Filter configurations must be placed at the end, after other settings like exclude and enabled. ##

[[dynamic_mints.filter]] # example filter to pick up all mints with either a birdeye-trending tag OR pump and verified tags
include_tags=[ # an array of tag groups, only one group match required to be included
  ["birdeye-trending"],
  ["pump", "verified"]
]

[[dynamic_mints.filter]] # example filter to pick up new mints
max_age="3d" # d=days, h=hours, m=minutes
min_daily_volume=10_000
exclude_tags=[ # an array of tag groups, only one group match is required to be excluded
  ["strict"],
  ["community"]
] # Juptier token tags can be found here: https://station.jup.ag/docs/token-list/token-list-api

## Static Mints
[[static_mints]] # double brackets since we allow multiple
enabled=true
untradable_cooldown="1m" # optional - if the bot detects an untradable token, that token will be put on a cooldown for the given duration (default 1m)
max_per_cycle=10 # optional - use this to limit how many mints can be processed from this mint supplier per bot cycle (default unlimited)
random_order=false # optional - use this to randomize the order of the list every cycle (default false)
list=[
  "So11111111111111111111111111111111111111112",  # sol
  "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB", # usdt
  "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", # usdc
]

## File Mints
[[file_mints]]
enabled=true
untradable_cooldown="1m" # if the bot detects an untradable token, that token will be put on a cooldown for the given duration (default 1m)
max_per_cycle=10 # optional - use this to limit how many mints can be processed from this mint supplier per bot cycle (default unlimited)
random_order=false # optional - use this to randomize the order of the list every cycle (default false)
update_seconds=10 # optional - when set, this file will be loaded every X amount of seconds (default 0)
path="/absolute/path/to/mints.json OR /absolute/path/to/mints.txt" # the actual extension here doesn't matter, as long as the output is either a json list of strings or raw text of 1 mint per line (raw text supports # comments)

## URL Mints
[[url_mints]]
enabled=true
untradable_cooldown="1m" # optional - if the bot detects an untradable token, that token will be put on a cooldown for the given duration (default 1m)
max_per_cycle=10 # optional - use this to limit how many mints can be processed from this mint supplier per bot cycle (default unlimited)
random_order=false # optional - use this to randomize the order of the list every cycle (default false)
update_seconds=10 # optional - when set, this url will be loaded every X amount of seconds (default 0)
url="http://yoururl.com/mints.txt OR http://yoururl.com/mints.json" # the actual extension here doesn't matter, as long as the output is either a json list of strings or raw text of 1 mint per line (raw text supports # comments)

## Below are configurations for swaps with very basic placeholder settings.
## For proper example configurations, refer to: https://examples.notarb.org/

## Swap config (At least one required)
[[swap]]
enabled=true # Enable or disable this swap configuration (default: true)
mint="So11111111111111111111111111111111111111112" # Base mint to trade (can also do symbols: SOL, USDC, USDT)

[swap.strategy_defaults] # Default strategy configuration for all of this swap's strategies
wrap_unwrap_sol=false 
jito_enabled=true
cooldown="3s"
# Refer to Strategy Fields below #

[[swap.strategy]]
enabled=true
min_spend=0.001 
max_spend=0.01
cu_limit=250_000 # If not set, the bot will set this value for you. (This is advised for Jito)
min_gain_bps=20 # Minimum _estimated_ gain required in bps; note that the actual profit may vary by the time the transaction lands. Consider starting with a higher value to be safe.
min_priority_fee_lamports=190 # Alternatively you can use min_priority_fee_sol
max_priority_fee_lamports=190 # Alternatively you can use max_priority_fee_sol
spam_senders=[ # Normal transaction senders list
    { rpc="solana-pub", skip_preflight=true, max_retries=0, unique=false },
]
spam_max_opportunity_age_ms=100 # The maximum amount of time allowed from when the opportunity was found. (default: 1000) (The name of this may change in the future)
# Refer to Strategy Fields below #
```

## Strategy Fields

#### 1.0. Fields that will directly affect the results of Jupiter entry/exit quotes:
- `min_spend`: The minimum amount to spend per swap operation.
- `max_spend`: The maximum amount to spend per swap operation.
- `min_priority_fee_lamports`: The minimum priority fee for transactions in lamports.
  - Alternatively, you can use `min_priority_fee_sol` which will do the lamport conversion for you.
- `max_priority_fee_lamports`: The maximum priority fee for transactions in lamports.
  - Alternatively, you can use `max_priority_fee_sol` which will do the lamport conversion for you.
##### 1.1. Entry specific:
- `entry_only_direct_routes`: Restrict the entry swaps to direct routes only.
- `entry_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during entry swaps.
- `entry_max_accounts`: The maximum number of accounts that can be used for entry swaps.
  - Alternatively, you can use `total_max_accounts` to limit total accounts instead.
- `entry_dexes`: A list of DEXes allowed for entry swaps.
- `entry_exclude_dexes`: A list of DEXes to exclude from entry swaps.
##### 1.2. Exit specific: (The same as above, but specific to exit quotes)
- `exit_only_direct_routes`: Restrict the exit swaps to direct routes only.
- `exit_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during exit swaps.
- `exit_max_accounts`: The maximum number of accounts that can be used for exit swaps.
  - Alternatively, you can use `total_max_accounts` to limit total accounts instead.
- `exit_dexes`: A list of DEXes allowed for exit swaps.
- `exit_exclude_dexes`: A list of DEXes to exclude from exit swaps.
---
#### 2.0. Fields that will determine if a transaction will be skipped, after quotes are acquired:
- `cooldown`: The waiting period before attempting the same token opportunity again for the given strategy. (default: "3s")
- `min_swap_routes`: The minimum number of swap routes allowed. (Should never be less than 2)
- `max_swap_routes`: The maximum number of swap routes allowed.
- `max_price_impact`: The maximum price impact allowed. (Price impact is returned from Jupiter quotes. Price impact is represented as a percentage. Ex: 0.05 = 5%)
##### 2.1. Gain requirements:
- `min_gain_bps`: The minimum _estimated_ token gain [bps](https://www.investopedia.com/ask/answers/what-basis-point-bps) required.
- `min_gain_percent`: The minimum _estimated_ token gain percentage required.
- `min_gain_lamports`: The minimum _estimated_ token gain converted to lamports required.
- `min_gain_sol`: The minimum _estimated_ token gain converted to solana required.
---
#### 3.0. Fields that will directly affect the building of transactions:
- `wrap_unwrap_sol`: Whether to automatically wrap and unwrap SOL for transactions. (default: false)
- `skip_user_accounts_rpc_calls`: Only use if you're 100% certain every trade will only use tokens you have accounts open for. (default: false)
- `cu_limit`: The cu limit to set per transaction. (If you're unsure, leave unset.)
---
#### 4.0. Jito specific fields:
- `jito_enabled`: Enable or disable Jito sending.
- `jito_unwrap_tip`: When true, WSOL will be unwrapped on-chain to pay your Jito tip. This is only applicable when your base is Solana.
- `jito_dynamic_tip_percent`: (1-100) When > 0, Jito transactions will be sent with dynamic tips based on true profit.
- `jito_static_tip_percent`: (1-100) When > 0, Jito transactions will be sent with static tips based on quoted profit.
- `jito_max_tip_lamports`: The maximum Jito tip allowed when using tip percentages.
  - Alternatively, you can use `jito_max_tip_sol` which will do the lamport conversion for you.
- `jito_static_tip_lamports`: When > 0, Jito transactions will be sent with a predefined static tip.
  - Alternatively, you can use `jito_static_tip_sol` which will do the lamport conversion for you.
  - Using `jito_static_tip_percent` will override this field.
---
#### 5.0. Spam specific fields:
- `spam_senders`: A list of spam transaction senders, which consist of rpc, skip_preflight, and max_retries.
- `spam_max_opportunity_age_ms`: The maximum amount of time allowed from when the opportunity was found.