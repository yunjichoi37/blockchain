// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// delete <array name> : 전체를 없앤다.
// super: parent contract의 함수를 호출한다.
// super.parentFunc()의 형태로 사용하면 된다.

contract Student {
    string [] internal courses;
    function showCourses() public virtual returns(string[] memory) {
        delete courses;
        courses.push("English");
        courses.push("Music");
        return courses;
    }
}

contract ArtStudent is Student {
    function showCourses() public override returns(string[] memory) {
        super.showCourses();
        courses.push("Art");
        return courses;
    }
}