const http = require('http');

const server = http.createServer((req, res) => {
const{method, url} = req;
if(method === 'GET' && url === '/about'){
    res.writeHead(200, {'content-type' : 'text/plain'});
    // res.end("About us: at CADT , we love Node.js")
}else if(method === 'GET' && url === '/contact-us'){
    res.writeHead(200,{'content-type' : 'text/plain'});
    res.end("You can reach us via email");
}else if(method === 'GET' && url === '/products'){
    res.writeHead(200,{'content-type' : 'text/plain'});
    res.end("Buy one get one");
}else if(method === 'GET' & url === '/projects'){
    res.writeHead(200,{'content-type' : 'text/plain'});
    res.end("Here are our awesome projects");
}else{
    res.writeHead(404,{'content-type' : 'text/plain'})
    res.end('error 404');
}
});
server.listen(3000, () => {
    console.log("server run on port 3000");
});