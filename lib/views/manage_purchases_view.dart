import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../models/models.dart';

class ManagePurchaseView extends StatelessWidget {
  const ManagePurchaseView({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Manage Purchases"),
      ),
      body: Consumer<PurchaseModel>(
        builder: (context, model, child) {
          return model.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: model.items.length,
                  itemBuilder: (context, index) {
                    final purchase = model.items[index];

                    return ListTile(
                      title: Text(purchase.product.name),
                      subtitle: Column(
                        children: [
                          Text(purchase.product.description),
                          Text(format(purchase.createdAt)),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Text("Cancel"),
                          ),
                          const PopupMenuItem(
                            child: Text("Dispute"),
                          ),
                          const PopupMenuItem(
                            child: Text("Report"),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
