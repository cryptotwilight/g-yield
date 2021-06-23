[
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_yieldProtocol",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_txRef",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_cancellationFee",
				"type": "uint256"
			}
		],
		"name": "cancelYieldRequest",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_txnRef",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_cancellationDate",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_principalReturned",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_earningsReturned",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAcceptedERC20",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_erc20s",
				"type": "address[]"
			},
			{
				"internalType": "string[]",
				"name": "_erc20Names",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getRegisteredProtocols",
		"outputs": [
			{
				"internalType": "string[]",
				"name": "_protocol",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "_protocolWebsite",
				"type": "string[]"
			},
			{
				"internalType": "bool[]",
				"name": "_enabled",
				"type": "bool[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_yieldProtocol",
				"type": "string"
			}
		],
		"name": "getUserTransactionsForProtocol",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_txRefs",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_principle",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_yieldRequestDates",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_yieldProtocol",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_principal",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_yieldPercentage",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_term",
				"type": "uint256"
			}
		],
		"name": "requestYield",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_txnRef",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_deliveryDate",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_yieldProtocol",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_txRef",
				"type": "uint256"
			}
		],
		"name": "reviewYield",
		"outputs": [
			{
				"internalType": "string",
				"name": "_protocol",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_principal",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_yieldPercentage",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_term",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_deliveryDate",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_earnedToDate",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_yieldProtocol",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_txRef",
				"type": "uint256"
			}
		],
		"name": "withdrawYield",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_principalReturned",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_earningsReturned",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	}
]