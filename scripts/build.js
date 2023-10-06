import { readdir } from 'node:fs/promises'
import path from 'node:path'
import CoffeeScript from 'coffeescript'

const compileTestFile = async (lang) => {
  const specSourcePathName = path.join(sourceDir, lang, 'spec.coffee')
  const specFile = Bun.file(specSourcePathName)
  const compiledCode = CoffeeScript.compile(await specFile.text())
  const specDestPathName = path.join(testDir, `${lang}.spec.js`)
  await Bun.write(specDestPathName, compiledCode)
}

const rootPath = path.resolve(__dirname, '..')
const sourceDir = path.join(rootPath, 'src')
const testDir = path.join(rootPath, 'test', 'js')
await Promise.all(
  (await readdir(sourceDir))
    .filter((lang) => lang !== 'template')
    .map(async (lang) => {
      await compileTestFile(lang)
    })
)
