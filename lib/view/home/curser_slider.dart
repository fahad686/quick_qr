import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/provider.dart';

class QrCarouselSlider extends ConsumerWidget {
  const QrCarouselSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the allusersProvider stream to get real-time data
    final userAsyncValue = ref.watch(allusersProvider);

    return userAsyncValue.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        // Display carousel slider with users
        return CarouselSlider(
          options: CarouselOptions(
            height: 210.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
          ),
          items: users.map((user) {
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  elevation: 12,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.purpleAccent,
                          offset: Offset(1, 1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (user.profileImageUrl.isNotEmpty)
                            CircleAvatar(
                              radius: 37,
                              backgroundImage:
                                  NetworkImage(user.profileImageUrl),
                            )
                          else
                            const CircleAvatar(
                              radius: 37,
                              child: Icon(Icons.person),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(user.email),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
