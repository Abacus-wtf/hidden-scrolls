// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "../HiddenScroll.sol";

contract HiddenScrollTest is DSTest {
    HiddenScroll scrolls;

    function setUp() public {
        scrolls = new HiddenScroll();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
