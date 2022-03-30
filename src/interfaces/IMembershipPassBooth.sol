//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;

// import "./IMembershipPass.sol";
// import "../Terminal.sol";
// import "./ITerminal.sol";

// struct MembershipTier {
//     uint8 id;
//     uint256 reputationMultiplier;
//     uint256 salePrice;
//     uint256 totalSupply;
// }

interface IMembershipPassBooth {
    // event Issue(
    //     uint indexed projectId,
    //     string name,
    //     string 
    // )

    // function membershipPassOf(uint256 _projectId) external view returns (IMembershipPass);
        
    function issue(
        uint256 _projectId,
        string memory _uri,
        string memory _contractURI,
        address _feeCollector,
        uint256[] memory _tierFee,
        uint256[] memory _tierCapacity
    ) external;
}
