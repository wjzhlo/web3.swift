//
//  ViewController.swift
//  ETHS
//
//  Created by Jero on 2021/11/11.
//

import UIKit
import Web3
import Web3ContractABI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let web3 = Web3(rpcURL: "http://127.0.0.1:7545")
        
        // 服务器版本（测试链接是否连接成功）
        web3.clientVersion { resp in
            print("clientVersion: \(resp)")
        }

        // 合约地址
        let contractAddress = try? EthereumAddress(hex: "0x46Dc1C4b2A1dE1BD46c8D6695a7DFA9C3A78290F", eip55: true)

        // 账户地址
        let accountAddress = try? EthereumAddress(hex: "0xeC27220a469cb1b6846f6049d2AeB630195213fa", eip55: true)
        
        // 查看账户余额（测试账户是否连接成功）
        web3.eth.getBalance(address: accountAddress!, block: .latest) { response in
            print("getBalance:\(String(describing: response))")
        }
        
        // ***** ABI *****
        let abiStr = """
    [{\"inputs\":[{\"internalType\":\"string\",\"name\":\"_name\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getName\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"string\",\"name\":\"_name\",\"type\":\"string\"}],\"name\":\"setName\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]
"""
        let abiData = abiStr.data(using: .utf8)
        let contract = try? web3.eth.Contract(json: abiData!, abiKey: nil, address: contractAddress)
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
    }
}


