/*
    The quest implements P2P trading involving off-chain (USD) and on-chain (APT) assets.
    In the quest, a user is able to create an offer stating amount of APT they want to buy or sell and amount of USD
        they will give/want to receive from the transaction.
    Any other user can accept any of the available offers. After both parties mark the transaction as completed,
        the on-chain assets can be transfered to the eligible party.
    In any case of disagreement, a dispute can be opened. Only the arbiter, that is set while creating an offer, can
        resolve a dispute.
*/
module overmind::broker_it_yourself {
    use std::option::Option;

    use aptos_std::simple_map::SimpleMap;
    use aptos_framework::account::SignerCapability;
    use aptos_framework::event::EventHandle;

    use overmind::broker_it_yourself_events::{CreateOfferEvent, AcceptOfferEvent, CompleteTransactionEvent, ReleaseFundsEvent, CancelOfferEvent, OpenDisputeEvent, ResolveDisputeEvent};

    friend overmind::broker_it_yourself_tests;

    ////////////
    // ERRORS //
    ////////////

    const ERROR_SIGNER_NOT_ADMIN: u64 = 0;
    const ERROR_STATE_NOT_INITIALIZED: u64 = 1;
    const ERROR_INSUFFICIENT_FUNDS: u64 = 2;
    const ERROR_OFFER_DOES_NOT_EXIST: u64 = 3;
    const ERROR_OFFER_ALREADY_ACCEPTED: u64 = 4;
    const ERROR_OFFER_NOT_ACCEPTED: u64 = 5;
    const ERROR_USER_DOES_NOT_PARTICIPATE_IN_TRANSACTION: u64 = 6;
    const ERROR_USER_ALREADY_MARKED_AS_COMPLETED: u64 = 7;
    const ERROR_SIGNER_NOT_CREATOR: u64 = 8;
    const ERROR_DISPUTE_ALREADY_OPENED: u64 = 9;
    const ERROR_DISPUTE_NOT_OPENED: u64 = 10;
    const ERROR_SIGNER_NOT_ARBITER: u64 = 11;

    // PDA seed
    const SEED: vector<u8> = b"broker_it_yourself";

    /*
        Resource struct holding data about available offers
    */
    struct State has key {
        // List of available offers
        offers: SimpleMap<u128, Offer>,
        // Cache storing creators' available offers
        creators_offers: SimpleMap<address, vector<u128>>,
        // Incrementing counter for indexing offers
        offer_id: u128,
        // PDA's SingerCapability
        cap: SignerCapability,
        // Events
        create_offer_events: EventHandle<CreateOfferEvent>,
        accept_offer_events: EventHandle<AcceptOfferEvent>,
        complete_transaction_events: EventHandle<CompleteTransactionEvent>,
        release_funds_events: EventHandle<ReleaseFundsEvent>,
        cancel_offer_events: EventHandle<CancelOfferEvent>,
        open_dispute_events: EventHandle<OpenDisputeEvent>,
        resolve_dispute_events: EventHandle<ResolveDisputeEvent>
    }

    /*
        Struct holding data about a single offer
    */
    struct Offer has store, drop, copy {
        // Address of the creator of the offer
        creator: address,
        // Address of the arbiter that can take actions when a dispute is opened
        arbiter: address,
        // Amount of APT coins
        apt_amount: u64,
        // Amount of USD
        usd_amount: u64,
        // Address of the counterparty for the offer
        counterparty: Option<address>,
        // Instance of OfferCompletion
        completion: OfferCompletion,
        // Flag indicating if a dispute for the offer is opened. False by default
        dispute_opened: bool,
        // Flag indicating if the creator is selling or buying APT
        sell_apt: bool
    }

    /*
        Struct holding data about status of an offer. The transaction is completed and APT can be released only if
        both flags have value of `true`
    */
    struct OfferCompletion has store, drop, copy {
        // Flag indicating if the creator marked the transaction as completed. False by default
        creator: bool,
        // Flag indicating if the counterparty marked the transaction as completed. False by default
        counterparty: bool
    }

    /*
        Inits the smart contract by creating a PDA account and State resource
        @param admin - signer representing the admin
    */
    public entry fun init(admin: &signer) {
        // TODO: Call assert_signer_is_admin function

        // TODO: Create a resource account using `SEED` global constant

        // TODO: Register the resource account with AptosCoin

        // TODO: Move State resource to the admin address
    }

    /*
        Creates a new offer.
        @param creator - signer representing the creator of the offer
        @param arbiter - address of the arbiter
        @param apt_amount - amount of APT that the creator's offering or wants to receive from the transaction
        @param usd_amount - amount of USD that the creator wants to receive from the transaction or is offering.
        @param sell_apt - flag indicating if the creator's selling or buying APT
    */
    public entry fun create_offer(
        creator: &signer,
        arbiter: address,
        apt_amount: u64,
        usd_amount: u64,
        sell_apt: bool
    ) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call get_next_offer_id function

