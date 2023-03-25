// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.0;

import { ERC721Diamond } from '../ERC721Diamond.sol';
import { ERC721Storage } from '../LibERC721Diamond.sol';

/**
 * @dev This implements an optional function for {ERC721Diamond} that enumerates
 * all of the token ids owned by each account.
 */
contract ERC721DiamondQueryable is ERC721Diamond {
    function tokensOfOwner(address owner) external view returns(uint256[] memory) {
        uint256 tokenIdsIdx;
        uint256 ownerBalance = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](ownerBalance);
        for (uint256 i; tokenIdsIdx != ownerBalance; ++i) {
            if (ERC721Storage.layout()._ownerOf[i] == owner) {
                tokenIds[tokenIdsIdx++] = i;
            }
        }
        return tokenIds;
    }
}