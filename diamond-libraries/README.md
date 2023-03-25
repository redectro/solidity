# Redsh4de's libraries for Diamond Facets

This GitHub repository contains a collection of EIP-2535 focused libraries that implement well-known and used token standards. These libraries aim to simplify the process of implementing Diamond Standard (EIP-2535) contracts with various token functionalities, enabling developers to create more efficient and flexible contracts for their projects. These libraries were initially created for the [NIWA](https://twitter.com/niwanft) NFT project.

## Libraries Included

1. **ERC721-Diamond**: A library implementing the ERC-721 (Non-Fungible Token) standard for Diamonds, allowing you to create and manage unique tokens within a Diamond contract.
2. **ERC721A-Diamond**: An mod of the ERC721-A implementation by Chiru Labs, optimized for batch minting at the cost of increased transfer costs.
3. **ERC1155-Diamond**: A library implementing the ERC-1155 (Multi-Token) standard for Diamonds, enabling the creation and management of both fungible and non-fungible tokens within a single Diamond contract.
4. **OperatorFilterer-Diamond**: A utility library for managing operators allowed to transfer tokens on behalf of users, meant to targeting smart contracts and delegates of marketplaces that do not respect creator earnings.
5. **ERC2981-Diamond**: A library implementing the ERC-2981 (NFT Royalty Standard) for Diamonds, enabling the support for royalty payments to original creators when their NFTs are resold in the secondary market.

## Getting Started

To start using these libraries, simply clone this repository and import the desired library in your Diamond contract. 

```bash
git clone https://github.com/redsh4de/solidity.git
```

## Requirements

To use these libraries, you must have:

1. Solidity compiler version 0.8.0 or higher
2. Diamond Standard (EIP-2535) implemented in your contract.

## Contributing
Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a new Pull Request

If you encounter any issues or have questions, please open an issue in the repository.
