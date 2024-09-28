import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/provider.dart'; // Ensure this imports your 'userProvider'
import '../auth/login_screen.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          userAsyncValue.when(
            data: (user) => DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    // ignore: unnecessary_null_comparison
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl)
                        : const AssetImage('images/user.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 33, 242),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 33, 242),
              ),
              child: Center(
                child: Text(
                  "Error loading user data",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            title: const Text('Delete Account'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text('LogOut'),
            onTap: () {
              _showAlertDialog(context);
            },
          ),
          const SizedBox(
            height: 210,
          ),
          userAsyncValue.when(
            data: (user) => ListTile(
              leading: CircleAvatar(
                radius: 30,
                // ignore: unnecessary_null_comparison
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl)
                    : const AssetImage('images/user.png') as ImageProvider,
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(user.email),
              onTap: () {},
            ),
            loading: () => const ListTile(
              title: Text('Loading user...'),
            ),
            error: (error, stackTrace) => const ListTile(
              title: Text('Error loading user'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are You Sure You Want to Log Out?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ),
                    Consumer(builder: (context, WidgetRef ref, child) {
                      return TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LogInScreen()),
                          );
                        },
                        child: const Text("Yes"),
                      );
                    }),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.cancel),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
