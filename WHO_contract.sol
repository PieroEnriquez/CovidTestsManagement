//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract WHO_contract{

    //Setting the contract owner
    address public WHO;

    constructor(){
        WHO = msg.sender;
    }

    //Mapping to relate the clinics with the validation given by the WHO
    mapping(address => bool) validClincs;

}

