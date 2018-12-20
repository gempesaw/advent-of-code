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
  if (steps.some(({ duration }) => duration)) {
    const working = steps.filter(({ duration, initialDuration }) => duration < initialDuration);
    const ready = steps
      .filter(({
        prereq,
        duration,
        initialDuration
      }) => prereq.length === 0 && duration === initialDuration);

    return [ ...working, ...ready ];
  }

  return steps.filter(({ prereq }) => prereq.length === 0);
};

const getNextSingle = (steps) => getNext(steps)
  .sort(({ step: a }, { step: b }) => a < b ? -1 : a > b ? 1 : 0)[0];

const order = (done = '', steps) => {
  if (steps.length === 0) {
    return done;
  }

  const { step: nextStep } = getNextSingle(steps);

  return order(`${done}${nextStep}`, steps
    .filter(({ step }) => step !== nextStep)
    .map(({ step, prereq }) => ({
      step,
      prereq: prereq.replace(nextStep, '')
    })));
};

const stepsWithDuration = (steps) => steps.map(({ step, ...rest }) => ({
  step,
  ...rest,
  duration: step.charCodeAt(0) - 4,
  initialDuration: step.charCodeAt(0) - 4
}));

const asRegex = (steps) => new RegExp(`[${steps.map(({ step }) => step).join('')}]`, 'g');

const orderWithDuration = ({ workers }) => ({ done = '', p2steps = [], time = 0 }) => {
  if (p2steps.length === 0) {
    return console.log(JSON.stringify({ done, time: time - 1 }, null, 2));
  }

  const finishedSteps = p2steps.filter(({ duration }) => duration === 0);
  const nextStepsAfterFinished = p2steps
    .filter(({ duration }) => duration > 0)
    .map(({ step, prereq, ...rest }) => ({
      step,
      prereq: prereq.replace(asRegex(finishedSteps), ''),
      ...rest
    }));

  const ticked = getNext(nextStepsAfterFinished)
    .slice(0, workers)
    .map(({ duration, ...rest }) => ({
      ...rest,
      duration: --duration
    }));

  const nextSteps = nextStepsAfterFinished
    .filter(({ step }) => !ticked.some(({ step: tickedStep }) => tickedStep === step))
    .concat(ticked);

  debugger;
  return orderWithDuration({ workers })({
    done: `${done}${finishedSteps.map(({ step }) => step).sort()}`,
    p2steps: nextSteps,
    time: ++time
  });
};

const p2steps = stepsWithDuration(steps);
orderWithDuration({ workers: 5 })({ p2steps });

// console.log(`1: ${order('', steps)}`);
