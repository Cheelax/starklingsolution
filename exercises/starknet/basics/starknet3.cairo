// starknet3.cairo
// Joe liked Jill's work very much. He really likes how useful storage can be.
// Now they decided to write a contract to track the number of exercises they
// complete successfully. Jill says they can use the owner code and allow
// only the owner to update the contract, they agree.
// Can you help them write this contract?


#[contract]
mod ProgressTracker {
    use starknet::ContractAddress;
    use starknet::get_caller_address; // Required to use get_caller_address function

    struct Storage {
        contract_owner: ContractAddress,
        // TODO: Set types for LegacyMap
        progress: LegacyMap::<ContractAddress, u16>
    }

    #[constructor]
    fn constructor(owner: ContractAddress) {
        contract_owner::write( owner );
    }

    #[external]
    fn set_progress(user: ContractAddress, new_progress: u16) {
        // TODO: assert owner is calling
        let caller = get_caller_address();
        assert(caller == contract_owner::read(), 'Not the owner');
        // TODO: set new_progress for user,
        progress::write(user, new_progress);
    }

    #[view]
    fn get_progress(user: ContractAddress) -> u16 {
        progress::read(user)
    }

}

#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use array::ArrayTrait;
    use array::SpanTrait;
    use debug::PrintTrait;
    use traits::TryInto;

    use starknet::Felt252TryIntoContractAddress;
    use option::OptionTrait;
    use super::ProgressTracker;

    #[test]
    #[available_gas(2000000000)]
    fn test_owner() {

        let owner: felt252 = 'Sensei';
        let owner: ContractAddress = owner.try_into().unwrap();
        ProgressTracker::constructor(owner);

        // Check that contract owner is set
        let contract_owner = ProgressTracker::contract_owner::read();
        assert(contract_owner == owner, 'Mr. Sensei should be the owner');
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_set_progress() {
        let owner = util_felt_addr( 'Sensei' );
        ProgressTracker::constructor(owner);

        // Call contract as owner
        starknet::testing::set_caller_address( owner );

        // Set progress
        ProgressTracker::set_progress( 'Joe'.try_into().unwrap(), 20_u16 );
        ProgressTracker::set_progress( 'Jill'.try_into().unwrap(), 25_u16 );

        let joe_score = ProgressTracker::get_progress( 'Joe'.try_into().unwrap() );
        assert( joe_score == 20_u16, 'Joe\'s progress should be 20' );
    }

    #[test]
    #[should_panic]
    #[available_gas(2000000000)]
    fn test_set_progress_fail() {
        let owner = util_felt_addr( 'Sensei' );
        ProgressTracker::constructor(owner);

        let jon_doe = util_felt_addr( 'JonDoe' );
        // Caller not owner
        starknet::testing::set_caller_address( jon_doe );

        // Try to set progress, should panic to pass test!
        ProgressTracker::set_progress( 'Joe'.try_into().unwrap(), 20_u16 );
    }

    fn util_felt_addr(addr_felt: felt252) -> ContractAddress {
        addr_felt.try_into().unwrap()
    }
}