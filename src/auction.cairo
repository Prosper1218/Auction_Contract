#[starknet::interface]
trait IAuction<TContractState> {
    fn register_item(ref self: TContractState, item_name: ByteArray);

    fn unregister_item(ref self: TContractState, item_name: ByteArray);

    fn bid(ref self: TContractState, item_name: ByteArray, amount: u32);

    fn get_highest_bidder(self: @TContractState, item_name: ByteArray) -> u32;

    fn is_registered(self: @TContractState, item_name: ByteArray) -> bool;
}

#[starknet::contract]
mod Auction {
    #[storage]
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    struct Storage {
        bid: Map<ByteArray, u32>,
        register: Map<ByteArray, bool>,
        // name: ByteArray,
    // amount: u32,
    }
    //TODO Implement interface and events .. deploy contract

    #[abi(embed_v0)]
    impl Auction of super::IAuction<ContractState> {
        fn register_item(ref self: TContractState, item_name: ByteArray) {
            self.register.write(item_name, true)
        }
        fn unregister_item(ref self: TContractState, item_name: ByteArray) {
            self.register.write(item_name, false)
        }
        fn bid(ref self: TContractState, item_name: ByteArray, amount: u32) {
            let highest_bid = self.bid.read(item_name);
            if amount > highest_bid {
                self.bid.write(item_name, amount);
            }
        }
        fn get_highest_bidder(self: @TContractState, item_name: ByteArray) -> u32 {
            self.bid.read(item_name)
        }

        fn is_registered(self: @TContractState, item_name: ByteArray) -> bool {
            self.register.read(item_name)
        }
    }
}

