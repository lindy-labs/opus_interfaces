use opus::types::pragma::PairSettings;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IPragma<TContractState> {
    fn set_yang_pair_id(ref self: TContractState, yang: ContractAddress, pair_id: felt252);
    fn set_price_validity_thresholds(ref self: TContractState, freshness: u64, sources: u32);
}

#[starknet::interface]
pub trait IPragmaV2<TContractState> {
    fn set_yang_pair_settings(
        ref self: TContractState, yang: ContractAddress, pair_settings: PairSettings,
    );
    fn set_price_validity_thresholds(ref self: TContractState, freshness: u64, sources: u32);
}
