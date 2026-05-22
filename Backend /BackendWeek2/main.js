import { Duration } from './Duration.js';



const d = Duration.fromMinutesAndSeconds(1 ,50);

// d.plus(3);
// console.log(d.toString());
console.log(d._totalSeconds); // 80