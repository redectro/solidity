// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import { ERC1155Diamond } from '../ERC1155Diamond.sol';
import { ERC1155Storage } from '../LibERC1155Diamond.sol';

contract ERC1155DiamondQueryable is ERC1155Diamond {
    /// @notice                          Return all the clothing items held by the user, with their amounts. For frontend usage only
    /// @param _owner                    Owner address
    function tokensOfOwnerIn(address _owner, uint256 _startID, uint256 _endID) public view returns (uint256[] memory) {
        uint256 arrLen = _endID - _startID;
        uint256[] memory tokenIds = new uint256[](arrLen);
        uint256 counter;
        unchecked {
            // Unchecked is safe because counter <= _endID <= 2^256-1
            for (uint256 i = _startID; i < _endID; ++i) {
                if (ERC1155Storage.layout().balanceOf[_owner][i] != 0) tokenIds[counter++] = i;
            }
        }
        assembly {
            mstore(tokenIds, sub(mload(tokenIds), sub(arrLen, counter)))    // Assembly hack to clip the array size
        }
        return tokenIds;
    }
}
