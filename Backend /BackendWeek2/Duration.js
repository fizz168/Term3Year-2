export class Duration {
  _totalSeconds;

  constructor(seconds = 0) {
    this._totalSeconds = seconds;
  }

  static fromMinutesAndSeconds(minutes = 0, seconds = 0) {
    return new Duration(minutes * 60 + seconds);
  }
  toString = () => {
    const minutes = Math.floor(this._totalSeconds / 60);
    const seconds = this._totalSeconds % 60;
    return `${minutes}m ${seconds}s`;
  }
  plus = (other) => {
    this._totalSeconds += other; 
    return this._totalSeconds;
  }
  minus = (other) => {
    this._totalSeconds -= other;
    if(this._totalSeconds < 0){
        this._totalSeconds = 0;
        return 0;
    }else{
         return this._totalSeconds;
    }
  }
  
}