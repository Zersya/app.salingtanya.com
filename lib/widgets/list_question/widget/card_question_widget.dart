import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionCardWidget extends ConsumerWidget {
  const QuestionCardWidget({
    Key? key,
    required this.question,
    required this.isSelectable,
    this.width = 200,
  }) : super(key: key);

  final Question question;
  final bool isSelectable;
  final double width;

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
      width: width,
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: ColorName.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
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
                      ? Theme.of(context).primaryColor
                      : ColorName.white,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  listQuestionCategory.map((e) => e.nameId).join(', '),
                  style: TextStyle(
                    color: selectedQuestions.contains(question.id)
                        ? ColorName.white
                        : Theme.of(context).primaryColor,
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
