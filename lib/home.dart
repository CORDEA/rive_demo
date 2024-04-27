import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SMITrigger finishTrigger;
  late SMIBool bInput;
  String text = 'Timeline A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: RiveAnimation.asset(
                'assets/demo.riv',
                onInit: (artboard) {
                  final stateMachine = StateMachineController.fromArtboard(
                    artboard,
                    'State Machine',
                  )!;
                  stateMachine.isActiveChanged.addListener(() async {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        text = 'Finished';
                      });
                    });
                  });
                  stateMachine.addEventListener((event) async {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        switch (event.name) {
                          case 'A Done':
                            text = 'Timeline B';
                          case 'B Done':
                            text = 'Timeline Finish';
                        }
                      });
                    });
                  });
                  finishTrigger =
                      stateMachine.getTriggerInput('Trigger Finish')!;
                  bInput = stateMachine.getBoolInput('Boolean B')!;
                  artboard.addController(stateMachine);
                },
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                bInput.value = true;
              },
              child: const Text('Move to B'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                finishTrigger.fire();
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
