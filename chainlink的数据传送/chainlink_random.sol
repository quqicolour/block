// SPDX-License-Identifier: MIT
// 依赖订阅资金的消费者合同示例。
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract VRFv2Consumer is VRFConsumerBaseV2 {
  VRFCoordinatorV2Interface COORDINATOR;
  LinkTokenInterface LINKTOKEN;

  // 您的订阅 ID。
  uint64 s_subscriptionId;

  // Rinkeby协调员。对于其他网络，
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

  // Rinkeby LINK令牌合约。对于其他网络
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  address link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

  // 要使用的汽油通道，它指定要达到的最高汽油价格
  // 想要每个网络的可用燃气通道列表
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

  // 取决于您要发送到的请求值的数量
  // fulfillRandomWords()函数。储存每个单词要花费2万汽油,
  // 所以 100,000 是这个示例合约的安全默认值。测试和调整
  // 此限制基于您选择的网络、请求的大小、
  // 并且取决于在fulfillRandomWords()函数中的回调请求
  uint32 callbackGasLimit = 100000;

  // 默认值是3，但可以将其设置得更高一些。
  uint16 requestConfirmations = 3;

  // 对于本例，在一个请求中检索2个随机值。
  // 不能超过VRFCoordinatorV2.MAX_NUM_WORDS
  uint32 numWords =  2;

  uint256[] public s_randomWords;
  uint256 public s_requestId;
  address s_owner;

  constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    LINKTOKEN = LinkTokenInterface(link);
    s_owner = msg.sender;
    s_subscriptionId = subscriptionId;
  }

  // 假设认购资金充足
  function requestRandomWords() external onlyOwner {
    // Will revert if subscription is not set and funded.
    s_requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
  }
  
  function fulfillRandomWords(
    uint256, /* requestId */
    uint256[] memory randomWords
  ) internal override {
    s_randomWords = randomWords;
  }

  modifier onlyOwner() {
    require(msg.sender == s_owner);
    _;
  }
}

