const http = require('http');

const port = process.env.PORT || 4000;

const server = http.createServer((request, response) => {  
  response.writeHead(200, { "Content-Type" : "text/html"});
  response.write(`
    <html>
        <head>
            <title>NodeJS Docker PM2</title>
        </head>
        <body>
            <h1>Hello world!!</h1>
        </body>
    </html>
  `)
  response.end();
});

server.on('error', (error) => {
  console.error('Server error: ', error);
});

server.on('listening', () => {
  console.log(`Server is listening on port ${port}`);
});

server.listen(port);