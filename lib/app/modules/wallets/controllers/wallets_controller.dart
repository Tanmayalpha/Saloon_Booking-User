import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../repositories/payment_repository.dart';

class WalletsController extends GetxController {
  final wallets = <Wallet>[].obs;
  final loading = false.obs;
  final walletTransactions = <WalletTransaction>[].obs;
  final selectedWallet = new Wallet().obs;
  PaymentRepository _paymentRepository;

  WalletsController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    await refreshWallets();
    super.onInit();
  }

  Future refreshWallets({bool showMessage}) async {
    await getWallets();
    initSelectedWallet();
    await getWalletTransactions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of wallets refreshed successfully".tr));
    }
  }
  Future getWallets() async {
    loading.value = true;
    try {
      wallets.assignAll(await _paymentRepository.getWallets());
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getWalletTransactions() async {
    loading.value = true;
    try {
      walletTransactions.assignAll(await _paymentRepository.getWalletTransactions(selectedWallet.value));
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initSelectedWallet() {
    if (!selectedWallet.value.hasData && wallets.isNotEmpty) {
      selectedWallet.value = wallets.elementAt(0);
    }
  }
}
