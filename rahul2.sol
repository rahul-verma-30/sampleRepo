"// SPDX-License-Identifier: MIT 
        pragma solidity 0.8.4;
        interface IERC165 {
        
            function supportsInterface(bytes4 interfaceId) external view returns (bool);
            }
        interface IERC721 is IERC165 {
        
            event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
            event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
            event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
            function balanceOf(address owner) external view returns (uint256 balance);
            function ownerOf(uint256 tokenId) external view returns (address owner);
            function safeTransferFrom(
                address from,
                address to,
                uint256 tokenId,
                bytes calldata data
            ) external;
            function safeTransferFrom(
                address from,
                address to,
                uint256 tokenId
            ) external;
        
            function transferFrom(
                address from,
                address to,
                uint256 tokenId
            ) external;
            function approve(address to, uint256 tokenId) external;
        
            function setApprovalForAll(address operator, bool _approved) external;
            function getApproved(uint256 tokenId) external view returns (address operator);
            function isApprovedForAll(address owner, address operator) external view returns (bool);
            }
        abstract contract Context {
            function _msgSender() internal view virtual returns (address) {
                return msg.sender;
                }
            function _msgData() internal view virtual returns (bytes calldata) {
                return msg.data;
                }
            }
        abstract contract Ownable is Context {
            address private _owner;
            event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
            constructor() {
                _transferOwnership(_msgSender());
                }
            function owner() public view virtual returns (address) {
                return _owner;
                }
            modifier onlyOwner() {
                require(owner() == _msgSender(),
                    "Ownable: caller is not the owner");
                _;
                }
            function transferOwnership(address newOwner) public virtual onlyOwner {
                require(newOwner != address(0),
                    "Ownable: new owner is the zero address");
                _transferOwnership(newOwner);
                }
            function _transferOwnership(address newOwner) internal virtual {
                address oldOwner = _owner;
                _owner = newOwner;
                emit OwnershipTransferred(oldOwner, newOwner);
                }
            }
        contract MetaDripsRefund is Ownable {
            address public nftAddress;
            address public burnerAddress;
            uint256[] public prices = [
                    0,
                    0.5 ether,
                    1 ether,
                    3 ether
                ];
            mapping(uint => uint) public tier;
            constructor(
                address _nftAddress,
                address _burnerAddress
            ) {
                nftAddress = _nftAddress;
                burnerAddress = _burnerAddress;
                }
            function refund(uint[] calldata _ids) public payable {
                uint256 amount = 0;
                for(uint i; i< _ids.length; i++) {
                    amount += prices[tier[_ids[i
                                ]
                            ]
                        ];
                    IERC721(nftAddress).transferFrom(msg.sender, burnerAddress, _ids[i
                        ]);
                    }
                bool success = payable(msg.sender).send(amount);
                require(success,
                    "Something went wrong");
                }
            function setIDs(uint _id, uint _tier) external onlyOwner() {
                tier[_id
                    ] = _tier;
                }
            function receiveETH() public payable {}
            function withdrawAll() external onlyOwner() {
                address payable to = payable(msg.sender);
                to.transfer(address(this).balance);
                }
            }"
