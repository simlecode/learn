// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract SimpleStorage {
    uint storedData;

    function setStorage(uint x) public {
        storedData = x;
    }

    function getStorage() public view returns (uint) {
        return storedData;
    }
}