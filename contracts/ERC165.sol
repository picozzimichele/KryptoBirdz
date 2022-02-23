// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './Interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() {
        _registerInterface(bytes4(keccak256('supportsIntersface(bytes4)')));
    }
    function supportsInterface(bytes4 interfaceID) external view override returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, 'Invalid interface Request');
        _supportedInterfaces[interfaceId] = true;
    }
}