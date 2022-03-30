//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;

import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";

interface IMembershipPass  {
    /************************* EVENTS *************************/

    event MintPass(address indexed _account, uint256 indexed _tier, uint256 _amount);

    event BatchMintPass(
        address _account,
        uint256[] _tiers,
        uint256[] _amounts
    );

    /************************* VIEW FUNCTIONS *************************/

    function feeCollector() external view returns (address);

    /**
     * @notice
     * Contract-level metadata for OpenSea
     * see https://docs.opensea.io/docs/contract-level-metadata
     */
    function contractURI() external view returns (string memory);

    // /**
    //  * @notice
    //  * Implement ERC2981, but actually the most marketplaces have their own royalty logic
    //  */
    // function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
    //     external
    //     view
    //     override
    //     returns (address receiver, uint256 royaltyAmount);

    /************************* STATE MODIFYING FUNCTIONS *************************/

    function mintPassForMember(
        address _account,
        uint256 _token,
        uint256 _amount
    ) external;

    function batchMintPassForMember(
        address _account,
        uint256[] memory _tokens,
        uint256[] memory _amounts
    ) external;
}
