part of '../dashboard_page.dart';

class _ListQuestionWidget extends ConsumerWidget {
  const _ListQuestionWidget({Key? key, required this.isPopular})
      : super(key: key);

  final bool isPopular;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listQuestion = ref.watch(
      isPopular ? popularQuestionsProvider : latestAddedQuestionsProvider,
    );

    final scrollController = ScrollController();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 130,
        child: listQuestion.when(
          idle: (data) {
            if (data.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CustomErrorWidget(
                  message:
                  'No questions has been made\nTap the button to create one',
                  onTap: () {
                    final controller = TextEditingController();
                    _CreateQuestionWidget(controller: controller)
                        .showCustomDialog<void>(context);
                  },
                ),
              );
            }

            return Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final question = data[index];
                  return SizedBox(
                    width: 220,
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            question.value.capitalize,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (message) => Padding(
            padding: const EdgeInsets.all(8),
            child: CustomErrorWidget(
              message: message,
              onTap: () => ref
                  .read(latestAddedQuestionsProvider.notifier)
                  .getQuestions(),
            ),
          ),
        ),
      ),
    );
  }
}
