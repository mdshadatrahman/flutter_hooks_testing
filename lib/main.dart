import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

const url = 'https://images.freeimages.com/images/large-previews/643/sparkler-1170719.jpg';

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

@immutable
class State {
  final double rotationDeg;
  final double alpha;

  const State({required this.rotationDeg, required this.alpha});

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(rotationDeg: rotationDeg + 10, alpha: alpha);
  State rotateLeft() => State(rotationDeg: rotationDeg - 10, alpha: alpha);
  State increaseAlpha() => State(rotationDeg: rotationDeg, alpha: min(alpha + 0.1, 1.0));
  State decreaseAlpha() => State(rotationDeg: rotationDeg, alpha: max(alpha - 0.1, 0.0));
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateLeft);
                },
                child: const Text(
                  'Rotate Left',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateRight);
                },
                child: const Text(
                  'Rotate Right',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.lessVisible);
                },
                child: const Text(
                  'Less visible',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.moreVisible);
                },
                child: const Text(
                  'More visible',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360.0),
              child: Image.network(url),
            ),
          ),
        ],
      ),
    );
  }
}
