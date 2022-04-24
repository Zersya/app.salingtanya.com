part of '../dashboard_page.dart';


class _CreateQuestionWidget extends ConsumerWidget {
  const _CreateQuestionWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  Future _onSubmitted(BuildContext context, WidgetRef ref) async {
    if (controller.text.isEmpty) {
      GetIt.I<FlashMessageHelper>().showError('Question cannot be empty');
      return;
    }

    final selected = ref.read(selectedQuestionCategoryProvider.notifier).state;

    if (selected == null) {
      GetIt.I<FlashMessageHelper>().showError('Please select a category');
      return;
    }

    if(!controller.text.contains('?')) {
      GetIt.I<FlashMessageHelper>().showError('Please input a question');
      return;
    }



    await ref
        .read(createQuestionProvider.notifier)
        .createQuestion(controller.text, [selected.id]);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createQuestion = ref.watch(createQuestionProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'What is the Question?',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.none,
            onSubmitted: (value) => _onSubmitted(context, ref),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (_, ref, __) {
              final questionCategories = ref.watch(questionCategoriesProvider);
              final selectedCategory =
              ref.watch(selectedQuestionCategoryProvider);

              return questionCategories.maybeWhen(
                idle: (data) => DropdownButton<QuestionCategory>(
                  isExpanded: true,
                  hint: const Text('Select a category'),
                  value: selectedCategory,
                  items: data
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.nameEn),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => ref
                      .read(selectedQuestionCategoryProvider.notifier)
                      .state = value,
                ),
                orElse: () => const LinearProgressIndicator(),
              );
            },
          ),
          const SizedBox(height: 16),
          createQuestion.when(
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
                  child: const Text('Close'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _onSubmitted(context, ref),
                  child: const Text('Add'),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
