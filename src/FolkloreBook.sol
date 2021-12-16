// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10;

import {Auth, Authority} from "solmate/auth/Auth.sol";
import {Bytes32AddressLib} from "solmate/utils/Bytes32AddressLib.sol";

import {HiddenScroll} from "./HiddenScroll.sol";
import {Masons} from "./Masons.sol";

/*///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

   ▄████████  ▄██████▄   ▄█          ▄█   ▄█▄  ▄█        ▄██████▄     ▄████████    ▄████████ 
  ███    ███ ███    ███ ███         ███ ▄███▀ ███       ███    ███   ███    ███   ███    ███ 
  ███    █▀  ███    ███ ███         ███▐██▀   ███       ███    ███   ███    ███   ███    █▀  
 ▄███▄▄▄     ███    ███ ███        ▄█████▀    ███       ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄     
▀▀███▀▀▀     ███    ███ ███       ▀▀█████▄    ███       ███    ███ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀     
  ███        ███    ███ ███         ███▐██▄   ███       ███    ███ ▀███████████   ███    █▄  
  ███        ███    ███ ███▌    ▄   ███ ▀███▄ ███▌    ▄ ███    ███   ███    ███   ███    ███ 
  ███         ▀██████▀  █████▄▄██   ███   ▀█▀ █████▄▄██  ▀██████▀    ███    ███   ██████████ 
                        ▀           ▀         ▀                      ███    ███              

                      ▀█████████▄   ▄██████▄   ▄██████▄     ▄█   ▄█▄ 
                        ███    ███ ███    ███ ███    ███   ███ ▄███▀ 
                        ███    ███ ███    ███ ███    ███   ███▐██▀   
                       ▄███▄▄▄██▀  ███    ███ ███    ███  ▄█████▀    
                       ▀▀███▀▀▀██▄  ███    ███ ███    ███ ▀▀█████▄    
                        ███    ██▄ ███    ███ ███    ███   ███▐██▄   
                        ███    ███ ███    ███ ███    ███   ███ ▀███▄ 
                      ▄█████████▀   ▀██████▀   ▀██████▀    ███   ▀█▀ 
                                                            ▀         

/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////*/

