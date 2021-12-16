// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import {Auth, Authority} from "solmate/auth/Auth.sol";
import {FolkloreBook} from "../FolkloreBook.sol";
import {HiddenScroll} from "../HiddenScroll.sol";
import {Masons} from "../Masons.sol";

import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";

contract FolkloreBookTest is DSTestPlus {
    FolkloreBook book;
    HiddenScroll scroll;
    Masons masons;
    uint256 sessionLength = 2 days;

    function setUp() public {
        scroll = new HiddenScroll(address(this));

        masons = new Masons(address(this));

        book = new FolkloreBook(
            sessionLength,          // _sessionLength
            address(this),          // _owner
            Authority(address(0)),  // _authority
            address(scroll),        // _HIDDEN_SCROLLS
            address(masons)         // _MASONS
        );

        // Update the Masons and HiddenScroll mint authorities
        scroll.set_mint_authority(address(book));
        masons.set_mint_authority(address(book));
    }

    function testInitialization() public {
        assertEq(address(book.HIDDEN_SCROLLS()), address(scroll));
        assertEq(address(book.MASONS()), address(masons));
        assertEq(book.page(), 0);
    }

    function testSubmitLore(string memory _metadata, bool _nsfw) public {
        book.submitLore(_metadata, _nsfw);

        // FolkloreBook.Lore memory newLore = FolkloreBook.Lore(address(this), _nsfw, false, _metadata);
        
        (address creator, bool nsfw, bool included, string memory metadata) = book.loreStore(1);
        assertEq(creator, address(this));
        assertTrue(nsfw == _nsfw);
        assertTrue(included == false);
        assertEq(metadata, _metadata);
    }

    ///////////////////////////////////////////////
    //                   VOTING                  //
    ///////////////////////////////////////////////

    function testBasicVote() public {
        book.submitLore("", false);
        book.vote(1);
    }

    function testMultipleLoreSubmissions() public {
        book.submitLore("", false);
        book.submitLore("", false);
        book.submitLore("", false);
        book.vote(3);
    }

    function testFailVoteBelowBounds() public {
        book.submitLore("", false);
        book.vote(0);
    }

    function testFailVoteAboveBounds() public {
        book.submitLore("", false);
        book.vote(2);
    }

    function testFailDoubleVote() public {
        book.submitLore("", false);
        book.vote(1);
        book.vote(1);
    }

    function testFailVoteWithoutLore() public {
        book.updateVote(1);
    }

    ///////////////////////////////////////////////
    //               VOTE UPDATES                //
    ///////////////////////////////////////////////

    function testMultipleVoteUpdates() public {
        book.submitLore("", false);
        book.vote(1);
        book.submitLore("", false);
        book.updateVote(2);
        book.updateVote(1);
        book.submitLore("", false);
        book.updateVote(3);
        book.updateVote(1);
    }

    function testIdenticalVoteUpdate() public {
        book.submitLore("", false);
        book.vote(1);
        book.submitLore("", false);
        book.updateVote(2);
        book.updateVote(2);
    }

    function testFailUpdateVoteBelowBounds() public {
        book.submitLore("", false);
        book.vote(1);
        book.updateVote(0);
    }

    function testFailUpdateVoteAboveBounds() public {
        book.submitLore("", false);
        book.vote(1);
        book.updateVote(2);
    }

    function testCanVoteUsingUpdateVote() public {
        book.submitLore("", false);
        book.updateVote(1);
    }

    function testFailUpdateVoteWithoutLore() public {
        book.updateVote(1);
    }

    ///////////////////////////////////////////////
    //                 WEIGHING                  //
    ///////////////////////////////////////////////

    function testWeighWithoutSession() public {
        assertTrue(!book.weigh());
    }

    function testWeighWithSession() public {
        book.submitLore("", false);
        book.setSessionLength(uint256(2 days));
        assertTrue(!book.weigh());
        hevm.warp(block.timestamp + 1 days);
        assertTrue(!book.weigh());
        hevm.warp(block.timestamp + 3 days);
        assertTrue(book.weigh());
    }


    ///////////////////////////////////////////////
    //             ADMIN FUNCTIONS               //
    ///////////////////////////////////////////////

    function testSetSessionStatus() public {
        book.setSessionStatus();
        assertTrue(book.sessionStatus());
        book.setSessionStatus();
        assertTrue(!book.sessionStatus());
        book.setSessionStatus();
        assertTrue(book.sessionStatus());
    }

    function testSetSessionLength() public {
        book.setSessionLength(uint256(2 days));
        assertEq(book.sessionLength(), uint256(2 days));
        book.setSessionLength(uint256(3 days));
        assertEq(book.sessionLength(), uint256(3 days));
    }

    ///////////////////////////////////////////////
    //          IERC721Receiver Support          //
    ///////////////////////////////////////////////

    event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public returns (bytes4) {
        emit Received(operator, from, tokenId, data, gasleft());
        // Magic value that must be emitted on successful receiving
        // `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
        return 0x150b7a02;
    }
}
