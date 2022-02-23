// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './Interfaces/IERC721.sol';
import './ERC165.sol';

/* 
Building out the minting functions
    a. NFT needs to point to a specific address
    b. keep track of the NFTs IDs
    c. keep track of owner Address to NFTs IDs
    d. keep track of how many tokens an address has
    e. emit some transfer logs to see where it is minted and ID
*/

contract ERC721 is ERC165, IERC721 {

    // Mapping the token ID to the address owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of token owned
    mapping(address => uint256) private _ownedTokensCount;

    // Mapping from owner to number of token owned
    mapping(uint256 => address) private _tokenApprovals;


    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }
   
    function balanceOf(address _owner) public override view returns (uint256) {
        require(_owner != address(0), "Owner query for non-existent token");
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner =  _tokenOwner[_tokenId];
        require(owner != address(0), "Owner should not be 0");
        return owner;
    }

    function exists(uint256 tokenId) internal view returns(bool) {
        // checking who is the owner of the tokenID
        address owner = _tokenOwner[tokenId];
        // check that the owner is not address of 0
        return owner != address(0); 
    }

    function _mint (address to, uint256 tokenId) internal virtual {
        //require that the address is not an invalid one
        require(to != address(0), "ERC721 needs to mint to a real address");
        //require that the token ID has not been minted already, so the NFT token does not need to have an owner
        require(!exists(tokenId), "ERC721 token has already been minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), "Error - ERC721 Transfer to the zero address");
        require(ownerOf(_tokenId) == _from, "Tying to transfer a token the address does not own");

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    //require that the person approving is the owner
    //approve an address to a token (tokenId)
    //require that we cant approve sending tokens of the owner to the owner (current caller)
    //update the map of the approval addresses
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "Current caller is not the owner of the token");
        require(_to != owner, "Tying to transfer the owner to itself");
        require(_to != address(0), "Error - ERC721 Transfer to the zero address");
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
        
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(exists(tokenId), "Token does not exists");
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
}