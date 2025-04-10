use opus::interfaces::absorber::IBlesserDispatcher;
use starknet::ContractAddress;
use wadray::{Ray, Wad};


#[derive(Copy, Drop, PartialEq, Serde)]
pub enum YangSuspensionStatus {
    None,
    Temporary,
    Permanent
}

#[derive(Copy, Drop, Serde)]
pub struct Health {
    // In the case of a trove, either:
    // 1. the base threshold at which the trove can be liquidated in normal mode; or
    // 2. the threshold at which the trove can be liquidated based on current on-chain
    //    conditions.
    //
    // In the case of Shrine, the base threshold for calculating recovery mode status
    pub threshold: Ray,
    // Debt as a percentage of value
    pub ltv: Ray,
    // Total value of collateral
    pub value: Wad,
    // Total amount of debt
    pub debt: Wad,
}

#[generate_trait]
pub impl HealthImpl of HealthTrait {
    fn is_healthy(self: @Health) -> bool {
        (*self.ltv) <= (*self.threshold)
    }
}

#[derive(Copy, Drop, Serde)]
pub struct YangBalance {
    pub yang_id: u32, //  ID of yang in Shrine
    pub amount: Wad, // Amount of yang in Wad
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub struct AssetBalance {
    pub address: ContractAddress, // Address of the ERC-20 asset
    pub amount: u128, // Amount of the asset in the asset's decimals
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub struct Trove {
    pub charge_from: u64, // Time ID (timestamp // TIME_ID_INTERVAL) for start of next accumulated interest calculation
    pub last_rate_era: u64,
    pub debt: Wad, // Normalized debt
}

//
// Absorber
//

// For blessings, the `asset_amt_per_share` is a cumulative value that is updated until the given
// epoch ends
#[derive(Copy, Drop, PartialEq, Serde)]
pub struct DistributionInfo {
    // Amount of asset in its decimal precision per share wad
    // This is packed into bits 0 to 127.
    pub asset_amt_per_share: u128,
    // Error to be added to next distribution of rewards
    // This is packed into bits 128 to 251.
    // Note that the error should never approach close to 2 ** 123, but it is capped to this value
    // anyway to prevent redistributions from failing in this unlikely scenario, at the expense of
    // providers losing out on some rewards.
    pub error: u128,
}

#[derive(Copy, Drop, Serde)]
pub struct Reward {
    pub asset: ContractAddress, // ERC20 address of token
    pub blesser: IBlesserDispatcher, // Address of contract implementing `IBlesser` for distributing the token to the absorber
    pub is_active: bool, // Whether the blesser (vesting contract) should be called
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub struct Provision {
    pub epoch: u32, // Epoch in which shares are issued
    pub shares: Wad, // Amount of shares for provider in the above epoch
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub struct Request {
    pub timestamp: u64, // Timestamp of request
    pub timelock: u64, // Amount of time that needs to elapse after the timestamp before removal
    pub is_valid: bool, // Whether the request is still valid i.e. provider has not called `remove` or `provide`
}

//
// Frontend Data Provider
//

#[derive(Copy, Drop, Serde)]
pub struct YinInfo {
    pub spot_price: Wad, // Spot price of yin
    pub total_supply: Wad, // Total supply of yin
    pub ceiling: Wad, // Maximum amount of yin allowed
}

#[derive(Copy, Drop, Serde)]
pub struct RecoveryModeInfo {
    pub is_recovery_mode: bool,
    pub target_ltv: Ray, // Recovery mode is triggered once Shrine's LTV exceeds this
    pub buffer_ltv: Ray, // Thresholds are scaled once Shrine's LTV exceeds this
}

#[derive(Copy, Drop, Serde)]
pub struct TroveInfo {
    pub trove_id: u64,
    pub owner: ContractAddress,
    pub max_forge_amt: Wad,
    pub is_liquidatable: bool,
    pub is_absorbable: bool,
    pub health: Health,
    pub assets: Span<TroveAssetInfo>,
}

#[derive(Copy, Drop, Serde)]
pub struct TroveAssetInfo {
    pub shrine_asset_info: ShrineAssetInfo,
    pub amount: u128, // Amount of the yang's asset in the asset's decimals for the trove
    pub value: Wad, // Value of the yang in the trove
}

#[derive(Copy, Drop, Serde)]
pub struct ShrineAssetInfo {
    pub address: ContractAddress, // Address of the yang's ERC-20 asset
    pub price: Wad, // Price of the yang's asset
    pub threshold: Ray, // Base threshold of the yang
    pub base_rate: Ray, // Base rate of the yang
    pub deposited: u128, // Amount of yang's asset in the asset's decimals deposited in Shrine
    pub ceiling: u128, // Maximum amount of yang's asset in Shrine
    pub deposited_value: Wad // Value of yang deposited in Shrine
}


//
// Receptor
//

#[derive(Copy, Drop, PartialEq, Serde)]
pub struct QuoteTokenInfo {
    pub address: ContractAddress,
    pub decimals: u8,
}

//
// Pragma
//

pub mod pragma {
    #[derive(Copy, Drop, PartialEq, Serde)]
    pub enum AggregationMode {
        Median,
        Mean,
        Error
    }

    #[derive(Copy, Drop, Serde)]
    pub enum DataType {
        SpotEntry: felt252,
        FutureEntry: (felt252, u64),
        GenericEntry: felt252,
    }

    #[derive(Copy, Drop, Serde)]
    pub struct PragmaPricesResponse {
        pub price: u128,
        pub decimals: u32,
        pub last_updated_timestamp: u64,
        pub num_sources_aggregated: u32,
        pub expiration_timestamp: Option<u64>,
    }

    #[derive(Copy, Drop, PartialEq, Serde)]
    pub struct PriceValidityThresholds {
        // the maximum number of seconds between block timestamp and
        // the last update timestamp (as reported by Pragma) for which
        // we consider a price update valid
        pub freshness: u64,
        // the minimum number of data publishers used to aggregate the
        // price value
        pub sources: u32,
    }

    #[derive(Copy, Drop, PartialEq, Serde)]
    pub struct PairSettings {
        pub pair_id: felt252,
        pub aggregation_mode: AggregationMode,
    }
}

//
// Seer v2
//

#[derive(Copy, Default, Drop, Debug, PartialEq, Serde)]
pub enum PriceType {
    #[default]
    Direct,
    Vault
}

//
// Stabilizer
//

#[derive(Copy, Drop, Serde, Debug, PartialEq, starknet::Store)]
pub struct Stake {
    // A 128-bit value from Ekubo representing amount of liquidity
    // provided by a position. This value should remain unchanged
    // while a position NFT is staked.
    pub liquidity: u128,
    // Snapshot of the accumulator value for yield at the time the
    // user last took an action
    pub yin_per_liquidity_snapshot: u256,
}

#[derive(Copy, Drop, Serde, Debug, PartialEq, starknet::Store)]
pub struct YieldState {
    // Yin balance of this contract at the time that
    // this contract was last called
    pub yin_balance_snapshot: u256,
    // Accumulator value for amount of yield (yin) per unit of liquidity
    // This value is obtained by scaling yin (wad precision) up by 2 ** 128
    // before dividing by total liquidity. Since total liquidity could be a
    // small `u128` value, 256 bits are used to prevent overflows.
    pub yin_per_liquidity: u256,
}
