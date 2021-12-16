// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import {Masons} from "../Masons.sol";

contract MasonsTest is DSTest {
    Masons masons;

    function setUp() public {
        masons = new Masons(address(this));
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
