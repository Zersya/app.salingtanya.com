import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/utils/screen_size.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/card_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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

    return listQuestion.when(
      idle: (data) {
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomErrorWidget(
                message: tr('questions.no_question_found'),
                onTap: () {
                  final controller = TextEditingController();
                  CreateQuestionWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
            ),
          );
        }

        if (isGrid) {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  ScreenSize.isBelowExtraLargeScreen(context) ? 2 : 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final question = data[index];
                return QuestionCardWidget(
                  question: question,
                  isSelectable: isSelectable,
                );
              },
              childCount: data.length,
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.builder(
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
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (message) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CustomErrorWidget(
            message: message,
            onTap: () => ref
                .read(
                  isPopular
                      ? popularQuestionsProvider.notifier
                      : latestAddedQuestionsProvider.notifier,
                )
                .getQuestions(isPopular: isPopular),
          ),
        ),
      ),
    );
  }
}
