// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/* 
Building out the minting functions
    a. NFT needs to point to a specific address
    b. keep track of the NFTs IDs
    c. keep track of owner Address to NFTs IDs
    d. keep track of how many tokens an address has
    e. emit some transfer logs to see where it is minted and ID
*/

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Mapping the token ID to the address owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of token owned
    mapping(address => uint256) private _ownedTokensCount;

    function exists(uint256 tokenId) internal view returns(bool) {
        // checking who is the owner of the tokenID
        address owner = _tokenOwner[tokenId];
        // check that the owner is not address of 0
        return owner != address(0); 
    }

    function _mint (address to, uint256 tokenId) internal {
        //require that the address is not an invalid one
        require(to != address(0), "ERC721 needs to mint to a real address");
        //require that the token ID has not been minted already, so the NFT token does not need to have an owner
        require(!exists(tokenId), "ERC721 token has already been minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;
    }
}