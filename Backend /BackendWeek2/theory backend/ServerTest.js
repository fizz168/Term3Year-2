// import http from 'http';
// const http = require('http');
// const server = http.createServer((req, res) => {
//     res.end('hello world');
//     return res.end();

// });
// server.listen(3000, ()=> {
//     console.log('server running on http://localhost:3000');

// }); 

// if i use type module in json have to use the command code cause type : module force node js to es 

// import http from 'http';

// const server = http.createServer((req, res) => {
//     res.end('hello world');
// });

// server.listen(3000, () => {
//     console.log('server running on http://localhost:3000');
// });

const http = require('http');
const server = http.createServer((req, res) => {
    res.write('hello world');
    return res.end();
});
server.listen(3000, () => {
   console.log('server running on http://localhost:3000');
});
