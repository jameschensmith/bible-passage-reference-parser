## Changelog

May 4, 2017 (2.0.1). Fixed a bug in calculating positions for non-English Psalm titles. Switched to regexgen from frak for more deterministic regular expressions to reduce diff sizes. Added support for Turkish (thanks to [alerque](https://github.com/alerque)).

May 1, 2016 (2.0.0). Added additional Vulgate versification beyond Psalms. Because these changes are technically backwards-incompatible, the major version number is incrementing, but in practice the changes are minor.

November 1, 2015 (1.0.0). Added `punctuation_strategy` option to replace the "eu"-style files that were previously necessary for this functionality. Added `single_chapter_1_strategy` option to allow parsing of "Jude 1" as `Jude.1.1` rather than `Jude.1`. Fixed crashing bug related to dissociated chapter/book ranges. Upgraded to the latest versions of pegjs and Coffeescript. Added npm compatibility. Added support for a "next verse" syntax, which is used in Polish ("n" for next verse, compared to "nn" for "and following"). The parsing grammar includes this support only when the $NEXT variable is set in the language's data.txt file (only Polish for now). Thanks to [nirski](https://github.com/openbibleinfo/Bible-Passage-Reference-Parser/issues/16) for identifying this limitation.

May 4, 2015 (0.10.0). Hand-tuned some of the PEG.js output to improve overall performance by around 50% in most languages.

March 16, 2015 (0.9.0). Added [`parse_with_context()`](#parse_with_context) to let you supply a context for a given string. Added Welsh. Fixed some Somali book names. Added missing punctuation from abbreviations in some languages. Reduced size of "eu" files by omitting needless duplicate code. Improved testing code coverage and added a [fuzz tester](https://github.com/openbibleinfo/Bible-Passage-Reference-Parser/blob/master/bin/fuzz/fuzz_lang.coffee), which uncovered several crashing bugs.

November 3, 2014 (0.8.0). Fixed two bugs related to range rewriting. Updated frak to the latest development version. Added quite a few more languages, bringing the total to 46.

May 2, 2014 (0.7.0). Added the `passage_existence_strategy` option to relax how much validation the parser should do when given a possibly invalid reference. The extensive tests written for this feature uncovered a few other bugs. Added the `book_range_strategy` option to specify how to handle books when they appear in a range. Added [`translation_info()`](#translation_info). Fixed bug when changing versification systems several times and improved support for changing versification systems that rely on a different book order from the default. Updated PEG.js to 0.8.0. Added support for Arabic, Bulgarian, Russian, Thai, and Vietnamese.

November 8, 2013 (0.6.0). Recast English as just another language that uses the same build process as all the other languages. Fixed bug with parentheses in sequences. Made specs runnable using [jasmine-node](https://github.com/mhevery/jasmine-node). Optimized generated regular expressions for speed using [Frak](https://github.com/noprompt/frak). Added support for German, Greek, Italian, and Latin.

May 1, 2013 (0.5.0). Added option to allow case-sensitive book-name matching. Supported parsing `Ps151` as a book rather than a chapter for more-complete OSIS coverage. Added Japanese, Korean, and Chinese book names. Added an additional 90,000 real-world strings, sharing actual counts rather than orders of magnitude.

December 30, 2012 (0.4.0). Per request, added compile tools and Hebrew support.

November 20, 2012 (0.3.0). Improved support for parentheses. Added some alternate versification systems. Added French support. Removed `docs` folder because it was getting unwieldy; the source itself remains commented. Increased the number of real-world strings from 200,000 to 370,000.

May 16, 2012 (0.2.0). Added basic Spanish support. Fixed multiple capital-letter sequences. Upgraded PEG.js and Coffeescript to the latest versions. Deprecated support for IE6 and 7.

November 18, 2011 (0.1.0). First commit.
