import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class CreateQuestionWidget extends ConsumerWidget {
  const CreateQuestionWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  Future _onSubmitted(BuildContext context, WidgetRef ref) async {
    if (controller.text.isEmpty) {
      GetIt.I<FlashMessageHelper>().showError('Question cannot be empty');
      return;
    }

    final selected =
        ref.read(selectedFormQuestionCategoryProvider.notifier).state;

    if (selected == null) {
      GetIt.I<FlashMessageHelper>()
          .showError(tr('questions.question_can_not_be_empty'));
      return;
    }

    if (!controller.text.contains('?')) {
      GetIt.I<FlashMessageHelper>()
          .showError(tr('questions.question_must_be_question'));
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
          const Text('questions.you_can_add_question').tr(),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: tr('questions.what_is_your_question'),
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.none,
            onFieldSubmitted: (value) => _onSubmitted(context, ref),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (_, ref, __) {
              final questionCategories = ref.watch(questionCategoriesProvider);
              final selectedCategory =
                  ref.watch(selectedFormQuestionCategoryProvider);

              return questionCategories.maybeWhen(
                idle: (data) => DropdownButtonFormField<QuestionCategory>(
                  decoration: InputDecoration(
                    labelText: tr('questions.category'),
                    border: const OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  hint: const Text('questions.select_category').tr(),
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
                      .read(selectedFormQuestionCategoryProvider.notifier)
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
                  child: const Text('widgets.close').tr(),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _onSubmitted(context, ref),
                  child: const Text('widgets.add').tr(),
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
