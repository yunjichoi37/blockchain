// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// enum: uint8 범위(0~255)
contract Ex6_09 {
    event Information(string info);

    // status machine에 많이 쓰인다.
    // 함수의 실행 상태를 통제할 수 있다.
    enum FoodProcess {
        order,
        takeAway,
        delivery,
        payment
    }

    FoodProcess public foodStatus;

    constructor() {
        foodStatus = FoodProcess.payment;
    }
    
    function orderFood() public {
        require(foodStatus == FoodProcess.payment, "It must be the payment status");
        foodStatus = FoodProcess.order;
        emit Information("Order success");
    }
    function takeAwayFood() public {
        require(foodStatus == FoodProcess.order, "It must be the order status");
        foodStatus = FoodProcess.takeAway;
        emit Information("takeAway success");
    }
    function deliveryFood() public {
        require(foodStatus == FoodProcess.takeAway, "It must be the takeAway status");
        foodStatus = FoodProcess.delivery;
        emit Information("delivery success");
    }
    function paymentFood() public { // 아래처럼 숫자로 써도 되지만 가독성이 별로다.
        require(foodStatus == FoodProcess(2), "It must be the delivery status");
        foodStatus = FoodProcess.payment;
        emit Information("payment success");
    }
}