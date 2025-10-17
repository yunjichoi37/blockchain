// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

import "./Ex6_10_1.sol";
import "./in/Ex6_10_2.sol";

contract Alice is ArtStudent, PartTimer {
    uint public totalHours = schoolHours + workingHours;
}