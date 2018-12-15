const fs = require('fs');

// const input = `Step C must be finished before step A can begin.
// Step C must be finished before step F can begin.
// Step A must be finished before step B can begin.
// Step A must be finished before step D can begin.
// Step B must be finished before step E can begin.
// Step D must be finished before step E can begin.
// Step F must be finished before step E can begin.
// `;

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8');

const steps = Object.entries(input.split('\n').filter(Boolean).reduce((steps, line) => {
  const [ , prereq ] = line.match(/Step (\w)/);
  const [ , step ] = line.match(/before step (\w)/);

  return {
    ...steps,
    [step]: `${steps[step] || ''}${prereq}`,
    [prereq]: `${steps[prereq] || ''}`
  };
}, {}))
  .map(([step, prereq]) => ({ step, prereq }));

const getNext = (steps) => {
  const next = steps.filter(({ prereq }) => prereq.length === 0);

  return next.sort(({ step: a }, { step: b }) => a < b ? -1 : a > b ? 1 : 0)[0];
};

const order = (done = '', steps) => {
  if (steps.length === 0) {
    return done;
  }

  const { step: nextStep } = getNext(steps);

  return order(`${done}${nextStep}`, steps
    .filter(({ step }) => step !== nextStep)
    .map(({ step, prereq }) => ({
      step,
      prereq: prereq.replace(nextStep, '')
    })));
};

console.log(order('', steps));
