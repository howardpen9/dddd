//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;


import "./IOperatorStore.sol";

interface IOperatable {
    function operatorStore() external view returns (IOperatorStore);
}
