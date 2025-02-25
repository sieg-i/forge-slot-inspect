// SPDX-License-Identifier: MIT

import "forge-std/Script.sol";
import "forge-std/console2.sol";

pragma solidity ^0.8.20;

contract ArrayScript is Script {
    function getFullArray(uint256 startSlot, address targetContract) public view returns (uint256[] memory) {
        // Load the start slot from storage
        bytes32 slotVal = vm.load(targetContract, bytes32(startSlot));
        // The first slot contains the size of the array
        uint256 arrayLength = uint256(slotVal);
        console.log("Slot %s array length:", startSlot, arrayLength);

        // Initialize an array in memory to hold the values we retrieve from storage
        uint256[] memory fullArr = new uint256[](arrayLength);
        // Calculate the start of the contiguous section in storage containing the array contents
        bytes32 startSlotBytes = keccak256(abi.encodePacked(startSlot));
        // Iterate through the slots containing the array contents and store them in memory;
        for (uint256 i = 0; i < arrayLength; i++) {
            slotVal = vm.load(targetContract, bytes32(uint256(startSlotBytes) + i));
            fullArr[i] = uint256(slotVal);
        }
        return fullArr;
    }

    // forge script script/Array.s.sol --sig "run(address,uint256)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 24 --rpc-url https://rpc.esync.network
    function run(address targetContract, uint256 startSlot) public view {
        uint256[] memory a = getFullArray(startSlot, targetContract); // minters

        for (uint256 i = 0; i < a.length; i++) {
            console2.log("Address %s:", i, address(uint160(a[i])));
        }
    }

    // forge script script/Array.s.sol --rpc-url https://rpc.esync.network
    function run() public view {
        return run(0xae33C49279cf0848dde5f92A2784a0aBA9395FA0, 24); // controllers
    }
}
