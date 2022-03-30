//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;


interface IRoyaltyDistributor {
	/**
	 * @notice
	 * Claim according to votes share
	 */
	function claimRoyalties() external;
}