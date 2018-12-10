const fs = require('fs');
const assert = require('assert');
const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');

// memoize this by alphabetizing the inputs and calling it again to
// save on double comparisons? lol
const diff = (string1, string2) => {
  if (string1 === string2) {
    return { diffCount: 0 };
  }

  const chars1 = string1.split('');
  const chars2 = string2.split('');

  const sameChars = chars1.filter((char, index) => char === chars2[index]).join('');
  return { sameChars, diffCount: chars1.length - sameChars.length };
};

const strings = [
  'abcde',
  'fghij',
  'klmno',
  'pqrst',
  'fguij',
  'axcye',
  'wvxyz'
];

const findDiffCount1 = (strings) => strings.map((a) => strings.map((b) => diff(a, b)))
  .reduce((a, b) => a.concat(b))
  .filter(({ diffCount }) => diffCount === 1);

(() => {
  const [{ sameChars }] = findDiffCount1(strings);
  assert.equal(sameChars, 'fgij');
})();

const [{ sameChars }] = findDiffCount1(input);
console.log(JSON.stringify(sameChars, null, 2));
