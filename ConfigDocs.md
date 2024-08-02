# NotArb Arbitrage Bot Configuration

Here are the available configurations with brief info. The config file is in TOML format.

```toml
# Miscellaneous configuration (Required)
[bot_misc]
keypair_path="/path/to/keypair.json OR /path/to/keypair.txt" # Path to the keypair file used for signing transactions
disable_http_pools=false # Disable HTTP pools for debugging purposes (will be removed in future)

# Swap executor configuration (Required - this may be merged into bot_misc in the future)
[swap_executor]
max_threads=10 # Maximum number of threads for handling swap requests (defaults to the number of available processors)

# Jupiter configuration (Required)
[jupiter]
url="http://0.0.0.0:8080/" # URL of your Jupiter server
http_timeout_ms=3000 # HTTP request timeout for Jupiter (in milliseconds)
http_pool_max_size=50 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=0 # Maximum number of requests per second to Jupiter
thread_pool_size=0 # Number of threads for dispatching requests
unmetered=true # Ignore rate limits and send requests as fast as possible

# RPC configuration (At least one required for blockhash fetching)
[[rpc]] # This is just an example, we advise changing this from solana's public rpc.
enabled=true # Enable or disable this RPC node configuration (default: true)
key="solana-pub" # Unique key identifier for this RPC configuration
url="https://api.mainnet-beta.solana.com" # URL and port of your RPC server
http_timeout_ms=3000 # HTTP request timeout for RPC (in milliseconds)
http_pool_max_size=5 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=10 # Maximum number of requests per second to this RPC
thread_pool_size=3 # Number of threads for dispatching RPC requests

# Jito configuration (At least one required for sending Jito transactions)
# Swaps will execute on the enabled Jito dispatcher with the least amount of requests queued.
[[jito]]
enabled=false # Enable or disable sending (default: true)
url="https://mainnet.block-engine.jito.wtf" # URL of the block engine
http_timeout_ms=3000 # HTTP request timeout (in milliseconds)
http_pool_max_size=5 # Maximum number of HTTP connections allowed to be pooled for this dispatcher's requests (default: 5)
requests_per_second=5 # Maximum number of requests per second allowed to be dispatched
thread_pool_size=5 # Number of threads for dispatching requests
queue_timeout_ms=7500 # Timeout for requests in the queue to prevent overload; ensures the queue doesn't grow faster than it is processed
proxy_host="" # All proxy settings are optional
proxy_port=8002
proxy_user=""
proxy_password=""

# Blockhash fetcher (Required - needed to ensure transactions have the latest blockhash to land)
[blockhash_fetcher]
rpc_keys=["solana-pub"] # List of RPC keys to fetch blockhashes from
commitment="confirmed" # Commitment level of the blockhash to fetch
fetch_rate_ms=1200 # Interval for fetching the latest blockhash (in milliseconds)

# Jupiter token fetcher (Optional)
[jupiter_token_fetcher]
enabled=true # Enable or disable the Jupiter token fetcher
fetch_ms=10000 # Interval for fetching tradable tokens from Jupiter (in milliseconds)
max_per_cycle=5 # Maximum number of tokens to attempt a swap per cycle
required_tags=[ # Fetched tokens must match at least one group to be accepted.
    ["birdeye-trending"],
    #["pump"],
    #["lst"],
    #["pump", "verified"]
    #["community"]
]

# Token list config (Optional, but if no token suppliers are enabled the bot won't have tokens to swap with)
[[token_list]]
enabled=true # Enable or disable this token list
random_order=true # Randomize the order of tokens in this list
max_per_cycle=5 # Maximum number of tokens to attempt a swap per cycle
mints=[ # List of token mints to use
    "So11111111111111111111111111111111111111112", # SOL
    "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB", # USDT
    "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", # USDC
]

# Transaction sender config (Optional - used to send non-jito transactions)
[[tx_sender]]
enabled=false # Enable or disable this transaction sender
rpc_keys=["shyft"] # List of RPC keys to send transactions from
min_gain_type="solana" # accepted types: solana, lamports, bps, percent
min_gain_value=0.5 # keep in mind by the time the tx lands this value may change drastically
cooldown_duration="10s" # How long can this transaction sender wait before trying to send another transaction
skip_preflight=true # Default Solana "skipPreflight" transaction option
max_retries=0 # Default Solana "maxRetries" transaction option

# Swap config (Required - at least one required to execute swaps)
[[swap]]
enabled=true # Enable or disable this swap configuration
mint="So11111111111111111111111111111111111111112" # Base mint to trade
decimals=9 # Number of decimals for the base mint (important for price calculations)

[swap.strategy_defaults]
wrap_unwrap_sol=false # Default strategy configuration for all swaps
# Refer to Strategy Fields below #

[[swap.strategy]]
enabled=false # Enable or disable this specific strategy
min_spend=0.001 # Minimum amount to spend per swap
max_spend=0.1 # Maximum amount to spend per swap
min_priority_fee_lamports=180 # Minimum priority fee in lamports
max_priority_fee_lamports=180 # Maximum priority fee in lamports
jito_only=true # Restrict this strategy to Jito only
# Refer to Strategy Fields below #
```

## Strategy Fields

The following fields are used in the strategy configuration:

- `wrap_unwrap_sol`: Whether to automatically wrap and unwrap SOL for transactions.
- `min_spend`: The minimum amount to spend per swap operation.
- `max_spend`: The maximum amount to spend per swap operation.
- `min_priority_fee_lamports`: The minimum priority fee for transactions in lamports.
- `max_priority_fee_lamports`: The maximum priority fee for transactions in lamports.
- `max_swap_routes`: The maximum number of swap routes that can be utilized.
- `entry_only_direct_routes`: Restrict the entry swaps to direct routes only.
- `entry_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during entry swaps.
- `entry_min_slippage_bps`: The minimum slippage allowed for entry swaps (in basis points).
- `entry_max_slippage_bps`: The maximum slippage allowed for entry swaps (in basis points).
- `entry_max_auto_slippage_bps`: The maximum automatic slippage for entry swaps (in basis points).
- `entry_max_accounts`: The maximum number of accounts that can be used for entry swaps.
- `entry_dexes`: The list of DEXes allowed for entry swaps.
- `entry_exclude_dexes`: The list of DEXes to exclude from entry swaps.
- `entry_max_price_impact`: The maximum price impact allowed for entry swaps (as a percentage).
- `exit_only_direct_routes`: Restrict the exit swaps to direct routes only.
- `exit_restrict_intermediate_tokens`: Restrict the use of intermediate tokens during exit swaps.
- `exit_min_slippage_bps`: The minimum slippage allowed for exit swaps (in basis points).
- `exit_max_slippage_bps`: The maximum slippage allowed for exit swaps (in basis points).
- `exit_max_auto_slippage_bps`: The maximum automatic slippage for exit swaps (in basis points).
- `exit_max_accounts`: The maximum number of accounts that can be used for exit swaps.
- `exit_dexes`: The list of DEXes allowed for exit swaps.
- `exit_exclude_dexes`: The list of DEXes to exclude from exit swaps.
- `exit_max_price_impact`: The maximum price impact allowed for exit swaps (as a percentage).
- `jito_tip_percent`: The percentage of the tip to be given to Jito (0-100%).
- `min_pref_jito_tip`: The minimum preferred Jito tip.
- `max_pref_jito_tip`: The maximum preferred Jito tip.
- `jito_only`: Restrict this strategy to use only Jito transactions. (Ths will most likely be changed!)
