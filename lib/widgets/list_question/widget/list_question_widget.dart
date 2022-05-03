import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/card_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListQuestionWidget extends ConsumerWidget {
  const ListQuestionWidget({
    Key? key,
    required this.isPopular,
    this.isGrid = false,
    this.isSelectable = false,
  }) : super(key: key);

  final bool isPopular;
  final bool isGrid;
  final bool isSelectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listQuestion = ref.watch(
      isPopular ? popularQuestionsProvider : latestAddedQuestionsProvider,
    );

    final scrollController = ScrollController();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: isGrid ? MediaQuery.of(context).size.height : 250,
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
                    CreateQuestionWidget(controller: controller)
                        .showCustomDialog<void>(context);
                  },
                ),
              );
            }

            if (isGrid) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final question = data[index];
                  return QuestionCardWidget(
                    question: question,
                    isSelectable: isSelectable,
                  );
                },
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final question = data[index];
                return QuestionCardWidget(
                  question: question,
                  isSelectable: isSelectable,
                );
              },
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
                  .read(
                    isPopular
                        ? popularQuestionsProvider.notifier
                        : latestAddedQuestionsProvider.notifier,
                  )
                  .getQuestions(),
            ),
          ),
        ),
      ),
    );
  }
}
