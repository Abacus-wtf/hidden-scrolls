// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "../FolkloreBook.sol";

contract FolkloreBookTest is DSTest {
    FolkloreBook book;

    function setUp() public {
        book = new FolkloreBook();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
