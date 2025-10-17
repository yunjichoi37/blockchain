// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;


// Polymorphism(다형성): child 객체를 parent 타입으로 참조하는 것.
// 특정 코드 구현에 덜 의존하기 때문에 좋다.
contract Animal {
    function getName() public pure virtual returns(string memory) {
        return "Animal";
    }
}

contract Tiger is Animal {
    function getName() public pure override returns(string memory) {
        return "Tiger";
    }
}

contract Turtle is Animal {
    function getName() public pure override returns(string memory) {
        return "Turtle";
    }
}

contract AnimalSet {
    Animal public tiger = new Tiger();
    Animal public turtle = new Turtle();

    function getAllNames() public view returns(string memory, string memory) {
        return (tiger.getName(), turtle.getName());
    }

    function whatIsTheName(Animal _animal) public pure returns(string memory) {
        return (_animal.getName());
    }
}