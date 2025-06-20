// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Token.sol";

// Interface to create standard L2 tokens
interface IL2StandardTokenFactory {
    function createStandardL2Token(
        address l1Token,
        string calldata name,
        string calldata symbol
    ) external returns (address);
}

// Interface to deposit L1 tokens to L2
interface IL1StandardBridge {
    function depositERC20To(
        address l1Token,
        address l2Token,
        address to,
        uint256 amount,
        uint32 l2Gas,
        bytes calldata data
    ) external;
}

// Deploys a new L2 token mapped to the L1 token
// forge clean && forge script script/DeployAndBridge.s.sol:DeployL2 --rpc-url $BASE_PSEPOLIA_RPC --broadcast -vvvvv
contract DeployL2 is Script {
    string public constant NAME = "IncomRWA";
    string public constant SYMBOL = "iRWA";

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address l1Token = vm.envAddress("L1_TOKEN");
        address l2StandardTokenFactoryAddress = vm.envAddress("L2_STANDARD_FACTORY");


        vm.startBroadcast(deployerPrivateKey);

        IL2StandardTokenFactory factory = IL2StandardTokenFactory(l2StandardTokenFactoryAddress);
        address l2Token = factory.createStandardL2Token(l1Token, NAME, SYMBOL);

        console2.log("L2 token deployed at:", l2Token);

        vm.stopBroadcast();
    }
}

// Bridges tokens from L1 to L2
//forge clean && forge script script/DeployAndBridge.s.sol:BridgeToBase --rpc-url $BASE_PSEPOLIA_RPC --broadcast -vvvvv
contract BridgeToBase is Script {

    function run() external {
        address l1StandardBridgeAddress = vm.envAddress("L1_STANDARD_BRIDGE");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address l1Token = vm.envAddress("L1_TOKEN");
        address l2Token = vm.envAddress("L2_TOKEN");
        uint256 bridgeAmount = vm.envUint("TOKEN_AMOUNT"); // Already in wei

        vm.startBroadcast(deployerPrivateKey);

        // Approve bridge contract to transfer tokens
        Token token = Token(l1Token);
        token.approve(l1StandardBridgeAddress, bridgeAmount);

        // Bridge tokens
        IL1StandardBridge bridge = IL1StandardBridge(l1StandardBridgeAddress);
        bridge.depositERC20To(
            l1Token,
            l2Token,
            vm.addr(deployerPrivateKey),
            bridgeAmount,
            100_000, // l2Gas
            ""       // calldata
        );

        console2.log("Bridged", bridgeAmount, "tokens to L2");

        vm.stopBroadcast();
    }
}
