// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

   ▄█    █▄     ▄█  ████████▄  ████████▄     ▄████████ ███▄▄▄▄   
  ███    ███   ███  ███   ▀███ ███   ▀███   ███    ███ ███▀▀▀██▄ 
  ███    ███   ███▌ ███    ███ ███    ███   ███    █▀  ███   ███ 
 ▄███▄▄▄▄███▄▄ ███▌ ███    ███ ███    ███  ▄███▄▄▄     ███   ███ 
▀▀███▀▀▀▀███▀  ███▌ ███    ███ ███    ███ ▀▀███▀▀▀     ███   ███ 
  ███    ███   ███  ███    ███ ███    ███   ███    █▄  ███   ███ 
  ███    ███   ███  ███   ▄███ ███   ▄███   ███    ███ ███   ███ 
  ███    █▀    █▀   ████████▀  ████████▀    ██████████  ▀█   █▀  

   ▄████████  ▄████████    ▄████████  ▄██████▄   ▄█        ▄█       
  ███    ███ ███    ███   ███    ███ ███    ███ ███       ███       
  ███    █▀  ███    █▀    ███    ███ ███    ███ ███       ███       
  ███        ███         ▄███▄▄▄▄██▀ ███    ███ ███       ███       
▀███████████ ███        ▀▀███▀▀▀▀▀   ███    ███ ███       ███       
         ███ ███    █▄  ▀███████████ ███    ███ ███       ███       
   ▄█    ███ ███    ███   ███    ███ ███    ███ ███▌    ▄ ███▌    ▄ 
 ▄████████▀  ████████▀    ███    ███  ▀██████▀  █████▄▄██ █████▄▄██ 
                          ███    ███            ▀         ▀       

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

// NFT contract to inherit from.
/// @dev Waiting for solmate ERC721 impl
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title HiddenScroll
/// @author abigger87
/// @dev This contract is a folklore instance deployed by the [FolkloreBook](./FolkloreBook.sol) contract.
/// @dev ASCII Text generated with https://patorjk.com/software/taag/#p=display&f=Delta%20Corps%20Priest%201&t=Scroll
contract HiddenScroll is ERC721("") {

  
  /// @notice Mints the Hidden Scroll
  /// @param _index The token index to mint
  function mint(uint256 _index) external payable {
    // CHECKS
    healBoss(); // Try and heal boss first
    require(msg.value >= price + developmentFee, "PRICE_NOT_MET");
    require(_characterIndex < defaultCharacters.length, "CHARACTER_NON_EXISTANT");

    // Get current tokenId (starts at 1 since we incremented in the constructor).
    uint256 newItemId = _tokenIds.current();

    // The magical function! Assigns the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    // Try to send fee to developooor
    payable(developer).call{value: developmentFee}("");

    // We map the tokenId => their character attributes. More on this in
    // the lesson below.
    nftHolderAttributes[newItemId] = CharacterAttributes({
        characterIndex: _characterIndex,
        name: defaultCharacters[_characterIndex].name,
        imageURI: defaultCharacters[_characterIndex].imageURI,
        hp: defaultCharacters[_characterIndex].hp,
        maxHp: defaultCharacters[_characterIndex].hp,
        attackDamage: defaultCharacters[_characterIndex].attackDamage
    });

    // Keep an easy way to see who owns what NFT.
    loreHolders[msg.sender] = newItemId;

    // Increment the tokenId for the next person that uses it.
    _tokenIds.increment();

    emit CharacterNFTMinted(newItemId, msg.sender, _characterIndex);
  }
}
