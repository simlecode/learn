// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract BlockTest {
    function getBlockhashPrevious() public view returns (bytes32) {
        return blockhash(block.number-1);
    }

    function getBlockNumber2(uint256[] memory a) public pure returns (uint256){
        return a[0]+1;
    }

    function getBlockNumber() public view returns (uint256){
        return block.number;
    }
    function getTimestamp() public view returns (uint256){
        return block.timestamp;
    }
}
