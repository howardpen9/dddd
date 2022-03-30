//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./interfaces/IRoyaltyDistributor.sol";

// Collect the fees  
// Calculate the share / percentage the user can get
// Distributed 
contract RoyaltyDistributor is Ownable, IRoyaltyDistributor {
    uint256 public royaltyAggregationPeriod;

    constructor() {}

    function claimRoyalties() public override {
        //claim according to votes share
    }
}
