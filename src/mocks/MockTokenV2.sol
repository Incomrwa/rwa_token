// SPDX-License-Identifier: MIT
// FOR TESTING PURPOSES ONLY. DO NOT USE IN PRODUCTION.
pragma solidity ^0.8.20;

import "../Token.sol";

/// @custom:oz-upgrades-from Token
contract MockTokenV2 is Token {
    constructor(string memory name_, string memory symbol_, uint256 initialSupply_)
        Token(name_, symbol_, initialSupply_)
    {}

    function version() public pure override returns (string memory) {
        return "2.0.0";
    }
}
