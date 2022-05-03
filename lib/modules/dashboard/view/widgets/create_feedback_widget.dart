part of '../dashboard_page.dart';

class _CreateFeedbackWidget extends ConsumerWidget {
  const _CreateFeedbackWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  Future _onSubmitted(BuildContext context, WidgetRef ref) async {
    if (controller.text.isEmpty) {
      GetIt.I<FlashMessageHelper>().showError('Feedback cannot be empty');
      return;
    }

    await ref
        .read(createFeedbackProvider.notifier)
        .createFeedback(controller.text);
    GetIt.I<FlashMessageHelper>().showTopFlash('Thank you for your feedback');

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createFeedback = ref.watch(createFeedbackProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Your feedback is important to us',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'What is your feedback?',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textInputAction: TextInputAction.none,
            onFieldSubmitted: (value) => _onSubmitted(context, ref),
          ),
          const SizedBox(height: 16),
          createFeedback.when(
            idle: () => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _onSubmitted(context, ref),
                  child: const Text('Send'),
                ),
              ],
            ),
            loading: () => const Align(
              alignment: Alignment.centerRight,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
