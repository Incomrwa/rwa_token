// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract Distribution is Script {
    function run() public {
        Token NEXD = Token(vm.envAddress("NEXD_TOKEN_ADDRESS"));
        string memory inputFile = vm.readFile("./script/files/distributionConfig.csv");
        string[] memory inputLines = vm.split(inputFile, "\r\n");

        console2.log("Sender Address:", vm.addr(vm.envUint("PRIVATE_KEY")));
        console2.log("Sender Balance  :", NEXD.balanceOf(vm.addr(vm.envUint("PRIVATE_KEY"))));

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        for (uint256 i = 0; i < inputLines.length; i++) {
            string[] memory fields = vm.split(inputLines[i], ",");
            address payable vestingWallet = payable(vm.parseAddress(fields[0]));
            require(NEXD.transfer(vestingWallet, vm.parseUint(fields[1])), "Transfer failed");
        }
    }
}
