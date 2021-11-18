# 简介

> web3.swift的库在GitHub上有很多，调用的例子也有，但似乎比较少有关于abi和hex转换的。在朋友的帮助下，我们调通了abi部分的set和get。demo仅作为测试学习使用。

# 注意事项

> 1、该demo的XCode版本为13.1，web3库使用的是Boilertalk的[web3.swift](https://github.com/Boilertalk/Web3.swift)。SPM的导入可能比较慢或超时，可以先清理下XCode各种缓存后再试试。

![package.png](/Images/package.png)

> 2、智能合约的环境部署参考这里：[传送门](https://blog.csdn.net/wumingzhifu/article/details/106329147)。demo的合约内容简单，需要注意的是区分好合约地址和账户地址。

![address.png](/Images/address.png)

> 3、关于ABI的Json格式，可以从第二点的工具里面去直接复制出来，方便快捷。

![abistr.png](/Images/abistr.png)

> 4、以下为set和get部分的测试代码，更多内容详见demo。

```ruby
var abi = ""

// ***** set *****
do {
    let signature = "0x" + String("setName(string)".sha3(.keccak256).prefix(8))
    let encoded = try ABI.encodeParameters([.string("abc")])
    abi = signature + encoded.replacingOccurrences(of: "0x", with: "")
} catch {

}

let setTran = EthereumTransaction(nonce: nil, gasPrice: nil, gas: nil, from: accountAddress!, to: contractAddress!, value: nil, data: EthereumData(abi.hexToBytes()))
contract?.send(setTran, completion: { ethData, err in
    print("send dic: \(String(describing: ethData))")
    print("send err: \(String(describing: err))")
})

// ***** get *****
do {
    let signature = "0x" + String("getName()".sha3(.keccak256).prefix(8))
    let encoded = try ABI.encodeParameter(.string(""))
    abi = signature + encoded.replacingOccurrences(of: "0x", with: "")
} catch {

}

let outputs = [SolidityFunctionParameter(name: "name", type: .string, components: nil)]
let getCall = EthereumCall(from: accountAddress!, to: contractAddress!, gas: nil, gasPrice: nil, value: nil, data: EthereumData(abi.hexToBytes()))
contract?.call(getCall, outputs: outputs, completion: { dict, err in
    print("getName ddd: \(String(describing: dict))")
    print("getName err: \(String(describing: err))")
})
```
