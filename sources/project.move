module MyModule::CharityDrives {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a charity drive.
    struct CharityDrive has store, key {
        total_raised: u64,  // Total tokens raised for the charity
        goal: u64,          // Target fundraising goal
    }

    /// Function to create a new charity drive with a fundraising goal.
    public fun create_drive(organizer: &signer, goal: u64) {
        let drive = CharityDrive {
            total_raised: 0,
            goal,
        };
        move_to(organizer, drive);
    }

    /// Function to donate tokens to the charity drive.
    public fun donate(donor: &signer, organizer_address: address, amount: u64) acquires CharityDrive {
        let drive = borrow_global_mut<CharityDrive>(organizer_address);

        // Transfer donation from donor to the charity organizer
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(organizer_address, donation);

        // Update the total raised amount
        drive.total_raised = drive.total_raised + amount;
    }
}
