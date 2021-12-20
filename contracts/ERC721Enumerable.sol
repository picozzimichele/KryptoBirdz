// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from tokenID index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    //function tokenByIndex(uint256 _index) external view returns (uint256);

    //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        // add tokents to the owner
        // all tokens to our total supply

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);

    }

    // add tokens to the _alltokens array and set the position of the tokenId
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        //we want to put the position of the tokenId, basically we take the length and that is the postion of the tokenId
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);

    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        // add address and token id to the _ownedTokens
        _ownedTokens[to].push(tokenId);
    }

    //returns tokenByIndex
    function tokenByIndex(uint256 index) public view returns(uint256) {
        require(index < totalSupply(), "global index is out of bound!");
        return _allTokens[index];
    }

    //returns tokenOfOwnerByIndex
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns(uint256) {
        require(index < balanceOf(owner), "owner index is out of bound!");
        return _ownedTokens[owner][index];
    }

    //return total supply of the _allTokens array
    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }
}