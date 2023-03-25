// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.0;

import { ERC721Diamond } from '../ERC721Diamond.sol';
import { ERC721Storage } from '../LibERC721Diamond.sol';

/**
 * @title ERC721 Burnable Token
 * @dev ERC721 Token that can be burned (destroyed).
 */
abstract contract ERC721DiamondBurnable is ERC721Diamond {
    error BurnCallerNotOwnerNorApproved();
    /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `id` or be an approved operator.
     */
    function burn(uint256 id) public virtual {
        //solhint-disable-next-line max-line-length
        address owner = ERC721Storage.layout()._ownerOf[id];
        if (msg.sender != owner && !ERC721Storage.layout().isApprovedForAll[owner][msg.sender]) revert BurnCallerNotOwnerNorApproved();
        _burn(id);
    }
}