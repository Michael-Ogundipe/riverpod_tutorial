import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'Diana',
  'Eve',
  'Fred',
  'Gina',
  'Harriet',
  'Ilene',
  'Joseph',
  'Kincaid',
  'Larry',
];

final tickerProvider = StreamProvider((ref) {
  return Stream.periodic(
    const Duration(
      seconds: 1,
    ),
    (i) => i + 1,
  );
});

final nameProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(0, count),
      ),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamProvider'),
      ),
      body: names.when(
        data: (names){
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                    title: Text(names.elementAt(index)),
              );
            },
          );
        },
        error: (error, stack) => const Text('Reached the end of the list!'),
        loading: ()=> const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
