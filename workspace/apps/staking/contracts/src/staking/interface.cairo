use starknet::ContractAddress;

use contracts_commons::custom_defaults::{ContractAddressDefault, OptionDefault};

// TODO create a different struct for not exposing internal implemenation
#[derive(Debug, Default, PartialEq, Drop, Serde, Copy, starknet::Store)]
pub struct StakerInfo {
    pub reward_address: ContractAddress,
    pub operational_address: ContractAddress,
    pub pooling_contract: Option<ContractAddress>,
    pub unstake_time: Option<felt252>,
    pub amount_own: u64,
    pub amount_pool: u64,
    pub index: u128,
    pub unclaimed_rewards_own: u64,
    pub unclaimed_rewards_pool: u64,
}


#[derive(Default, Drop, PartialEq, Serde)]
pub struct StakingContractInfo {
    pub max_leverage: u64,
    pub min_stake: u64,
    pub token_address: ContractAddress,
    pub global_index: u128,
    pub global_rev_share: u8,
}

#[starknet::interface]
pub trait IStaking<TContractState> {
    fn stake(
        ref self: TContractState,
        reward_address: ContractAddress,
        operational_address: ContractAddress,
        amount: u64,
        pooling_enabled: bool
    ) -> bool;
    fn increase_stake(
        ref self: TContractState, staker_address: ContractAddress, amount: u64
    ) -> u64;
    fn claim_rewards(ref self: TContractState, staker_address: ContractAddress) -> u64;
    fn unstake_intent(ref self: TContractState, staker_address: ContractAddress) -> felt252;
    fn unstake_action(ref self: TContractState, staker_address: ContractAddress) -> u64;
    fn add_to_pool(ref self: TContractState, staker_address: ContractAddress, amount: u64) -> u64;
    fn remove_from_pool_intent(
        ref self: TContractState, staker_address: ContractAddress, amount: u64
    ) -> felt252;
    fn remove_from_pool_action(ref self: TContractState, staker_address: ContractAddress) -> u64;
    fn switch_pool(
        ref self: TContractState,
        from_staker_address: ContractAddress,
        to_staker_address: ContractAddress,
        pool_address: ContractAddress,
        amount: u64,
        data: ByteArray
    ) -> bool;
    fn change_reward_address(ref self: TContractState, reward_address: ContractAddress) -> bool;
    fn set_open_for_pooling(ref self: TContractState) -> ContractAddress;
    fn state_of(self: @TContractState, staker_address: ContractAddress) -> StakerInfo;
    fn contract_parameters(self: @TContractState) -> StakingContractInfo;
}