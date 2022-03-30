//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IProjects.sol";
import "./IFundingCycles.sol";

struct ImmutablePassTier {
    uint8 id;
    uint256 multiplier;
    uint256 totalSupply;
    uint256 whitelistAmount;
    address[] whitelists;
}

struct PayInfo {
    uint8 categoryId;
    uint256 amount;
}

interface ITerminal {
    function contributeFee() external view returns (uint256);

    function createDao(
        address _owner,
        bytes32 _handle,
        string memory _uri,
        ImmutablePassTier[] memory _tiers,
        FundingCycleProperties memory _properties
    ) external;

    /**
     * @notice
     * Contribute to a project
     */
    function contribute(
        uint256 _projectId,
        PayInfo[] memory _payData,
        string memory _memo
    ) external;

    /**
     * @notice
     * Claim membership pass or refund
     */
    function claimPassOrRefund(uint256 _projectId) external;

    /**
     * @notice
     * free mint for community members(can set amount of free membershipPass for user who has
     * specific NFT in wallet)
     */
    function whitelistMint(address _for) external;
}
