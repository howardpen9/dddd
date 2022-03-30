// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface IProjects is IERC721 {
	event Create(
		uint256 indexed projectId,
		address indexed owner,
		bytes32 indexed handle,
		string uri,
		address caller
	);

	event SetHandle(
		uint256 indexed projectId,
		bytes32 indexed handle,
		address caller
	);

	event SetUri(uint256 indexed projectId, string uri, address caller);

	function count() external view returns (uint256);

	function handleOf(uint256 _projectId) external returns (bytes32 handle);

	function projectFor(bytes32 _handle) external returns (uint256 projectId);

	function exists(uint256 _projectId) external view returns (bool);

	function create(
		address _owner,
		bytes32 _handle,
		string calldata _uri
	) external returns (uint256 id);

	function setHandle(uint256 _projectId, bytes32 _handle) external;

	function setUri(uint256 _projectId, string calldata _uri) external;
}