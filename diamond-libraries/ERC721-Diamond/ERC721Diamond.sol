// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Modern, minimalist, and gas efficient ERC-721 implementation. Modified for use in Diamond facets.
/// @author Redsh4de (https://github.com/redsh4de/solidity/blob/main/diamond-libraries/ERC721-Diamond/ERC721Diamond.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)

import { LibERC721Diamond } from './LibERC721Diamond.sol';
import { IERC721Diamond } from './IERC721Diamond.sol';

contract ERC721Diamond is IERC721Diamond {
    /*//////////////////////////////////////////////////////////////
                         METADATA STORAGE/LOGIC
    //////////////////////////////////////////////////////////////*/

    function name() public view returns (string memory) {
        return LibERC721Diamond.name();
    }

    function symbol() public view returns (string memory) {
        return LibERC721Diamond.symbol();
    }

    function tokenURI(uint256 id) public view virtual returns (string memory) {}

    /*//////////////////////////////////////////////////////////////
                      ERC721 BALANCE/OWNER STORAGE
    //////////////////////////////////////////////////////////////*/

    function ownerOf(uint256 id) public view virtual returns (address owner) {
        owner = LibERC721Diamond.ownerOf(id);
    }

    function balanceOf(address owner) public view virtual returns (uint256) {
        return LibERC721Diamond.balanceOf(owner);
    }

    /*//////////////////////////////////////////////////////////////
                         ERC721 APPROVAL STORAGE
    //////////////////////////////////////////////////////////////*/

    function getApproved(uint256 id) public view returns (address) {
        return LibERC721Diamond.getApproved(id);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return LibERC721Diamond.isApprovedForAll(owner, operator);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 id) public virtual {
        LibERC721Diamond.approve(spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        LibERC721Diamond.setApprovalForAll(operator, approved);
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual {
        LibERC721Diamond.transferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual {
        LibERC721Diamond.safeTransferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) public virtual {
        LibERC721Diamond.safeTransferFrom(from, to, id, data);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 id) internal virtual {
        LibERC721Diamond._mint(to, id);
    }

    function _burn(uint256 id) internal virtual {
        LibERC721Diamond._burn(id);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL SAFE MINT LOGIC
    //////////////////////////////////////////////////////////////*/

    function _safeMint(address to, uint256 id) internal virtual {
        LibERC721Diamond._safeMint(to, id);
    }

    function _safeMint(
        address to,
        uint256 id,
        bytes memory data
    ) internal virtual {
        LibERC721Diamond._safeMint(to, id, data);
    }
}

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
abstract contract ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}