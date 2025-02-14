// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Token", "TKN") {}
}

/*
forge inspect src/Token.sol:Token storageLayout

╭--------------+-------------------------------------------------+------+--------+-------+---------------------╮
| Name         | Type                                            | Slot | Offset | Bytes | Contract            |
+==============================================================================================================+
| _balances    | mapping(address => uint256)                     | 0    | 0      | 32    | src/Token.sol:Token |
|--------------+-------------------------------------------------+------+--------+-------+---------------------|
| _allowances  | mapping(address => mapping(address => uint256)) | 1    | 0      | 32    | src/Token.sol:Token |
|--------------+-------------------------------------------------+------+--------+-------+---------------------|
| _totalSupply | uint256                                         | 2    | 0      | 32    | src/Token.sol:Token |
|--------------+-------------------------------------------------+------+--------+-------+---------------------|
| _name        | string                                          | 3    | 0      | 32    | src/Token.sol:Token |
|--------------+-------------------------------------------------+------+--------+-------+---------------------|
| _symbol      | string                                          | 4    | 0      | 32    | src/Token.sol:Token |
╰--------------+-------------------------------------------------+------+--------+-------+---------------------╯
*/
