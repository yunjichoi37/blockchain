// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract NameRegistry {
    struct ContractInfo {
        address contractOwner; // 컨트랙트 소유자 주소
        address contractAddress; // 컨트랙트 주소
        string description; // 컨트랙트에 대한 설명
    }

    uint public numContracts;

    mapping (string => ContractInfo) public registeredContracts; // 컨트랙트 name으로 mapping하기
        
    event ContractRegistered(string _name); // contract가 등록됨을 알리는 event
    event ContractDeleted(string _name); // contract가 삭제됨을 알리는 event
    event ContractUpdated(string _name, string _what); // contract가 변경됨을 알리는 event

    modifier onlyOwner(string memory _name) { // _name이라는 contract의 소유자만 접근할 수 있도록 제한하는 modifier
        require(registeredContracts[_name].contractOwner == msg.sender, "You are not the owner of this contract.");
        _;
    }

    constructor() {
        numContracts = 0; // 등록된 contract의 수를 0으로 초기화한다.
    }

    // 아직 등록되지 않은 contract라면 새로 등록해주는 함수이다.
    function registerContract(string memory _name, address _contractAddress, string memory _description) public {
        // 이미 등록되었는지 확인하는 기준은 _name이다. _name에 해당하는 주소가 NULL이 아니면 contract가 존재한다는 뜻이기 때문에 require
        require(registeredContracts[_name].contractAddress == address(0), "this name is already exist.");
        registeredContracts[_name] = ContractInfo(msg.sender, _contractAddress, _description); // mapping을 이용해 등록해준다.
        numContracts += 1; // 등록된 contract 수를 1 올려준다.
        emit ContractRegistered(_name); // _name이라는 contract가 등록되었다고 event를 발생시킨다.
    }

    // 등록된 contract를 삭제하는 함수이다. 소유자만 가능하다.
    function unregisterContract(string memory _name) public onlyOwner(_name) {
        // require(registeredContracts[_name].contractAddress != address(0), "this name is not exist.");
        // 위 코드가 없어도 되는 이유는, modifier에서 _name에 해당하는 소유자를 검증해주기 때문이다.
        delete(registeredContracts[_name]); // delete를 사용해 없애준다.
        numContracts -= 1; // 등록된 contract 수를 1 내려준다.
        emit ContractDeleted(_name); // _name이라는 contract가 삭제되었다고 event를 발생시킨다.
    }

     // contract의 소유자를 변경하는 함수이다. 소유자만 가능하다.
    function changeOwner(string memory _name, address _newOwner) public onlyOwner(_name) {
        require(_newOwner != address(0), "New Owner's Address is NULL!!!"); // new Owner가 null인 경우를 방지해준다.
        registeredContracts[_name].contractOwner = _newOwner; // 소유자를 변경해준다.
        emit ContractUpdated(_name, "Contract Owner"); // _name의 소유자가 바뀌었음을 "Contract Owner"라는 메시지로 알려준다.
    }

    function getOwner(string memory _name) public view returns(address) {
        return registeredContracts[_name].contractOwner; // 컨트랙트 소유자의 정보를 확인한다.
    }

    // contract의 address를 변경하는, 소유자만 사용할 수 있는 함수이다.
    function setAddr(string memory _name, address _addr) public onlyOwner(_name) {
        registeredContracts[_name].contractAddress = _addr; // 주소를 변경해준다.
        emit ContractUpdated(_name, "Contract Address"); // _name의 주소가 바뀌었음을 "Contract Address"라는 메시지로 알려준다.
    }

    function getAddr(string memory _name) public view returns(address) {
        return registeredContracts[_name].contractAddress; // 컨트랙트 주소 정보를 확인한다.
    }

    // contract의 설명을 변경하는 함수이다. 소유자만 가능하다.
    function setDescription(string memory _name, string memory _description) public onlyOwner(_name) {
        registeredContracts[_name].description = _description; // 설명을 변경해준다.
        emit ContractUpdated(_name, "Contract Description"); // _name의 설명이 바뀌었음을 "Contract Description"이라는 메시지로 알려준다.
    }

    function getDescription(string memory _name) public view returns(string memory) {
        return registeredContracts[_name].description; // 컨트랙트 설명을 확인한다.
    }
}