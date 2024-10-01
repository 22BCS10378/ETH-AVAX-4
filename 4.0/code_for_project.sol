// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    

    
    mapping(address => mapping(uint256 => uint256)) public itemsOwned; // Mapping of user to item id to quantity

    
    mapping(uint256 => string) public itemNames;  // Mapping of item id to item name

    
    mapping(uint256 => uint256) public itemCosts;  // Mapping of item id to item cost

    uint256 public itemIdCounter;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        itemIdCounter = 0;

        // Add default game items
        addGameItem("Ammo", 10);
        addGameItem("Gun", 50);
        addGameItem("Health", 15);
    }

    function redeemTokens(uint256 itemId, uint256 quantity) public {
        require(itemId < itemIdCounter, "Invalid item ID");
        uint256 cost = itemCosts[itemId] * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for an item");

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
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
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