/// @title Folklore Book
/// @author abigger87
/// @notice The main book containing and creating lore
/// @dev ASCII Text generated with https://patorjk.com/software/taag/#p=display&f=Delta%20Corps%20Priest%201&t=Folklore
contract FolkloreBook is Auth {
    using Bytes32AddressLib for address;
    using Bytes32AddressLib for bytes32;

    /// @notice The Hidden Scrolls NFT Contract
    /// @dev The folkore rendered in the book
    HiddenScroll public immutable HIDDEN_SCROLLS;

    /// @notice The Masons NFT Contract
    /// @dev Masons are erc721s awarded for creating lore
    Masons public immutable MASONS;

    /// @dev The primary lore object
    struct Lore {
        address creator; // The Creator of the lore
        bool nsfw; // NSFW Flag
        bool included; // Was the Lore included in the book
        string metadata; // The encoded metadata uri
    }

    /// @notice Status of the contract
    /// @dev Only mutable by a give Authority
    /// @dev initializing wastes gas, coalesce default 0x0 to false
    bool public sessionStatus;

    /// @dev A lore vote requires the user to be an appraisooor
    /// @dev Eventually, we can require appraisooor | ABC hodler
    /// @dev Maps pricing session version to PricingSession
    // mapping(uint256 => PricingSession) public pricingSessions;

    /// @notice The current lore book page number
    uint256 public page;

    /// @notice Mapping from page number to the loreStore index
    mapping(uint256 => uint256) public book;

    /// @dev The current index of stored lore
    uint256 internal loreCount;

    /// @dev The number of lores submitted for the current session
    uint256 internal sessionLoreCount;

    /// @notice When the session ends
    uint256 public sessionEnd;

    /// @notice The length of a session
    uint256 public sessionLength;

    /// @dev maps a potential lore id to the lore Object
    mapping(uint256 => Lore) public loreStore;

    /// @dev Mapping from lore id to a mapping of potential lore
    /// @dev Example: to get first lore session's first submitted lore: loreStore[loreSession[0][0]]
    //      loreId             index      loreStore_index
    mapping(uint256 => mapping(uint256 => uint256)) internal loreSession;

    /// @dev Maps lore index to number of votes
    mapping(uint256 => uint256) internal votes;

    /// @dev maps page to user to their vote
    /// @dev will be 0 if they haven't voted
    mapping(uint256 => mapping(address => uint256)) userVote;

    /// @notice Creates a Folklore Book.
    /// @param _owner The owner of the book.
    /// @param _authority The Book Authority.
    /// @param _HIDDEN_SCROLLS The HiddenScrolls contract address
    /// @param _MASONS The Masons contract address
    constructor(
        address _owner,
        Authority _authority,
        address _HIDDEN_SCROLLS,
        address _MASONS
    ) Auth(_owner, _authority) {
        HIDDEN_SCROLLS = HiddenScroll(_HIDDEN_SCROLLS);
        MASONS = Masons(_MASONS);

        // Initialize loreCount to 1 since we leave 0 empty
        loreCount = 1;
    }

    /// @notice Emitted when new Folklore is submitted
    /// @param sender The address that submitted the lore
    event NewFolklore(address indexed sender, uint256 indexed loreId);

    /// @notice Submits new lore for the current session
    function submitLore(string memory metadata, bool nsfw) external {
        weigh();

        uint256 currentLore = loreCount;
        loreCount += 1;
        sessionLoreCount += 1;

        loreStore[currentLore] = Lore(msg.sender, nsfw, false, metadata);

        emit NewFolklore(msg.sender, currentLore);
    }

    /// @notice Emitted when a user votes
    /// @param sender The msg sender who submitted the vote
    /// @param loreId The id of the lore they voted for
    event VoteCasted(address indexed sender, uint256 indexed loreId);

    /// @notice Casts a user's vote
    /// @param loreId The id of the lore in the current session
    function vote(uint256 loreId) external inSessionBounds(loreId) uniqueVote {
        if(!weigh()) {
            votes[loreId] += 1;
            userVote[page+1][msg.sender] = loreId;
            emit VoteCasted(msg.sender, loreId);
        }
    }

    /// @notice Emitted when a user updates their vote
    /// @param sender The msg sender who submitted the vote
    /// @param oldLoreId The id of the lore they previously voted for
    /// @param newLoreId The id of the lore they now voted for
    event VoteUpdated(address indexed sender, uint256 indexed oldLoreId, uint256 indexed newLoreId);

    /// @notice Updates a user's vote
    /// @param loreId The id of the lore in the current session
    function updateVote(uint256 loreId) external inSessionBounds(loreId) {
        uint256 oldVote = userVote[page+1][msg.sender];
        if (oldVote != 0) {
            votes[oldVote] -= 1;
        }
        votes[loreId] += 1;
        userVote[page+1][msg.sender] = loreId;
        emit VoteUpdated(msg.sender, oldVote, loreId);
    }

    /// @notice Emitted when lore inked
    /// @param sender The msg sender who inked the lore
    /// @param loreId The id of the inked lore
    event LoreInked(address indexed sender, uint256 indexed loreId);

    /// @notice Weighs and inks lore
    /// @return If the lore was inked
    function weigh() public returns(bool) {
        if(block.timestamp > sessionEnd) {
            uint256 winningLore = loreSession[page+1][0];
            for(uint256 i = 1; i <= sessionLoreCount; i++) {
                if(votes[loreSession[page+1][i]] > votes[winningLore]) {
                    winningLore = loreSession[page+1][i];
                }
            }

            book[page+1] = winningLore; // Set the book page
            sessionLoreCount = 0;       // Reset the session
            page += 1;                  // Next page

            // Set the new session end
            sessionEnd = block.timestamp + sessionLength;
            emit LoreInked(msg.sender, winningLore);
            return true;
        }
        return false;
    }

    // TODO: we can have lore inked permissionlessly by recording the block.timestamp
    // TODO: if block.timestamp > sessionEnd for any function call, weigh()

    ///////////////////////////////////////////////
    //              ACCESSIBILITY                //
    ///////////////////////////////////////////////

    /// @notice Gets the Lore Ids for 
    /// @param session The session number
    function getLoreIds(uint256 session) external view validSession(session) returns(uint256[] memory ids) {
        for(uint256 i = 0; i < sessionLoreCount; i++) {
            ids[i] = loreSession[session][i];
        }
    }


    ///////////////////////////////////////////////
    //                ADMIN ZONE                 //
    ///////////////////////////////////////////////

    /// @notice Emitted when the session status is changed
    /// @param sender The Authorized user changing the session status
    /// @param status The new Session Status
    event SessionStatusUpdated(address indexed sender, bool status);

    /// @notice Flips the session status
    /// @return sessionStatus as a boolean
    function setSessionStatus() external requiresAuth returns (bool) {
        // TODO: this doesn't need 8 bits, let's just use 1
        sessionStatus = !sessionStatus;
        emit SessionStatusUpdated(msg.sender, sessionStatus);
        return sessionStatus;
    }

    /// @notice Emitted when the session length is changed
    /// @param sender The Authorized user changing the session length
    /// @param length The new Session Length
    event SessionLengthUpdated(address indexed sender, uint256 length);

    /// @notice Sets the session length
    /// @param newSessionLength The new session length
    function setSessionStatus(uint256 newSessionLength) external requiresAuth {
        sessionLength = newSessionLength;
        emit SessionLengthUpdated(msg.sender, sessionLength);
    }

    ///////////////////////////////////////////////
    //                 MODIFIERS                 //
    ///////////////////////////////////////////////

    modifier inSessionBounds(uint256 id) {
        uint256 lower_bounds = loreSession[page+1][0];
        uint256 upper_bounds = loreSession[page+1][sessionLoreCount];
        require(id >= lower_bounds, "INVALID_ID");
        require(id <= upper_bounds, "INVALID_ID");
        _;
    }

    modifier uniqueVote {
        require(!(userVote[page+1][msg.sender] > 0), "ALREADY_VOTED");
        _;
    }

    modifier validSession(uint256 session) {
        require(session <= page+1 && session >= 0, "INVALID_SESSION");
        _;
    }
}
