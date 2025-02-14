// SPDX-License-Identifier: MIT

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import {Token} from "../src/Token.sol";

pragma solidity ^0.8.20;

contract StringScript is Script {
    function getFullString(address targetContract, uint256 startSlot) public view returns (string memory) {
        // A slot in the EVM is 32 bytes
        uint256 SLOT_SIZE = 32;
        // We load the start slot from storage
        bytes32 slotVal = vm.load(targetContract, bytes32(startSlot));
        // If the last bit of the contents of storage slot 0 is 1
        // then string is >= 32 bytes
        if ((uint256(slotVal) & 1) == 1) {
            // We can extract the string length to determine how many slots are used.
            // This formula is from solidity docs
            uint256 stringLength = (uint256(slotVal) - 1) / 2;
            // Now we know the length of the string, we can determine the number of slots used
            // This is idiomatic for divison but rounding up: https://stackoverflow.com/a/2422722
            uint256 slotsUsed = (stringLength + (SLOT_SIZE - 1)) / SLOT_SIZE;
            // Since we have a larger string, we want to jump to the
            // contiguous section of storage with the string contents
            // The start of this contiguous section is calculated using keccak256
            bytes32 nextSlot = keccak256(abi.encodePacked(startSlot));
            // We can now iterate through the slots while concatanating the string
            bytes memory resultString;
            for (uint256 i = 0; i < slotsUsed; i++) {
                // We load the contents of the storage slot
                bytes32 slotValue = vm.load(targetContract, nextSlot);
                // We concatenate the contents of the string with what we've observed so far
                resultString = abi.encodePacked(resultString, slotValue);
                // We update the next slot value to the next contiguous entry
                nextSlot = bytes32(uint256(nextSlot) + 1);
            }
            return string(resultString);
        } else {
            // Slot value is < 32 bytes
            return string(abi.encodePacked(slotVal));
        }
    }

    // forge script script/Strings.s.sol --sig "run(address,uint256)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 6 --rpc-url https://rpc.esync.network
    function run(address targetContract, uint256 startSlot) public view {
        string memory fullString = getFullString(targetContract, startSlot);
        console2.log("Full string in slot %s: '%s'", startSlot, fullString);
    }

    // forge script script/Strings.s.sol --rpc-url https://rpc.esync.network
    function run() public view {
        Token token = Token(0xae33C49279cf0848dde5f92A2784a0aBA9395FA0);

        run(address(token), 6); // name
    }
}
