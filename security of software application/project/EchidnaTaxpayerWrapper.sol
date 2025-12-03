// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "./Taxpayer.sol";

// Wrapper that provides fixed constructor arguments so Echidna can deploy the contract
contract EchidnaTaxpayer is Taxpayer {
    constructor() Taxpayer(address(0x1), address(0x2)) {}
}
