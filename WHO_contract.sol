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
    mapping(address => bool) validClinics;

    //Mapping to relate a clinic to its contract
    mapping(address => address) clinicsContracts;

    //Addresses' array for the contracts of validated clinics
    address[] public contractsValidatedClinics;

    //Addresses' array for requests from clinics to be part of the system
    address[] requests;

    //Events
    event requestAccess(address);
    event newValidatedClinic(address);
    event newContract(address, address);

    //Modifier for only WHO to run a function
    modifier onlyWHO(address _who){
        require(_who == WHO, "You are not allowed to run this function");
        _;
    }

    //Function to apply for accessing the clinic system
    function applyAccess() public{
        requests.push(msg.sender);
        emit requestAccess(msg.sender);
    }

    //Function to visualize the addresses that applied
    function seeApplies() onlyWHO(msg.sender) public view returns(address[]memory){
        return requests;
    }

    //Function to enable a clinic for auto management. For so, we need to set the clinic validation to true and emit the validation event
    function newClinic() public onlyWHO(msg.sender){
        validClinics[msg.sender] == true;
        emit newValidatedClinic(msg.sender);
    }

    /*
    Now we need to create a factory to generate a new contract for each validated clinic by filtering through the mapping
    Finally, we relate the clinic's address with their contract's address and save it in the mapping
    */
    function clinicFactory() public{
        require(validClinics[msg.sender] == true, "You are not a validated clinic");
        address clinicContract = address (new Clinic(msg.sender));
        clinicsContracts[msg.sender] = clinicContract;
    }


}

//Clinics' contract for management
contract Clinic{

    address public clinicContract;
    address public thisContract;

    constructor(address _address){
        clinicContract = _address;
        thisContract = address(this);
    }

    //Mapping to relate someone's hash with their results: diagnosis and IPFS code
    mapping(bytes32 => Results) covidResults;

    //Struct for the results
    struct Results{
        bool diagnosis;
        string IPFScode;
    }

    //Events
    event newResult(string, bool);

    //Modifier for only the clinic to run a function
    modifier onlyClinic(address _clinic){
        require(_clinic == clinicContract, "You are not allowed to run this function");
        _;
    }

    //Function to publish a covid test result by relating the struct Result with the client id
    function resultCovidTest(string memory _id, bool _result, string memory _IPFScode) public onlyClinic(msg.sender){
        //Frist we get the hash of client's id
        bytes32 hashID = keccak256(abi.encodePacked(_id));
        covidResults[hashID] = Results(_result, _IPFScode);
        emit newResult(_IPFScode, _result);
    }

    //Function to visualize your results from your id
    function myResults(string memory _id) public view returns(string memory, string memory){
        //Getting the client's id's hash
        bytes32 hashID = keccak256(abi.encodePacked(_id));
        //Giving back a boolean as a string
        string memory result;
        if(covidResults[hashID].diagnosis == true){
            result = "Positive";
        } else {
            result = "Negative";
        }

        return(result, covidResults[hashID].IPFScode);
    }

}

