// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

/// @title HiddenScroll
/// @author abigger87
/// @dev This contract is a folklore instance deployed by the [FolkloreBook](./FolkloreBook.sol) contract.
contract HiddenScroll {
  bytes32 public immutable SCROLL_NAME;

  constructor(bytes32 _SCROLL_NAME) {
    SCROLL_NAME = _SCROLL_NAME;
  }
}
