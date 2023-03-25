// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {IERC721Diamond} from "./IERC721Diamond.sol";

/// @notice Modern, minimalist, and gas efficient ERC-721 implementation. Modified for use in Diamond facets.
/// @author Redsh4de (https://github.com/redsh4de/solidity/blob/main/diamond-libraries/ERC721-Diamond/LibERC721Diamond.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)

library ERC721Storage {
    struct Layout {
        // =============================================================
        //                            STORAGE
        // =============================================================
        string name;
        string symbol;

        mapping(uint256 => address) _ownerOf;
        mapping(address => uint256) _balanceOf;

        mapping(uint256 => address) getApproved;
        mapping(address => mapping(address => bool)) isApprovedForAll;
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("ERC721.contracts.storage.ERC721");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}

library LibERC721Diamond {
    using ERC721Storage for ERC721Storage.Layout;
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 indexed id
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /*//////////////////////////////////////////////////////////////
                         METADATA STORAGE/LOGIC
    //////////////////////////////////////////////////////////////*/

    function name() internal view returns (string memory) {
        return ERC721Storage.layout().name;
    }

    function symbol() internal view returns (string memory) {
        return ERC721Storage.layout().symbol;
    }

    function tokenURI(uint256 id) internal view returns (string memory) {}

    /*//////////////////////////////////////////////////////////////
                      ERC721 BALANCE/OWNER STORAGE
    //////////////////////////////////////////////////////////////*/

    function ownerOf(uint256 id) internal view returns (address owner) {
        if ((owner = ERC721Storage.layout()._ownerOf[id]) == address(0)) revert IERC721Diamond.OwnerQueryForNonexistentToken();
    }

    function balanceOf(address owner) internal view returns (uint256) {
        if (owner == address(0)) revert IERC721Diamond.BalanceQueryForZeroAddress();

        return ERC721Storage.layout()._balanceOf[owner];
    }

    /*//////////////////////////////////////////////////////////////
                         ERC721 APPROVAL STORAGE
    //////////////////////////////////////////////////////////////*/

    function getApproved(uint256 id) internal view returns (address) {
        return ERC721Storage.layout().getApproved[id];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) internal view returns (bool) {
        return ERC721Storage.layout().isApprovedForAll[owner][operator];
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 id) internal {
        address owner = ERC721Storage.layout()._ownerOf[id];

        if (
            msg.sender != owner &&
            !ERC721Storage.layout().isApprovedForAll[owner][msg.sender]
        ) revert IERC721Diamond.ApprovalCallerNotOwnerNorApproved();

        ERC721Storage.layout().getApproved[id] = spender;

        emit Approval(owner, spender, id);
    }

    function setApprovalForAll(address operator, bool approved) internal {
        ERC721Storage.layout().isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) internal {
        if (from != ERC721Storage.layout()._ownerOf[id]) revert IERC721Diamond.TransferFromIncorrectOwner();

        if (to == address(0)) revert IERC721Diamond.TransferToZeroAddress();

        if (
            msg.sender != from &&
            !ERC721Storage.layout().isApprovedForAll[from][msg.sender] &&
            msg.sender != ERC721Storage.layout().getApproved[id]
        ) revert IERC721Diamond.TransferCallerNotOwnerNorApproved();

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            --ERC721Storage.layout()._balanceOf[from];
            ++ERC721Storage.layout()._balanceOf[to];
        }

        ERC721Storage.layout()._ownerOf[id] = to;

        delete ERC721Storage.layout().getApproved[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint256 id) internal {
        transferFrom(from, to, id);

        if (
            to.code.length != 0 &&
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                from,
                id,
                ""
            ) !=
            ERC721TokenReceiver.onERC721Received.selector
        ) revert IERC721Diamond.TransferToNonERC721ReceiverImplementer();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) internal {
        transferFrom(from, to, id);

        if (
            to.code.length != 0 &&
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                from,
                id,
                data
            ) !=
            ERC721TokenReceiver.onERC721Received.selector
        ) revert IERC721Diamond.TransferToNonERC721ReceiverImplementer();
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    /*function supportsInterface(bytes4 interfaceId) internal view returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }*/

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 id) internal {
        if (to == address(0)) revert IERC721Diamond.MintToZeroAddress();
        if (ERC721Storage.layout()._ownerOf[id] != address(0)) revert IERC721Diamond.MintExistingId();

        // Counter overflow is incredibly unrealistic.
        unchecked {
            ++ERC721Storage.layout()._balanceOf[to];
        }

        ERC721Storage.layout()._ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function _burn(uint256 id) internal {
        address owner = ERC721Storage.layout()._ownerOf[id];

        if (owner == address(0)) revert IERC721Diamond.BurnQueryForNonexistentToken();

        // Ownership check above ensures no underflow.
        unchecked {
            --ERC721Storage.layout()._balanceOf[owner];
        }

        delete ERC721Storage.layout()._ownerOf[id];

        delete ERC721Storage.layout().getApproved[id];

        emit Transfer(owner, address(0), id);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL SAFE MINT LOGIC
    //////////////////////////////////////////////////////////////*/

    function _safeMint(address to, uint256 id) internal {
        _mint(to, id);

        if (
            to.code.length != 0 &&
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                address(0),
                id,
                ""
            ) !=
            ERC721TokenReceiver.onERC721Received.selector
        ) revert IERC721Diamond.TransferToNonERC721ReceiverImplementer();
    }

    function _safeMint(address to, uint256 id, bytes memory data) internal {
        _mint(to, id);

        if (
            to.code.length != 0 &&
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                address(0),
                id,
                data
            ) !=
            ERC721TokenReceiver.onERC721Received.selector
        ) revert IERC721Diamond.TransferToNonERC721ReceiverImplementer();
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
