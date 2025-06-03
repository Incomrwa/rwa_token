# Clean and build the project
build:
    forge clean && forge build

# Clean and run tests with verbose output
test:
    forge clean && forge test -vv

# Clean and deploy the token contract locally. Must be running a local node (e.g anvil)
deploy_token_localhost:
    forge clean && forge script --chain 31337 script/Token.s.sol:Deploy --rpc-url http://127.0.0.1:8545 --broadcast -vvvv

deploy_token_eth_testnet:
    forge clean && forge script script/Token.s.sol:Deploy --rpc-url https://eth-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX --broadcast -vvvv --verify --etherscan-api-key GBHXSSKBDX7GENFSUGA9K63AYHH6SW8V3X --verifier-url https://api-sepolia.etherscan.io/api --slow

deploy_token_base_testnet:
    forge clean && forge script script/Token.s.sol:Deploy --rpc-url https://base-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX --broadcast -vvvv --verify --etherscan-api-key 5IWSKE84XJQ1M3V3TAS4S25N7U4TJDECZX --verifier-url https://api-sepolia.basescan.org/api --slow

deploy_token_amoy_testnet:
    forge clean && forge script --chain 80002 script/Token.s.sol:Deploy --rpc-url https://rpc-amoy.polygon.technology -vvvv --broadcast --verify --etherscan-api-key DTTZGII2YP5N3HRA7NUGR6Z5U31672N5MM --verifier-url https://api-amoy.polygonscan.com/api --slow

upgrade_token_localhost:
    forge clean && forge script --chain 31337 script/Token.s.sol:Upgrade --rpc-url http://127.0.0.1:8545 --broadcast -vvvv

update_token_proxy_owner:
    forge clean && forge script --chain 31337 script/Token.s.sol:TransferOwner --rpc-url http://127.0.0.1:8545 --broadcast -vvvv
    
deploy_vesting_localhost:
    forge clean && forge script --chain 31337 script/Vesting.s.sol:Deploy --rpc-url http://127.0.0.1:8545 --broadcast -vvvv

deploy_vesting_base_testnet:
    forge clean && forge script script/Vesting.s.sol:Deploy --rpc-url https://base-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX -vvvv --broadcast --verify --etherscan-api-key 5IWSKE84XJQ1M3V3TAS4S25N7U4TJDECZX --verifier-url https://api-sepolia.basescan.org/api --slow

deploy_multivesting_base_testnet:
    forge clean && forge script script/VestingMultiDeploy.s.sol:Deploy --rpc-url https://base-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX -vvvv --broadcast --verify --etherscan-api-key 5IWSKE84XJQ1M3V3TAS4S25N7U4TJDECZX --verifier-url https://api-sepolia.basescan.org/api --slow

deploy_distribute_base_testnet:
    forge clean && forge script script/Distribution.s.sol:Distribution --rpc-url https://base-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX -vvvv --broadcast 

deploy_base_l2_testnet:
    forge clean && forge script script/DeployAndBridge.s.sol:DeployL2 --rpc-url https://base-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX --broadcast -vvvv

bridge_to_base_testnet:
    forge clean && forge script script/DeployAndBridge.s.sol:BridgeToBase --rpc-url https://eth-sepolia.g.alchemy.com/v2/mn7sXmCev6Z_xIAM7qzuN2S2rUKcDpzX --broadcast -vvvv
