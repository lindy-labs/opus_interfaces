use opus::types::{Stake, YieldState};
use starknet::ContractAddress;

#[starknet::interface]
pub trait IStabilizer<TContractState> {
    //
    // Getters
    //

    // These two functions have been commented out because Ekubo has not been published
    // as a package on scarbs.xyz, and consequently it cannot be imported due to the
    // requirement that a package must have a version specified.
    //
    // If you need to make use of these two functions, create a separate interface and add
    // this line to your Scarb.toml
    // `ekubo = { git = "https://github.com/EkuboProtocol/abis", commit =
    // "edb6de8c9baf515f1053bbab3d86825d54a63bc3" }`

    // fn get_pool_key(self: @TContractState) -> PoolKey;
    // fn get_bounds(self: @TContractState) -> Bounds;

    fn get_total_liquidity(self: @TContractState) -> u128;
    fn get_token_id_for_user(self: @TContractState, user: ContractAddress) -> Option<u64>;
    // Note that this should not be used to check if a user has an active stake because
    // it is not updated when a user unstakes. Use `get_token_id_for_user` instead.
    fn get_stake(self: @TContractState, user: ContractAddress) -> Stake;
    fn get_yield_state(self: @TContractState) -> YieldState;

    //
    // External functions
    //
    fn stake(ref self: TContractState, token_id: u64);
    fn unstake(ref self: TContractState);
    fn claim(ref self: TContractState);
}
