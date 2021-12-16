// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

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
        assertEq(book.HIDDEN_SCROLLS, scroll);
        assertEq(book.MASONS, masons);
        assertEq(book.page, 0);
    }


}
