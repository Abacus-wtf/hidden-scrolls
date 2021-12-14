// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "../Lords.sol";

contract LordsTest is DSTest {
    Lords lords;

    function setUp() public {
        lords = new Lords();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
