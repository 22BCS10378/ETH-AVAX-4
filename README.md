Degen Project: Ethereum-AVAX Token Smart Contract
Overview
This Solidity-based program demonstrates the creation and management of an ERC20 token named "Degen" (symbol: "DGN"). The smart contract provides various functionalities, such as minting, transferring, and redeeming tokens for in-game items. The deployed contract's transactions can be monitored using the "Snowtrace Testnet" tool by tracking the contract's address.

Description
The smart contract is developed in Solidity, a language specifically designed for creating smart contracts on blockchain networks such as Ethereum. The token is named "Degen," but users have the flexibility to customize the token's name and symbol as per their requirements.

Getting Started
Execution Instructions
You can utilize Remix, an online IDE for Solidity, to execute this smart contract. Here's how to get started:

Access Remix: Visit Remix IDE.
Create a New File: In the left sidebar, click on the "+" icon to create a new file. Save the file with a .sol extension, such as DegenToken.sol.
Copy and Paste the Code: Copy the provided Solidity code and paste it into your newly created file.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    mapping(address => mapping(uint256 => uint256)) public itemsOwned; // Mapping of user to item ID to quantity
    mapping(uint256 => string) public itemNames;  // Mapping of item ID to item name
    mapping(uint256 => uint256) public itemCosts;  // Mapping of item ID to item cost
    uint256 public itemIdCounter;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        itemIdCounter = 0;
        // Adding default game items
        addGameItem("Ammo", 10);
        addGameItem("Gun", 50);
        addGameItem("Health", 15);
    }

    function redeemTokens(uint256 itemId, uint256 quantity) public {
        require(itemId < itemIdCounter, "Invalid item ID");
        uint256 cost = itemCosts[itemId] * quantity;
        require(balanceOf(msg.sender) >= cost, "Insufficient tokens to redeem the item");
        itemsOwned[msg.sender][itemId] += quantity;
        _burn(msg.sender, cost);
    }

    function checkTokensOwned(address user) public view returns (uint256) {
        return balanceOf(user);
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens to transfer");
        _transfer(msg.sender, to, amount);
    }

    function addGameItem(string memory name, uint256 cost) public onlyOwner {
        itemNames[itemIdCounter] = name;
        itemCosts[itemIdCounter] = cost;
        itemIdCounter++;
    }

    function getGameItem(uint256 itemId) public view returns (string memory, uint256) {
        return (itemNames[itemId], itemCosts[itemId]);
    }

    function getInventory() public view returns (uint256[] memory, string[] memory, uint256[] memory) {
        uint256[] memory itemIdsArray = new uint256[](itemIdCounter);
        string[] memory itemNamesArray = new string[](itemIdCounter);
        uint256[] memory itemCostsArray = new uint256[](itemIdCounter);

        for (uint256 i = 0; i < itemIdCounter; i++) {
            itemIdsArray[i] = i;
            itemNamesArray[i] = itemNames[i];
            itemCostsArray[i] = itemCosts[i];
        }

        return (itemIdsArray, itemNamesArray, itemCostsArray);
    }
}


Compiling and Deploying the Contract
Compilation: Go to the "Solidity Compiler" tab on the left sidebar. Choose the compatible compiler version (e.g., 0.8.4) and click "Compile DegenToken.sol."
Deploying: Once compiled, connect your MetaMask wallet to Remix IDE by selecting "Injected Provider - MetaMask" in the environment dropdown under the "DEPLOY" section. Deploy the contract, and confirm the transaction in your wallet.


Interacting with the Deployed Contract
After deployment, you can interact with the contract using the following functions:

Minting Tokens: As the contract owner, mint tokens using mintTokens(address to, uint256 amount).
Transferring Tokens: Transfer tokens to another address using transferTokens(address to, uint256 amount).
Redeeming Items: Redeem tokens for game items via redeemTokens(uint256 itemId, uint256 quantity).
Checking Balance: Check token balances with checkTokensOwned(address user).
Adding Game Items: Add new in-game items using addGameItem(string memory name, uint256 cost).
Viewing Inventory: Retrieve the complete inventory of items using getInventory().
This smart contract offers a comprehensive ERC20 token management solution with additional features to enhance the gaming experience.
