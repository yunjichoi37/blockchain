// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// ERC721는 ID랑 소유권만 저장하고 있다.
// 실제 데이터는 다른 곳에 저장된다.
// token의 실제가 어디에 있는지 나타내는 URI(metadata)

// 세폴리아 실패하려면 이더를 받아와야 된대
// 이더를 어케 받지??

interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns(bool);
}

interface ERC721 is ERC165 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns(uint256);
    function ownerOf(uint256 _tokenId) external view returns(address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns(address);
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);
}

interface ERC721TokenReceiver {
    function onERC721Received (address _operator, address _from, 
        uint256 _tokenId, bytes memory _data) external returns(bytes4);
}

contract ERC721StdNFT is ERC721 {

    bytes4 private constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    address public founder;
    mapping (uint => address) internal _ownerOf; // tokenId -> owner: 각 NFT의 사용자 주소
    mapping (address => uint) internal _balanceOf; // owner -> number of NFTs: 특정 주소가 보유한 NFT 개수
    mapping (uint => address) internal _approvals; // tokenId -> approved: 특정 NFT를 대신 전송할 권리를 부여받은 주소 저장
    mapping (address => mapping (address => bool)) internal _operatorApprovals; // 특정 주소가 소유자의 모든 NFT를 관리할 권한이 있는지

    string public name;
    string public symbol;

    constructor (string memory _name, string memory _symbol) {
        founder = msg.sender;
        name = _name;
        symbol = _symbol;

        for (uint tokenID = 1; tokenID <= 5; tokenID++) { // 1~5번 tokenID는 배포자에게 자동 발행
            _mint(msg.sender, tokenID);
        }
    }

    // 새 토큰을 발행하기 위한 내부 함수
    function _mint(address to, uint id) internal {
        require(to != address(0), "mint to zero address"); // 0으로 보내면 토큰이 없어지기 때문에 검사해야 함.
        require(_ownerOf[id] == address(0), "already minted"); // 유일하기 때문에 하나만 발행되어야 함.

        _balanceOf[to]++; // to의 balance를 1 올려준다.
        _ownerOf[id] = to; // 토큰의 주소를 설정해준다.

        emit Transfer(address(0), to, id); // from 주소를 0으로 하고 이벤트 발생: 새로 생겼다고 알려주기.
    }

    function mintNFT(address to, uint256 tokenID) public {
        require(msg.sender == founder, "not an authorized minter"); // founder만 토큰을 만들 수 있다.
        _mint(to, tokenID); // 실제 발행하는 함수 호출
    }

    function ownerOf(uint256 _tokenId) external view returns(address) {
        address owner = _ownerOf[_tokenId]; // tokenID의 현재 소유자 주소를 반환한다.
        require(owner != address(0), "token doesn't exist");
        return owner;
    }

    function balanceOf(address _owner) external view returns(uint256) {
        require(_owner != address(0), "balance query for the zero address");
        return _balanceOf[_owner]; // owner가 보유하고 있는 NFT 개수 반환
    }

    function getApproved(uint256 _tokenId) external view returns(address) {
        require(_ownerOf[_tokenId] != address(0), "token doesn't exist");
        return _approvals[_tokenId]; // 해당 tokenId에 대한 전송 권한이 있는 주소 반환
    }

    function isApprovedForAll(address _owner, address _operator) external view returns(bool) {
        return _operatorApprovals[_owner][_operator]; // owner가 operater에게 전체 NFT 전송 권한을 줬는지 여부를 반환한다.
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        address owner = _ownerOf[_tokenId];
        require(
            msg.sender == owner || _operatorApprovals[owner][msg.sender], // 토큰 소유자/승인된 운영자만 호출 가능
            "not authorized"
        );

        _approvals[_tokenId] = _approved; // tokenId에 대해 전송 권한을 approvals에 위임한다.
        emit Approval(owner, _approved, _tokenId); // owner가 _tokenId의 전송권한을 _approved에 위임한다.
    }

    function setApprovalForAll(address _operator, bool _approved) external { 
        _operatorApprovals[msg.sender][_operator] = _approved; // operator 주소에 대해 msg.sender의 모든 NFT 전송 권한을 부여하거나 해제한다.
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        _transferFrom(_from, _to, _tokenId); // 권한이 있을 경우 _from이 _to로 NFT를 직접 전송한다.
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) private {
        address owner = _ownerOf[_tokenId];
        require(_from == owner, "from != owner"); // from과 owner가 같아야 한다.
        require(_to != address(0), "transfer to zero address"); // to가 유효해야 한다.

        require(msg.sender == owner // 소유자거나, 위임이 승인된 주소거나, 운영자여야 한다.
                || msg.sender == _approvals[_tokenId]
                || _operatorApprovals[owner][msg.sender]);
         
        _balanceOf[_from] -= 1; // _from의 NFT 개수를 1 감소시킨다.
        _balanceOf[_to] += 1; // _to의 NFT 개수를 1 증가시킨다.
        _ownerOf[_tokenId] = _to; // 해당 token의 주인을 to로 설정해준다.
        _approvals[_tokenId] = address(0); // 위임 정보를 초기화해준다.
        emit Transfer(_from, _to, _tokenId); // from이 to에게 tokenId를 주었다.
    }

    // 아래 함수(_safe~)를 safe~ 함수 내부에서 호출하게 만들었다. 권한 체크를 정상적으로 동작할 수 있게 만든다.
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) internal {
        _transferFrom(_from, _to, _tokenId); // 일단 보낸다.

        require( 
            _to.code.length == 0 || // _to가 EOA인지 확인한다.
            ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data) // 안전하게 처리할 수 있는지 확인
                == ERC721TokenReceiver.onERC721Received.selector, // selector면 안전하다.
            "unsafe recipient" // 안전하지 않다고 알려주기.
        );
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable {
        _safeTransferFrom(_from, _to, _tokenId, data);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        // this.safeTransferFrom(_from, _to, _tokenId, bytes("")); // 바로 위의 함수를 this로 활용해보려 했으나, 
        _safeTransferFrom(_from, _to, _tokenId, bytes("")); // msg.sender가 바뀌는 문제가 발생하여 revert되는 오류가 생겨 this를 쓰는 대신 _safe함수를 만들어 호출하였음.
    }

    function supportsInterface(bytes4 interfaceId) external pure returns(bool) {
        return 
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(ERC165).interfaceId;
    }
}