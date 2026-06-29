import { Duration } from "./duration.js";

const d1 = new Duration(90); 
const d2 = Duration.fromMinutesAndSeconds(2, 15); 

console.log("Duration 1:", d1.toString());
console.log("Duration 2:", d2.toString());

const sum = d1.plus(d2);
console.log("Sum:", sum.toString());

const difference = d2.minus(d1);
console.log("Difference:", difference.toString());