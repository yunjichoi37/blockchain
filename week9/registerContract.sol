// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract NameRegistry {
    struct ContractInfo {
        address contractOwner;
        address contractAddress;
        string description;
    }

    uint public numContracts;
    string[] contractNames;

    mapping (string => ContractInfo) public registeredContracts;
    
    event ContractRegistered(string _name);
    event ContractDeleted(string _name);
    event ContractUpdated(string _name, string _what);

    modifier onlyOwner(string memory _name) {
        require(registeredContracts[_name].contractOwner == msg.sender, "You are not the owner of this contract.");
        _;
    }

    constructor() {
        numContracts = 0;
    }

    function registerContract(string memory _name, address _contractAddress, string memory _description) public {
        require(registeredContracts[_name].contractAddress == address(0), "this name is already exist.");
        registeredContracts[_name] = ContractInfo(msg.sender, _contractAddress, _description);
        emit ContractRegistered(_name);
    }

    function unregisterContract(string memory _name) public onlyOwner(_name) {
        // require(registeredContracts[_name].contractAddress != address(0), "this name is not exist.");
        delete(registeredContracts[_name]);
        emit ContractDeleted(_name);
    }

    function changeOwner(string memory _name, address _newOwner) public onlyOwner(_name) {
        require(_newOwner != address(0), "New Owner's Address is NULL!!!");
        registeredContracts[_name].contractOwner = _newOwner;
        emit ContractUpdated(_name, "Contract Owner");
    }

    function getOwner(string memory _name) public view returns(address) {
        return registeredContracts[_name].contractOwner;
    }

    function setAddr(string memory _name, address _addr) public onlyOwner(_name) {
        registeredContracts[_name].contractAddress = _addr;
        emit ContractUpdated(_name, "Contract Address");
    }

    function getAddr(string memory _name) public view returns(address) {
        return registeredContracts[_name].contractAddress;
    }

    function setDescription(string memory _name, string memory _description) public onlyOwner(_name) {
        registeredContracts[_name].description = _description;
        emit ContractUpdated(_name, "Contract Description");
    }

    function getDescription(string memory _name) public view returns(string memory) {
        return registeredContracts[_name].description;
    }

    // function getAllContractNames() public returns(string[] memory) {
    //     for 
    // }
}