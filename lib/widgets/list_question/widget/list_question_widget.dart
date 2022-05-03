import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
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
                  return _QuestionCardWidget(
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
                return _QuestionCardWidget(
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

class _QuestionCardWidget extends ConsumerWidget {
  const _QuestionCardWidget({
    Key? key,
    required this.question,
    required this.isSelectable,
  }) : super(key: key);

  final Question question;
  final bool isSelectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQuestions = ref.watch(selectedQuestionsProvider);
    final listQuestionCategory = ref
            .watch(latestQuestionCategoriesProvider)
            .mapOrNull(idle: (value) => value)
            ?.data
            .where((element) => question.categoryIds.contains(element.id)) ??
        [];

    return SizedBox(
      width: 200,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: InkWell(
                onTap: isSelectable
                    ? () {
                        final isExistsOnSelected =
                            selectedQuestions.contains(question.id);

                        late List<String> newSelectedQuestions;
                        if (isExistsOnSelected) {
                          newSelectedQuestions = selectedQuestions.toList()
                            ..remove(question.id);
                        } else {
                          newSelectedQuestions = selectedQuestions.toList()
                            ..add(question.id);
                        }

                        ref.read(selectedQuestionsProvider.notifier).state =
                            newSelectedQuestions;
                      }
                    : null,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: selectedQuestions.contains(question.id)
                    //     ? ColorName.white
                    //     : null,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: ColorName.white,
                      border: Border.all(color: ColorName.info),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    height: double.infinity,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Text(
                      question.value.capitalize,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedQuestions.contains(question.id)
                      ? ColorName.info
                      : ColorName.white,
                  border: Border.all(color: ColorName.info),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  listQuestionCategory.map((e) => e.nameId).join(', '),
                  style: TextStyle(
                    color: selectedQuestions.contains(question.id)
                        ? ColorName.white
                        : ColorName.info,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
