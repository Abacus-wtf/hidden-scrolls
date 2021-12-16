// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10;

import {ERC721} from "zeppelin-solidity/token/ERC721/ERC721.sol";

/// @title MintAuthority
/// @author Andreas Bigger (https://github.com/abigger87)
/// @dev Specifies the address able to mint
abstract contract MintAuthority {
  /// @dev The address permitted to perform mints
  address internal mintAuthority;

  /// @dev The contract owner who can change the MINT_AUTHORITY
  address internal immutable OWNER;

  constructor() {
    OWNER = msg.sender;
  }
  /// @notice Sets the MINT_AUTHORITY
  /// @param newMintAuthority The address of the new mint authority
  function set_mint_authority(address newMintAuthority) external onlyOwner {
    mintAuthority = newMintAuthority;
  }

    ///////////////////////////////////////////////
    //                 Modifiers                 //
    ///////////////////////////////////////////////

    modifier onlyOwner() {
      require(msg.sender == OWNER, "UNAUTHORIZED_OWNER");
      _;
    }

    modifier onlyMintAuthority() {
      require(msg.sender == mintAuthority, "UNAUTHORIZED_MINT_AUTHORITY");
      _;
    }
}