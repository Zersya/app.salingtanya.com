import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionCardWidget extends ConsumerWidget {
  const QuestionCardWidget({
    Key? key,
    required this.question,
    required this.isSelectable,
    this.onTapEmoji,
    this.width = 200,
  }) : super(key: key);

  final Question question;
  final bool isSelectable;
  final double width;
  final Function(String)? onTapEmoji;

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
                borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: ColorName.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                  GetIt.I<SharedPreferences>().getString(kDefaultLanguage) ==
                          'id'
                      ? listQuestionCategory.map((e) => e.nameId).join(', ')
                      : listQuestionCategory.map((e) => e.nameEn).join(', '),
                  style: TextStyle(
                    color: selectedQuestions.contains(question.id)
                        ? ColorName.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          if (onTapEmoji != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32, right: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _EmojiWidget(
                      emoji: '\u{1F600}',
                      onTapEmoji: onTapEmoji,
                    ),
                    const SizedBox(width: 4),
                    _EmojiWidget(
                      emoji: '\u{1F60D}',
                      onTapEmoji: onTapEmoji,
                    ),
                    const SizedBox(width: 4),
                    _EmojiWidget(
                      emoji: '\u{1F602}',
                      onTapEmoji: onTapEmoji,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _EmojiWidget extends ConsumerWidget {
  const _EmojiWidget({
    Key? key,
    required this.onTapEmoji,
    required this.emoji,
  }) : super(key: key);

  final Function(String p1)? onTapEmoji;
  final String emoji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojis = ref.watch(selectedRoomProvider)?.activeQuestionEmojis ?? [];

    return InkWell(
      onTap: () => onTapEmoji?.call(emoji),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(48)),
        ),
        child: Row(
          children: [
            Text(
              emojis.where((element) => element == emoji).length.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
