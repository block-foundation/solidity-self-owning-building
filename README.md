<div align="right">

  [![license](https://img.shields.io/github/license/block-foundation/solidity-self-owning-building?color=green&label=license&style=flat-square)](LICENSE.md)
  ![stars](https://img.shields.io/github/stars/block-foundation/solidity-self-owning-building?color=blue&label=stars&style=flat-square)
  ![contributors](https://img.shields.io/github/contributors/block-foundation/solidity-self-owning-building?color=blue&label=contributors&style=flat-square)

</div>

---

<div>
    <img align="right" src="https://raw.githubusercontent.com/block-foundation/brand/master/logo/logo_gray.png" width="96" alt="Block Foundation Logo">
    <h1 align="left">Self-Owning Building</h1>
    <h3 align="left">Block Foundation Smart Contract Series [Solidity]</h3>
</div>

---

<div>
<img align="right" width="75%" src="https://raw.githubusercontent.com/block-foundation/brand/master/image/repository_cover/block_foundation-structure-03-accent.jpg"  alt="Block Foundation">
<br>
<details open="open">
<summary>Table of Contents</summary>
  
- [Introduction](#style-guide)
- [Quick Start](#quick-start)
- [Contract](#contract)
- [Development Resources](#development-resources)
- [Legal Information](#legal-information)
  - [Copyright](#copyright)
  - [License](#license)
  - [Warning](#warning)
  - [Disclaimer](#disclaimer)

</details>
</div>

<br clear="both"/>

## Introduction

Blockchain Autonomous Building Management!

Welcome to our revolutionary project - an autonomous building management system built on the Blockchain. The project integrates a unique blend of real estate management and blockchain technology, creating an ecosystem where a building can effectively "own" itself. This concept is a stepping stone to decentralized autonomous organizations (DAOs) and a significant leap forward for blockchain applications in real estate.

Our autonomous building management system employs smart contracts to manage and oversee a building's fundamental operational aspects, including rent collection, maintenance costs, and ownership transfers. The smart contracts, which are blockchain's primary building blocks, are immutable, transparent, and verifiable pieces of code that automatically execute transactions when predefined conditions are met.

In the context of our project, these smart contracts come to life as entities managing a building. They collect rent from tenants, pay maintenance costs, and can even transfer ownership when the building is bought. We implement penalty mechanisms for late payments, ensuring all stakeholders are held accountable.

This system can have profound implications for reducing administrative overhead, increasing efficiency, and fostering a new level of transparency in the real estate sector.

Please note, this project showcases the potential of blockchain technology. As with any significant technology implementation, thorough testing is required before actual use. Blockchain and smart contract technology is complex, and mistakes can lead to severe consequences, including loss of funds. Always consult with experts when interacting with such systems.

Join us as we explore this unique amalgamation of blockchain and real estate, transforming the way we manage and interact with buildings in the future. Welcome to the future of autonomous building management!

## Quick Start

> Install

``` sh
npm i
```

> Compile

``` sh
npm run compile
```

## Contract

This is an example of a Solidity smart contract that represents a building that owns itself. This contract can be used to manage funds, pay for maintenance, collect rent, and sell ownership.

This contract should be deployed by sending a transaction with enough value to cover the initial price, rent, and maintenance costs. The contract includes a timestamp for the last rent payment and the last maintenance payment, and it checks that the payments are not overdue before transferring ownership or withdrawing funds. The contract also requires an extra fee for late payments.

It includes functionalities to:

- Introduce a mechanism to penalize or evict tenants if they do not pay rent.
- Prevent the building from falling into disrepair if the maintenance costs are not paid.
- Handle outstanding rent payments or maintenance costs before the building can be sold.

*Please note that this is still a simplified model, and real-world applications would require additional functionality and security measures. Also, the contract should be thoroughly tested before it's used in production. Always consult with a knowledgeable expert in blockchain and smart contract technology before deploying or interacting with smart contracts.*

## Development Resources

### Other Repositories

#### Block Foundation Smart Contract Series

|                                   | `Solidity`  | `Teal`      |
| --------------------------------- | ----------- | ----------- |
| **Template**                      | [**>>>**](https://github.com/block-foundation/solidity-template) | [**>>>**](https://github.com/block-foundation/teal-template) |
| **Architectural Design**          | [**>>>**](https://github.com/block-foundation/solidity-architectural-design) | [**>>>**](https://github.com/block-foundation/teal-architectural-design) |
| **Architecture Competition**      | [**>>>**](https://github.com/block-foundation/solidity-architecture-competition) | [**>>>**](https://github.com/block-foundation/teal-architecture-competition) |
| **Housing Cooporative**           | [**>>>**](https://github.com/block-foundation/solidity-housing-cooperative) | [**>>>**](https://github.com/block-foundation/teal-housing-cooperative) |
| **Land Registry**                 | [**>>>**](https://github.com/block-foundation/solidity-land-registry) | [**>>>**](https://github.com/block-foundation/teal-land-registry) |
| **Real-Estate Crowdfunding**      | [**>>>**](https://github.com/block-foundation/solidity-real-estate-crowdfunding) | [**>>>**](https://github.com/block-foundation/teal-real-estate-crowdfunding) |
| **Rent-to-Own**                   | [**>>>**](https://github.com/block-foundation/solidity-rent-to-own) | [**>>>**](https://github.com/block-foundation/teal-rent-to-own) |
| **Self-Owning Building**          | [**>>>**](https://github.com/block-foundation/solidity-self-owning-building) | [**>>>**](https://github.com/block-foundation/teal-self-owning-building) |
| **Smart Home**                    | [**>>>**](https://github.com/block-foundation/solidity-smart-home) | [**>>>**](https://github.com/block-foundation/teal-smart-home) |

## Legal Information

### Copyright

Copyright 2023, [Stichting Block Foundation](https://www.blockfoundation.io). All rights reserved.

### License

Except as otherwise noted, the content in this repository is licensed under the
[Creative Commons Attribution 4.0 International (CC BY 4.0) License](https://creativecommons.org/licenses/by/4.0/), and
code samples are licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

Also see [LICENSE](https://github.com/block-foundation/community/blob/master/LICENSE) and [LICENSE-CODE](https://github.com/block-foundation/community/blob/master/LICENSE-CODE).

### Warning

**Please note that this code should be audited by a professional smart-contract auditor before being used in a production environment as it is a simplified example and may not cover all potential security vulnerabilities.**

### Disclaimer

**THIS SOFTWARE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.**
