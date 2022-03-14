// SPDX-License-Identifier: MIT
// 该许可证允许任何人使用该代码
// 该合约用于个人喜欢的数字存储
pragma solidity >=0.6.0 <0.9.0;
contract SimpleStorage{
uint256 likeNumber;
bool likeBool;

struct People{
uint256 likeNumber;
string name;
} 
People[] public people;
// 将string映射到uint256公开的nameTolikeNumebr
mapping(string => uint256) public nameTolikeNumebr;

function store(uint256 _likeNumber) public {
likeNumber=_likeNumber;
}
// 定义一个只读的函数，它将是公共的返回Uint56属性的likeNumber
function retrieve() public view returns(uint256){
return likeNumber;
}

function addPerson(string memory _name,uint256 _likeNumber)public{
people.push(People(_likeNumber,_name));
nameTolikeNumebr[_name]=_likeNumber;
}
}