        // TODO: Create instance of Offer struct

        // TODO: Add the Offer instance to the list of available offers

        // TODO: Add the offer id to the creator's offers list

        // TODO: Transfer appropriate amount of APT to the PDA if sell_apt == true && assert_user_has_enough_funds

        // TODO: Emit CreateOfferEvent event
    }

    /*
        Pairs a user with already created offer
        @param user - signer representing the user, who accepts the offer
        @param offer_id - id of the offer
    */
    public entry fun accept_offer(user: &signer, offer_id: u128) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call assert_offer_exists function

        // TODO: Call assert_offer_not_accepted function

        // TODO: Call assert_dispute_not_opened function

        // TODO: Set Offer's counterparty field to the address of the user

        // TODO: Transfer appropriate APT amount from the user to the PDA if Offer's sell_apt == false &&
        //      assert_user_has_enough_funds

        // TODO: Emit AcceptOfferEvent event
    }

    /*
        Marks a transaction as completed by one of the parties and transfers on-chain assets to the eligible party
            if both parties marks the transaction as completed
        @param user - signer representing one of the parties of the transaction
        @param offer_id - id of the offer
    */
    public entry fun complete_transaction(user: &signer, offer_id: u128) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call assert_offer_exists function

        // TODO: Call assert_offer_accepted function

        // TODO: call assert_user_participates_in_transaction function

        // TODO: call assert_user_has_not_marked_completed_yet function

        // TODO: call assert_dispute_not_opened function

        // TODO: Compare the user's address and set appropriate completion flag to true

        // TODO: Emit CompleteTransactionEvent event

        // TODO: If both completion flags are true, then:
        //      1) Remove the offer from the available offers list
        //      2) Remove the offer's id from the creator's offers list
        //      3) Transfer appropriate amount of APT either to the creator or the counterparty depending on the
        //              Offer's sell_apt flag
        //      4) Emit ReleaseFundsEvent event
    }

    /*
        Removes an offer from the list of currently available offers
        @param creator - signer representing the creator of the offer
        @param offer_id - id of the offer
    */
    public entry fun cancel_offer(creator: &signer, offer_id: u128) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call assert_offer_exists function

        // TODO: Remove the offer from the list of available offers

        // TODO: Call assert_signer_is_creator function

        // TODO: Call assert_offer_not_accepted function

        // TODO: Call assert_dispute_not_opened function

        // TODO: Remove the offer's id from the creator's offers list

        // TODO: Transfer appropriate amount of APT from the PDA to the creator if the Offer's sell_apt == true

        // TODO: Emit CancelOfferEvent event
    }

    /*
        Opens a dispute over a transaction
        @param user - signer representing one of the parties of the transaction
        @param offer_id - id of the offer
    */
    public entry fun open_dispute(user: &signer, offer_id: u128) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call assert_offer_exists function

        // TODO: Call assert_user_participates_in_transaction function

        // TODO: Call assert_dispute_not_opened function

        // TODO: Set the Offer's dispute_opened flag to true

        // TODO: Emit OpenDisputeEvent event
    }

    /*
        Resolves previously opened dispute over a transaction
        @param arbiter - signer representing the arbiter of the transaction
        @param offer_id - id of the offer
        @param terminate_offer - flag indicating if the offer should be removed from the list of available offers
        @param transfer_to_creator - flag indicating if the on-chain assets should be transfered to the creator of
            the offer (true) or to the counterparty (false) in case of termination
    */
    public entry fun resolve_dispute(
        arbiter: &signer,
        offer_id: u128,
        transfer_to_creator: bool
    ) acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Call assert_offer_exists function

        // TODO: Call assert_dispute_opened function

        // TODO: Call assert_singer_is_arbiter function

        // TODO: Remove the offer from the list of available offers

        // TODO: Remove the offer's id from the creator's offers list

        // TODO: If transfer_to_creator send funds to creator, else if !transfer_to_creator send funds to counterparty
        //      if there is a counterparty

        // TODO: Emit ResolveDisputeEvent event
    }

    /*
        Returns the list of all offers
        @returns - list of all offers
    */
    #[view]
    public fun get_all_offers(): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Returns the list of all offers
    }

    /*
        Returns the list of available offers
        @returns - list list of available offers
    */
    #[view]
    public fun get_available_offers(): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Return a list of not accepted offers
    }

    /*
        Returns a list of the offers that have dispute opened.
        @returns - list of offers with flag dispute_opened set to true
    */
    #[view]
    public fun get_arbitration_offers(): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Returns a list of the offers that have dispute opened
    }

    /*
        Returns a list of the provided creator's buy offers.
        @returns - list of the creator's offers with flag sell_apt set to false
    */
    #[view]
    public fun get_buy_offers(creator: address): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Returns a list of the provided creator's buy offers
    }

    /*
        Returns a list of the provided creator's sell offers.
        @returns - list of the creator's offers with flag sell_apt set to true
    */
    #[view]
    public fun get_sell_offers(creator: address): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Returns a list of the provided creator's sell offers
    }

    /*
        Returns offers associated with provided cretor
        @param creator - address of the creator
        @returns - list of offers associated with the provided creator
    */
    #[view]
    public fun get_creator_offers(creator: address): SimpleMap<u128, Offer> acquires State {
        // TODO: Call assert_state_initialized function

        // TODO: Filter the list of available offers and return only those that were created by the provided creator
    }

    /*
        Removes an entry from the list of the creator's offers
        @param creators_offers - list of the creators' offers
        @param creator - address of the creator
        @param offer_id - id of the offer to be removed
    */
    public(friend) inline fun remove_offer_from_creator_offers(
        creators_offers: &mut SimpleMap<address, vector<u128>>,
        creator: &address,
        offer_id: &u128
    ) {
        // TODO: Find and remove the provided offer_id from the provided creator's offers list
    }

    /*
        Returns next offer id and increments the counter by 1
        @param offer_id - offer id counter
        @returns - next offer id
    */
    public(friend) inline fun get_next_offer_id(offer_id: &mut u128): u128 {
        // TODO: Return a copy of offer_id and increment the original by one
    }

    /////////////
    // ASSERTS //
    /////////////

    inline fun assert_signer_is_admin(admin: &signer) {
        // TODO: Assert that the provided admin is the same as in Move.toml file
    }

    inline fun assert_state_initialized() {
        // TODO: Assert that State resource exists under the admin's address
    }

    inline fun assert_user_has_enough_funds<CoinType>(user: address, coin_amount: u64) {
        // TODO: Assert that the provided user's balance equals or is greater than the coin_amount
    }

    inline fun assert_offer_exists(
        offers: &SimpleMap<u128, Offer>,
        offer_id: &u128
    ) {
        // TODO: Assert that the offers contains the offer_id
    }

    inline fun assert_offer_not_accepted(offer: &Offer) {
        // TODO: Assert that the offer does not have counterparty value
    }

    inline fun assert_offer_accepted(offer: &Offer) {
        // TODO: Assert that the offer has counterparty value
    }

    inline fun assert_user_participates_in_transaction(user: address, offer: &Offer) {
        // TODO: Assert that the provided user's address is either the creator or the counterparty
    }

    inline fun assert_user_has_not_marked_completed_yet(user: address, offer: &Offer) {
        // TODO: Assert that the user has not marked the offer as completed yet (cover all cases)
    }

    inline fun assert_signer_is_creator(creator: &signer, offer: &Offer) {
        // TODO: Assert that the provided creator is the creator of the provided offer
    }

    inline fun assert_dispute_not_opened(offer: &Offer) {
        // TODO: Assert that a dispute is not opened
    }

    inline fun assert_dispute_opened(offer: &Offer) {
        // TODO: Assert that a dispute is opened
    }

    inline fun assert_singer_is_arbiter(arbiter: &signer, offer: &Offer) {
        // TODO: Assert that the provided signer is the arbiter of the provided offer
    }

    /////////////////////////
    // TEST-ONLY FUNCTIONS //
    /////////////////////////

    #[test_only]
    public(friend) fun state_exists(): bool {
        exists<State>(@admin)
    }

    #[test_only]
    public(friend) fun get_state_unpacked(): (
        SimpleMap<u128, Offer>,
        SimpleMap<address, vector<u128>>,
        u128,
        u64,
        u64,
        u64,
        u64,
        u64,
        u64,
        u64,
    ) acquires State {
        let state = borrow_global<State>(@admin);

        (
            state.offers,
            state.creators_offers,
            state.offer_id,
            event::counter(&state.create_offer_events),
            event::counter(&state.accept_offer_events),
            event::counter(&state.complete_transaction_events),
            event::counter(&state.release_funds_events),
            event::counter(&state.cancel_offer_events),
            event::counter(&state.open_dispute_events),
            event::counter(&state.resolve_dispute_events)
        )
    }

    #[test_only]
    public(friend) fun get_offer_unpacked(offer: Offer): (
        address,
        address,
        u64,
        u64,
        Option<address>,
        OfferCompletion,
        bool,
        bool
    ) {
        let Offer {
            creator,
            arbiter,
            apt_amount,
            usd_amount,
            counterparty,
            completion,
            dispute_opened,
            sell_apt
        } = offer;

        (
            creator,
            arbiter,
            apt_amount,
            usd_amount,
            counterparty,
            completion,
            dispute_opened,
            sell_apt
        )
    }

    #[test_only]
    public(friend) fun get_offer_completion_unpacked(offer_completion: OfferCompletion): (bool, bool) {
        let OfferCompletion { creator, counterparty } = offer_completion;

        (creator, counterparty)
    }

    #[test_only]
    public(friend) fun open_dispute_unchecked(offer_id: u128) acquires State {
        let state = borrow_global_mut<State>(@admin);
        simple_map::borrow_mut(&mut state.offers, &offer_id).dispute_opened = true;
    }
}
