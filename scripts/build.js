import { mkdir, readdir } from 'node:fs/promises'
import path from 'node:path'
import { argv } from 'node:process'
import CoffeeScript from 'coffeescript'
import pegjs from 'pegjs'

const compileTestFile = async (lang) => {
  const specSourcePathName = path.join(sourceDir, lang, `${lang}.spec.coffee`)
  const specFile = Bun.file(specSourcePathName)
  const compiledCode = CoffeeScript.compile(await specFile.text())
  const specDestPathName = path.join(testDir, `${lang}.spec.js`)
  await Bun.write(specDestPathName, compiledCode)
}

const generateParser = async (lang) => {
  const grammarSourcePathName = path.join(sourceDir, lang, 'grammar.pegjs')
  const grammarFile = await Bun.file(grammarSourcePathName)
  const parser = pegjs.generate(await grammarFile.text(), {
    exportVar: 'grammar',
    format: 'globals',
    output: 'source',
  })

  const sequenceRegexVar = parser.match(
    /function peg\$parsesequence_sep\(\) \{\s+var s.+;\s+s0 =.+\s+s1 =.+\s+if \((peg\$c\d+)\.test/
  )[1]
  if (!sequenceRegexVar) throw new Error('No sequence var')

  const escapedRegex = sequenceRegexVar.replace(/([.\\+*?[^\]$()])/g, '\\$1')
  const sequenceRegexValue = parser.match(
    new RegExp(`${escapedRegex} = \\/\\^\\[,([^\\]]+?\\]\\/)`)
  )[1]
  if (!sequenceRegexValue) throw new Error('No sequence value')

  const modifiedParser =
    'var grammar;\n' +
    parser
      .replace(
        /function peg\$parsespace\(\) \{(?:(?:.|\n)(?!return s0))*?.return s0;\s*\}/,
        `function peg$parsespace() {
      var res;
      if (res = /^[\\s\\xa0*]+/.exec(input.substr(peg$currPos))) {
        peg$currPos += res[0].length;
        return [];
      }
      return peg$FAILED;
    }`
      )
      .replace(
        /function peg\$parseinteger\(\) \{(?:(?:.|\n)(?!return s0))*?.return s0;\s*\}/,
        `function peg$parseinteger() {
      var res;
      if (res = /^[0-9]{1,3}(?!\\d|,000)/.exec(input.substr(peg$currPos))) {
      	peg$savedPos = peg$currPos;
        peg$currPos += res[0].length;
        return {"type": "integer", "value": parseInt(res[0], 10), "indices": [peg$savedPos, peg$currPos - 1]}
      } else {
        return peg$FAILED;
      }
    }`
      )
      .replace(
        /(function text\(\) \{)/,
        `if ("punctuation_strategy" in options && options.punctuation_strategy === "eu") {
        peg$parsecv_sep = peg$parseeu_cv_sep;
        ${sequenceRegexVar} = /^[${sequenceRegexValue};
    }\n\n    $1`
      )
      .replace(/ \\t\\r\\n\\xa0/gi, '\\s\\xa0')
      .replace(/\broot\.grammar/, 'grammar')

  if (/parse(?:space|integer)\(\) \{\s+var s/i.test(modifiedParser))
    throw new Error(`Unreplaced PEG space: ${modifiedParser}`)

  if (!/"punctuation_strategy"/.test(modifiedParser))
    throw new Error('Unreplaced options')

  return modifiedParser
}

const compileSourceFile = async (lang) => {
  const parser = await generateParser(lang)

  const joinedFiles = (
    await Promise.all(
      [
        path.join(sourceDir, 'core', 'bcv_parser.coffee'),
        path.join(sourceDir, 'core', 'bcv_passage.coffee'),
        path.join(sourceDir, 'core', 'bcv_utils.coffee'),
        path.join(sourceDir, lang, 'translations.coffee'),
        path.join(sourceDir, lang, 'regexps.coffee'),
      ].map(async (fileName) => {
        const file = Bun.file(fileName)
        return await file.text()
      })
    )
  ).join('')
  const compiledCode = CoffeeScript.compile(joinedFiles)

  const finalCode = compiledCode.replace(
    /(\s*\}\)\.call\(this\);\s*)$/,
    `\n${parser}$1`
  )
  if (compiledCode === finalCode) throw new Error('PEG not successfully added')

  const sourceDestPathName = path.join(jsDir, `${lang}_bcv_parser.js`)
  await Bun.write(sourceDestPathName, finalCode)
}

const rootPath = path.resolve(__dirname, '..')
const jsDir = path.join(rootPath, 'js')
const sourceDir = path.join(rootPath, 'src')
const testDir = path.join(rootPath, 'test', 'js')

const argLang = argv[2]

await mkdir(testDir, { recursive: true })

await Promise.all(
  (await readdir(sourceDir))
    .filter((lang) => (argLang ? lang === argLang : true))
    .map(async (lang) => {
      await compileTestFile(lang)
      if (lang === 'core') return
      await compileSourceFile(lang)
    })
)
