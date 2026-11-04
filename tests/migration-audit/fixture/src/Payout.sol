// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Payout {
    address payable to;

    function payInline(uint256 amt) external {
        payable(msg.sender).transfer(amt);
    }

    function payStored(uint256 amt) external {
        to.transfer(amt);
    }

    function payWithSend(address who, uint256 amt) external {
        payable(who).send(amt);
    }

    function decoys(address who, uint256 amt) external payable {
        IERC20(usdc).transfer(who, amt);
        token.transfer(who, amt);
        (bool ok, ) = payable(who).call{value: amt}("");
        require(msg.value == amt);
    }
}
