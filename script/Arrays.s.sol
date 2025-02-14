// SPDX-License-Identifier: MIT

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import {Token} from "../src/Token.sol";

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

    function run(address targetContract, uint256 startSlot) public view {
        uint256[] memory a = getFullArray(startSlot, targetContract); // minters

        for (uint256 i = 0; i < a.length; i++) {
            console2.log("Address %s:", i, address(uint160(a[i])));
        }
    }

    // forge script script/Arrays.s.sol --rpc-url https://rpc.esync.network
    // forge script script/Arrays.s.sol --sig "run(address,uint256)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 24 --rpc-url https://rpc.esync.network

    function run() public view {
        Token token = Token(0xae33C49279cf0848dde5f92A2784a0aBA9395FA0);

        return run(address(token), 24); // controllers

        //uint256[] memory a = getFullArray(24, address(token));    // controllers

        /*
        to get the storage layout below:
            `forge inspect contracts/Token.sol:Token storageLayout`

        ╭--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------╮
        | Name                           | Type                                                                | Slot | Offset | Bytes | Contract                        |
        +================================================================================================================================================================+
        | _owner                         | address                                                             | 0    | 0      | 20    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | registryAddress                | address                                                             | 1    | 0      | 20    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | ERC1820REGISTRY                | contract IERC1820Registry                                           | 2    | 0      | 20    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _interfaceHashes               | mapping(bytes32 => bool)                                            | 3    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _minters                       | struct Roles.Role                                                   | 4    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | domainSeparators               | mapping(uint256 => bytes32)                                         | 5    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _name                          | string                                                              | 6    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _symbol                        | string                                                              | 7    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _granularity                   | uint256                                                             | 8    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _totalSupply                   | uint256                                                             | 9    | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _migrated                      | bool                                                                | 10   | 0      | 1     | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _isControllable                | bool                                                                | 10   | 1      | 1     | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _isIssuable                    | bool                                                                | 10   | 2      | 1     | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _balances                      | mapping(address => uint256)                                         | 11   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _allowed                       | mapping(address => mapping(address => uint256))                     | 12   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _documents                     | mapping(bytes32 => struct ERC1400.Doc)                              | 13   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _indexOfDocHashes              | mapping(bytes32 => uint256)                                         | 14   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _docHashes                     | bytes32[]                                                           | 15   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _totalPartitions               | bytes32[]                                                           | 16   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _indexOfTotalPartitions        | mapping(bytes32 => uint256)                                         | 17   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _totalSupplyByPartition        | mapping(bytes32 => uint256)                                         | 18   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _partitionsOf                  | mapping(address => bytes32[])                                       | 19   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _indexOfPartitionsOf           | mapping(address => mapping(bytes32 => uint256))                     | 20   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _balanceOfByPartition          | mapping(address => mapping(bytes32 => uint256))                     | 21   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _defaultPartitions             | bytes32[]                                                           | 22   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _authorizedOperator            | mapping(address => mapping(address => bool))                        | 23   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _controllers                   | address[]                                                           | 24   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _isController                  | mapping(address => bool)                                            | 25   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _allowedByPartition            | mapping(bytes32 => mapping(address => mapping(address => uint256))) | 26   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _authorizedOperatorByPartition | mapping(address => mapping(bytes32 => mapping(address => bool)))    | 27   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _controllersByPartition        | mapping(bytes32 => address[])                                       | 28   | 0      | 32    | contracts/RocToken.sol:RocToken |
        |--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------|
        | _isControllerByPartition       | mapping(bytes32 => mapping(address => bool))                        | 29   | 0      | 32    | contracts/RocToken.sol:RocToken |
        ╰--------------------------------+---------------------------------------------------------------------+------+--------+-------+---------------------------------╯
        */
    }
}
