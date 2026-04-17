import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import 'onboarding_screen.dart';
import 'dashboard_screen.dart';

class TawHomeScreen extends StatelessWidget {
  const TawHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.sort, color: Colors.black, size: 30),
        actions: [
          const Icon(Icons.search, color: Colors.black, size: 28),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_none, color: Colors.black, size: 28),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.alert,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 22, color: AppColors.textMain, fontWeight: FontWeight.normal),
                children: [
                  const TextSpan(text: "Bienvenue, "),
                  TextSpan(
                    text: user?.name ?? "Utilisateur",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mon solde", style: TextStyle(color: AppColors.primaryValue, fontSize: 13)),
                      Row(
                        children: const [
                          Text("Historique des transactions", style: TextStyle(color: AppColors.primaryValue, fontSize: 13)),
                          Icon(Icons.chevron_right, color: AppColors.primaryValue, size: 16),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user?.balance.toStringAsFixed(0)} TND",
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                      const Icon(Icons.remove_red_eye_outlined, color: AppColors.primaryValue, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Recharger
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.primaryValue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Recharger mon wallet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Envoyer
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.secondaryValue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.send_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Envoyer de l'argent", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text("Nos services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 24,
              alignment: WrapAlignment.start,
              children: [
                _buildServiceIcon(Icons.phone_android, "RC téléphonique\net internet"),
                _buildServiceIcon(Icons.money_off, "Retrait"),
                _buildServiceIcon(Icons.receipt_long, "Paiement de\nfacture"),
                _buildServiceIcon(Icons.assured_workload, "Paiement\nmicro-crédit"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildZidServiceIcon(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primaryValue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.home_outlined, color: Colors.white, size: 30),
              const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
              const SizedBox(width: 48), // Space for FAB
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 30),
              const Icon(Icons.description_outlined, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Icon(Icons.storefront, color: AppColors.alert),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildServiceIcon(IconData icon, String label) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: AppColors.alert, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildZidServiceIcon() {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryValue.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryValue, width: 2),
            ),
            child: const Icon(Icons.savings, color: AppColors.primaryValue, size: 32),
          ),
          const SizedBox(height: 8),
          const Text("Zid\nÉpargne", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.2, color: AppColors.primaryValue)),
        ],
      ),
    );
  }
}
