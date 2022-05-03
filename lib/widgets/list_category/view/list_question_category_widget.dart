import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListQuestionCategoryWidget extends ConsumerWidget {
  const ListQuestionCategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listQuestionCategory = ref.watch(latestQuestionCategoriesProvider);
    final listQuestion = ref
            .watch(latestAddedQuestionsProvider)
            .mapOrNull(idle: (value) => value)
            ?.data ??
        [];

    final scrollController = ScrollController();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 130,
        child: listQuestionCategory.when(
          idle: (data) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final questionCategory = data[index];

                return SizedBox(
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          final questionsByCategory = listQuestion
                              .where(
                                (element) => element.categoryIds
                                    .contains(questionCategory.id),
                              )
                              .map((e) => e.id)
                              .toList();

                          ref.read(selectedQuestionsProvider.notifier).state =
                              questionsByCategory;
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              questionCategory.nameEn,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                  .read(latestQuestionCategoriesProvider.notifier)
                  .getCategories(),
            ),
          ),
        ),
      ),
    );
  }
}
