// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex6_091 {
    event Information(string info);
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

    modifier check(FoodProcess pre_status) {
        require(foodStatus == pre_status, "It must be the failure status");
        _;
    }

    function Order() public check(FoodProcess.payment) {
        foodStatus = FoodProcess.order;
        emit Information("order");
    }
    function TakeAway() public check(FoodProcess.order) {
        foodStatus = FoodProcess.takeAway;
        emit Information("takeAway");
    }
    function Delivery() public check(FoodProcess.takeAway) {
        foodStatus = FoodProcess.delivery;
        emit Information("delivery");
    }
    function Payment() public check(FoodProcess.delivery) {
        foodStatus = FoodProcess.payment;
        emit Information("payment");
    }
}