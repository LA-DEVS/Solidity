// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyFirstContract{
    string value;
    constructor () {
    value = "myValue";
}
    function get() public view returns(string storage) {
        return  value;
    }
    function set(string calldata _value) public{
        value = _value ;
    }

}
//https://docs.soliditylang.org/en/v0.8.7/types.html#value-types
//https://blockgeeks.com/introduction-to-solidity-part-1/
//https://www.dappuniversity.com/articles/solidity-tutorial
//https://www.ionos.de/digitalguide/websites/web-entwicklung/solidity-programmiersprache/
