use opus::types::QuoteTokenInfo;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IEkuboOracleAdapter<TContractState> {
    // getters
    fn get_oracle_extension(self: @TContractState) -> ContractAddress;
    fn get_quote_tokens(self: @TContractState) -> Span<QuoteTokenInfo>;
    fn get_twap_duration(self: @TContractState) -> u64;
    // setters
    fn set_oracle_extension(ref self: TContractState, oracle_extension: ContractAddress);
    fn set_quote_tokens(ref self: TContractState, quote_tokens: Span<ContractAddress>);
    fn set_twap_duration(ref self: TContractState, twap_duration: u64);
}
