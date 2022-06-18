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

    //Mapping to relate a clinic to its contract
    mapping(address => address) clinicContract;

    //Addresses array for the contracts of validated clinics
    address[] public contractsValidatedClinics;

}

