// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract TestTransfer {

    function send(uint256 num, address payable _to) public payable returns (bool) {
       bool ok = _to.send(num);
       return ok;
    }
    function send2(address payable _to) public payable returns (bool) {
       bool ok = _to.send(msg.value);
       return ok;
    }
    function test_bytes(bytes memory arg, bytes1 arg2) public pure returns (bytes memory) {
       return arg;
    }
}