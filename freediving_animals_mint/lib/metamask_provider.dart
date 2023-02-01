import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/ethereum.dart';

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
