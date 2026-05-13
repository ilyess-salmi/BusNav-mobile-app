import 'package:flutter/material.dart';

import 'bus_line_card.dart';

class NearbyBusSheet extends StatelessWidget {
  final void Function(double offset) onScroll;

  const NearbyBusSheet({
    super.key,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.12,
      maxChildSize: 0.75,
      snap: true,
      snapSizes: const [0.12, 0.28, 0.75],
      builder: (context, sheetScrollController) {
        sheetScrollController.addListener(
          () => onScroll(sheetScrollController.offset),
        );

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F0FD),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: sheetScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          const Text(
                            'Nearby Bus Lines',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E2FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xFFB247FF),
                                  size: 13,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Near you',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFB247FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    const [
                      BusLineCard(
                        line: 'Line 101',
                        destination: 'Central Station',
                        time: '3 min',
                      ),
                      BusLineCard(
                        line: 'Line 205',
                        destination: 'Downtown Hub',
                        time: '7 min',
                      ),
                      BusLineCard(
                        line: 'Line 88',
                        destination: 'City Mall',
                        time: '12 min',
                      ),
                      BusLineCard(
                        line: 'Line 42',
                        destination: 'Airport Terminal',
                        time: '15 min',
                      ),
                      BusLineCard(
                        line: 'Line 77',
                        destination: 'University Campus',
                        time: '18 min',
                      ),
                      BusLineCard(
                        line: 'Line 15',
                        destination: 'Beach Boulevard',
                        time: '20 min',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
