import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class MetaMaskProvider extends ChangeNotifier {
  // Ethereum chain
  //static const operatingChain = 4;
  // Mumbai chain
  static const operatingChain = 80001;
  String currentAddress = '';
  var account = "";
  int currentChain = -1;
  bool get isEnabled => ethereum != null;
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      currentChain = await ethereum!.getChainId();
      if (isInOperatingChain) {
        debugPrint("Correct chain: " + currentChain.toString());
        account = accs[0];
        if (accs.isNotEmpty) currentAddress = accs.first;
        debugPrint("Account: " + currentAddress);
        notifyListeners();
        //NFTContract nftContractInstance = NFTContract();
      } else {
        debugPrint("Wrong Chain!");
      }
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((accounts) {
        clear();
      });
    }
  }
}

Future<String> mintRequest() async {
  debugPrint("Enter mintRequest()");
  await dotenv.load(fileName: ".env");

  final String collectionAddress = dotenv.env['COLLECTION_ADDRESS'].toString();
  final contractABI = dotenv.env['ABI'].toString();
  debugPrint("Data loaded from .env: " + collectionAddress + contractABI);

  //Create NFT contract instance
  NFTContract nftContractInstance = NFTContract(
      collectionAddress: collectionAddress, contractABI: contractABI);
  debugPrint("NFT contract instance created");

  //Mint NFT
  final mint_response =
      nftContractInstance._mintNFT(collectionAddress, contractABI);

  debugPrint("Mint response: " + mint_response.toString());

  return mint_response;
}

class NFTContract {
  String collectionAddress;
  dynamic contractABI;
  late Contract contractInstance;

  NFTContract({required this.collectionAddress, required this.contractABI}) {
    debugPrint("Class properties: " + collectionAddress + contractABI);
    createContractInstance();
  }

  void createContractInstance() {
    debugPrint("createContractInstance() started");
    contractInstance =
        Contract(collectionAddress, contractABI, provider?.getSigner());
    debugPrint("createContractInstance() finished");
  }

  Future<String> _mintNFT(String collectionAddress, String contractABI) async {
    //Send the function and data to interact with the contract
    final transaction = await contractInstance.send('mint', []);

    //Getting the receipt from the transaction
    final receipt = await transaction.wait();

    //Returning the transaction hash
    return receipt.transactionHash;
  }
}
