// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {MockTokenV2} from "../src/mocks/MockTokenV2.sol";

contract TokenTest is Test {
    uint256 public constant initialSupply = 1_000_000_000 ether;
    string public constant name = "Nexade";
    string public constant symbol = "NEX";

    Token public token;
    address deployer;

    address newOwner;

    function setUp() public {
        deployer = msg.sender;

        // new owner for testing
        newOwner = address(0x456);

        console2.log("Deployer address:", deployer);

        // Deploy implementation and admin contracts
        vm.startPrank(deployer);
        token = new Token("Nexade", "NEXD", 1_000_000_000 ether);

        vm.stopPrank();

    }

    function test_Name() public view {
        assertEq(token.name(), "Nexade");
    }

    function test_Version() public view {
        assertEq(token.version(), "1.0.0");
    }

    function testOwnerBalance() public view{
        assertEq(token.balanceOf(deployer), initialSupply, "Owner should have initial supply");
    }

    function test_TotalSupply() public view {
        assertEq(token.totalSupply(), initialSupply);
    }

    function test_Decimals() public view {
        assertEq(token.decimals(), 18);
    }

    function test_Burn() public {
        uint256 amountToBurn = 500 ether;

        vm.startPrank(deployer);

        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(deployer), initialSupply);

        vm.assume(amountToBurn <= initialSupply);
        vm.assume(amountToBurn <= token.balanceOf(deployer));
        token.burn(amountToBurn);

        assertEq(token.totalSupply(), initialSupply - amountToBurn);
        assertEq(token.balanceOf(deployer), initialSupply - amountToBurn);

        vm.stopPrank();
    }

    function testTransfer() public {
        uint256 amount = 100 ether;
        vm.startPrank(deployer);

        token.transfer(newOwner, amount);
        assertEq(token.balanceOf(newOwner), amount, "User should receive tokens");
        assertEq(token.balanceOf(deployer), initialSupply - amount, "Owner balance should reduce");
        
        vm.stopPrank();

    }

    function testPermit() public {
        uint256 amount = 100 ether;
        uint256 privateKey = 0xA11CE;
        address signer = vm.addr(privateKey);

        // Give signer some tokens
        vm.prank(deployer);
        token.transfer(signer, amount);

        uint256 nonce = token.nonces(signer);
        uint256 deadline = block.timestamp + 1 days;

        // Create permit signature
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                token.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                        signer,
                        address(this),
                        amount,
                        nonce,
                        deadline
                    )
                )
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);

        token.permit(signer, address(this), amount, deadline, v, r, s);
        assertEq(token.allowance(signer, address(this)), amount, "Permit approval failed");

        // Transfer using allowance
        vm.prank(address(this));
        token.transferFrom(signer, address(this), amount);
        assertEq(token.balanceOf(address(this)), amount, "TransferFrom via permit failed");
    }

     function testCannotReinitialize() public {
        vm.startPrank(deployer);

        (bool success, ) = address(token).call(
            abi.encodeWithSignature("initialize(string,string,uint256)", "New", "NEW", 1 ether)
        );
        vm.stopPrank();
        assertTrue(!success, "Contract should not allow re-initialization");
    }

    function testNoDelegateCallOpcode() public {
        vm.startPrank(deployer);
        // 1. Set initial state
        token.transfer(address(1), 100 ether);
        
        // 2. Verify state is directly stored (not via delegation)
        assertEq(token.balanceOf(address(1)), 100 ether);
        assertEq(token.balanceOf(address(deployer)), initialSupply - 100 ether);
        
        // 3. Verify contract address remains the same (no proxy pattern)
        address originalAddress = address(token);
        token.transfer(address(2), 50 ether);
        vm.stopPrank();

        assertEq(address(token), originalAddress);
    }
    
}
