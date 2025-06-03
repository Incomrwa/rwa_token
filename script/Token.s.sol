// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract Deploy is Script {
    Token public token;
    string public constant NAME = "INCOM Testnet token";
    string public constant SYMBOL = "INCOM_TN";
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 ether;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        token = new Token(NAME, SYMBOL, INITIAL_SUPPLY);

        console2.log("Token deployed at:", address(token));
        console2.log("Token version:", token.version());
        console2.log("Token totalSupply:", token.totalSupply());
        console2.log("Token name:", token.name());
        console2.log("Token symbol:", token.symbol());

        vm.stopBroadcast();
    }
}
