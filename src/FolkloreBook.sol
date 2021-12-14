// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {Auth} from "solmate/Auth.sol";
import {Bytes32AddressLib} from "solmate/utils/Bytes32AddressLib.sol";

import {HiddenScroll} from "./HiddenScroll.sol";
import {Lords} from "./Lords.sol";

/// @title Folklore Book
/// @author abigger87
/// @notice The main book containing and creating lore
contract FolkloreBook is Auth {
    using Bytes32AddressLib for address;
    using Bytes32AddressLib for bytes32;

    /// @notice The Hidden Scrolls NFT Contract
    /// @dev The folkore rendered in the book
    HiddenScroll public immutable HIDDEN_SCROLLS;

    /// @notice The Lords NFT Contract
    /// @dev Lords are erc721s awarded for creating lore
    Lords public immutable LORDS;

    /// @dev The primary lore object
    struct Lore {
        address creator; // The Creator of the lore
        bool nsfw; // NSFW Flag
        bool included; // Was the Lore included in the book
        string loreMetadataURI; // The encoded metadata uri
    }

    /// @notice Status of the contract
    /// @dev Only mutable by a give Authority
    /// @dev initializing wastes gas, coalesce default 0x0 to false
    bool public sessionStatus;

    /// @dev A lore vote requires the user to be an appraisooor
    /// @dev Eventually, we can require appraisooor | ABC hodler
    /// @dev Maps pricing session version to PricingSession
    mapping(uint256 => PricingSession) public pricingSessions;

    /// @notice The current lore book page number
    uint256 public page;

    /// @notice Mapping from page number to the loreStore index
    mapping(uint256 => uint256) public book;

    /// @dev The current index of stored lore
    uint256 internal loreCount;

    /// @dev maps a potential lore id to the lore Object
    mapping(uint256 => Lore) internal loreStore;

    /// @dev Mapping from lore id to a mapping of potential lore
    /// @dev Example: to get first lore session's first submitted lore: loreStore[loreSession[0][0]]
    //      loreId             index      loreStore_index
    mapping(uint256 => mapping(uint256 => uint256)) internal loreSession;

    /// @dev Maps lore to user to their vote
    mapping(uint256 => mapping(address => uint256)) internal userVotes;

    /// @notice Creates a Folklore Book.
    /// @param _owner The owner of the book.
    /// @param _authority The Book Authority.
    /// @param _HIDDEN_SCROLLS The HiddenScrolls contract address
    /// @param _LORDS The Lords contract address
    constructor(
        address _owner,
        Authority _authority,
        address _HIDDEN_SCROLLS,
        address _LORDS
    ) Auth(_owner, _authority) {
        HIDDEN_SCROLLS = HiddenScroll(_HIDDEN_SCROLLS);
        LORDS = Lords(_LORDS);
    }

    /// @notice Emitted when new Folklore is submitted
    /// @param sender The address that submitted the lore
    event NewFolklore(address indexed sender, uint256 indexed loreId);

    /// @notice Submits new lore for the current session
    function submitLore(string metadata, bool nsfw) external {
        // TODO: make sure the session is active (it will always be - we immediately roll over)

        uint256 currentLore = loreCount;
        loreCount += 1;

        // Create the new lore
        loreStore[currentLore] = Lore(msg.sender, nsfw, false, metadata);

        emit NewFolklore(msg.sender, currentLore);
    }

    // TODO: set vote

    // TODO: update vote

    ///////////////////////////////////////////////
    //                ADMIN ZONE                 //
    ///////////////////////////////////////////////

    /// @notice Emitted when the session status is changed
    /// @param sender The Authorized user changing the session status
    /// @param status The new Session Status
    event SessionStatusUpdate(address indexed sender, bool status);

    /// @notice Flips the session status
    /// @return sessionStatus as a boolean
    function setSessionStatus() external requiresAuth returns (bool) {
        // TODO: this doesn't need 8 bits, let's just use 1
        sessionStatus = !sessionStatus;
        return sessionStatus;
    }
}
