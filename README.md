# forge-slots-inspect
Contains forge helper scripts to read onchain state variables by inspecting contract slots via foundry.

It allows to inspect (private) contract variables such as
- Arrays
- Mappings
- String

## Examples / Usage

### Arrays

**function run(address targetContract, uint256 startSlot)**

`forge script script/Array.s.sol --sig "run(address,uint256)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 24 --rpc-url https://rpc.esync.network`

### Mappings

Load a value from a mapping for a particular key (e.g. ERC 20 token balance for an address).

**function run(address targetContract, uint256 startSlot, address key)**

`forge script script/Mapping.s.sol:MappingScript --sig "run(address,uint256,address)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 11 0x1D64ec1f5b1fdC4373C3322394cf623C86792Ac7 --rpc-url https://rpc.esync.network`

### Strings

**function run(address targetContract, uint256 startSlot)**

`forge script script/String.s.sol --sig "run(address,uint256)" 0xae33C49279cf0848dde5f92A2784a0aBA9395FA0 6 --rpc-url https://rpc.esync.network`