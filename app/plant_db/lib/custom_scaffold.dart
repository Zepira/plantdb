import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final List<Map<String, dynamic>> breadcrumbs; // Updated to include route info

  const CustomScaffold({
    Key? key,
    required this.body,
    this.breadcrumbs = const [], // Default to an empty list
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            height: 200,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/ghibli_banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Garden Database',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (breadcrumbs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: breadcrumbs.asMap().entries.map((entry) {
                            final isLast = entry.key == breadcrumbs.length - 1;
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!isLast) {
                                      Navigator.pushNamed(
                                          context, entry.value['route']);
                                    }
                                  },
                                  child: Text(
                                    entry.value['label'],
                                    style: TextStyle(
                                      color: isLast
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.7),
                                      fontWeight: isLast
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: body,
        ),
      ),
    );
  }
}
