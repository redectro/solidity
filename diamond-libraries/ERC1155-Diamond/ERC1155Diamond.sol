// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import { LibERC1155Diamond } from './LibERC1155Diamond.sol';
import { IERC1155Diamond } from './IERC1155Diamond.sol';

/// @notice Minimalist and gas efficient standard ERC1155 implementation. Modified for the use in Diamond facets.
/// @author Redsh4de
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)
contract ERC1155Diamond is IERC1155Diamond {
    /*//////////////////////////////////////////////////////////////
                             METADATA LOGIC
    //////////////////////////////////////////////////////////////*/

    function uri(uint256 id) public view virtual returns (string memory) {
        return LibERC1155Diamond.uri(id);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC1155 LOGIC
    //////////////////////////////////////////////////////////////*/

    function setApprovalForAll(address operator, bool approved) public virtual {
        LibERC1155Diamond.setApprovalForAll(operator, approved);
    }

    function balanceOf(address owner, uint256 id) public view returns(uint256) {
        return LibERC1155Diamond.balanceOf(owner, id);
    }

    function isApprovedForAll(address account, address operator) public view returns(bool) {
        return LibERC1155Diamond.isApprovedForAll(account, operator);
    }

    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return LibERC1155Diamond.totalSupply(id);
    }

    function exists(uint256 id) public view virtual returns (bool) {
        return LibERC1155Diamond.exists(id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) public virtual {
        LibERC1155Diamond.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public virtual {
        LibERC1155Diamond.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function balanceOfBatch(address[] calldata owners, uint256[] calldata ids)
        public
        view
        virtual
        returns (uint256[] memory balances)
    {
        return LibERC1155Diamond.balanceOfBatch(owners, ids);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    /*function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
            interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
    }*/

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        LibERC1155Diamond._mint(to, id, amount, data);
    }

    function _batchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        LibERC1155Diamond._batchMint(to, ids, amounts, data);
    }

    function _batchBurn(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        LibERC1155Diamond._batchBurn(from, ids, amounts);
    }

    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        LibERC1155Diamond._burn(from, id, amount);
    }
}