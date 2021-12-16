// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import {Auth, Authority} from "solmate/auth/Auth.sol";
import {FolkloreBook} from "../FolkloreBook.sol";
import {HiddenScroll} from "../HiddenScroll.sol";
import {Masons} from "../Masons.sol";

contract FolkloreBookTest is DSTest {
    FolkloreBook book;
    HiddenScroll scroll;
    Masons masons;

    function setUp() public {
        scroll = new HiddenScroll(address(this));

        masons = new Masons(address(this));

        book = new FolkloreBook(
            address(this),          // _owner
            Authority(address(0)),  // _authority
            address(scroll),        // _HIDDEN_SCROLLS
            address(masons)         // _MASONS
        );
    }

    function testInitialization() public {
        assertEq(address(book.HIDDEN_SCROLLS()), address(scroll));
        assertEq(address(book.MASONS()), address(masons));
        assertEq(book.page(), 0);
    }

    function testSubmitLore(string memory _metadata, bool _nsfw) public {
        book.submitLore(_metadata, _nsfw);

        FolkloreBook.Lore memory newLore = FolkloreBook.Lore(address(this), _nsfw, false, _metadata);
        
        (address creator, bool nsfw, bool included, string memory metadata) = book.loreStore(0);
        assertEq(creator, address(this));
        assertEq(nsfw, _nsfw);
        assertEq(included, false);
        assertEq(metadata, _metadata);
    }


}
