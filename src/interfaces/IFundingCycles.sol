//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;

pragma solidity >=0.8.10;

// @notice The funding cycle structure represents a project stewarded by an address, 
// and accounts for which addresses have helped sustain the project.
struct FundingCycle {
    // A unique number that's incremented for each new funding cycle, starting with 1.
    uint256 id;
    // The ID of the project contract that this funding cycle belongs to.
    uint256 projectId;
    // The number of this funding cycle for the project.
    uint256 number;
    // The ID of a previous funding cycle that this one is based on.
    uint256 basedOn;
    // The time when this funding cycle was last configured.
    uint256 configured;
    // The number of cycles that this configuration should last for before going back to the last permanent.
    uint256 cycleLimit;
    // The ballot contract to use to determine a subsequent funding cycle's reconfiguration status.
    AuctionedPass[] _passes;
    // The time when this funding cycle will become active.
    uint256 start;
    // The number of seconds until this funding cycle's surplus is redistributed.
    uint256 duration;
    // The amount that this funding cycle is targeting in terms of the currency.
    uint256 target;
    // The currency that the target is measured in.
    uint256 currency;
    // The percentage of each payment to send as a fee to the Juicebox admin.
    uint256 fee;
    // A percentage indicating how much more weight to give a funding cycle compared to its predecessor.
    uint256 discountRate;
    // The amount of available funds that have been tapped by the project in terms of the currency.
    uint256 tapped;
    // A packed list of extra data. The first 8 bytes are reserved for versioning.
    uint256 metadata;
}

struct AuctionedPass {
    uint8 id;
    uint256 salePrice;
    uint256 reservedAmount;
    // remainingAmount = totalSupply - mintedAmount - reservedAmount
    uint256 remainingAmount;
}

struct FundingCycleProperties {
    uint256 target;
    uint256 duration;
    bool isPaused;
    AuctionedPass[] _passes;
}

interface IFundingCycles {

    event Configure(
        uint256 indexed fundingCycleId,
        uint256 indexed projectId,
        uint256 reconfigured,
        FundingCycleProperties _properties,
        address caller
    );

    event Init(
        uint256 indexed fundingCycleId,
        uint256 indexed projectId,
        uint256 number,
        uint256 previous,
        uint256 weight,
        uint256 start
    );

    function configure(
        uint256 _projectId,
        FundingCycleProperties calldata _properties,
        uint256 _metadata,
        uint256 _fee,
        bool _configureActiveFundingCycle
    ) external returns (FundingCycle memory fundingCycle);
}
